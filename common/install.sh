#!/system/bin/sh

keytest() {
  ui_print "** Vol Key Test **"
  ui_print "** Press Vol UP **"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}

set_bindir(){
  local bindir=/system/bin
  local xbindir=/system/xbin

  # Check for existence of /system/xbin directory.
  if [ ! -d /sbin/.core/mirror$xbindir ]; then
    # Use /system/bin instead of /system/xbin.
    mkdir -p $MODPATH$bindir
    mv $MODPATH$xbindir/sqlite3 $MODPATH$bindir
    rmdir $MODPATH$xbindir
    xbindir=$bindir
 fi

 ui_print "- Installed to $xbindir"
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while true; do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $KEYCHECK
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "**  Vol key not detected **"
    abort "** Use name change method in TWRP **"
  fi
}

#Install script for BlackenedMod

#Remove old versions
ui_print " "; ui_print "Removing old versions..."
rm -r /data/adb/service.d/02BlackenedMod.sh
rm -r /data/adb/service.d/Zipalign_sqlite.sh
rm -r /data/adb/service.d/03KingKernel.sh

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
KEYCHECK=$INSTALLER/common/keycheck
chmod 755 $KEYCHECK

#set device variable
device="$(getprop ro.product.device)"
if [ $device == "marlin" ] || [ $device == "sailfish" ] ; then
	ui_print " "; ui_print "You are using Pixel(XL), removing other files"
    kernelver=$(uname -a)
    #check for KingKernel and install its boot tweaks
	case "$kernelver" in
	  *KingKernel*)
		  ui_print " "; ui_print "You're using KingKernel, nice! Applying my modified version of BM..."
		  cat $INSTALLER/common/marlin/03KingKernel.sh >> $INSTALLER/common/service.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
      *)
		  cat $INSTALLER/common/marlin/02BlackenedMod.sh >> $INSTALLER/common/service.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
	esac
elif [ $device == "walleye" ] || [ $device == "taimen" ] ; then
    ui_print "You are using Pixel 2(XL), removing other files"
    kernelver=$(uname -a)
	case "$kernelver" in
	  *KingKernel*)
		  ui_print " "; ui_print "You're using KingKernel, nice! Applying my modified version of BM..."
		  cat $INSTALLER/common/wahoo/03KingKernel.sh >> $INSTALLER/common/service.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
      *)
		  cat $INSTALLER/common/wahoo/02BlackenedMod.sh >> $INSTALLER/common/service.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
	esac
elif [ $device == "crosshatch" ] || [ $device == "blueline" ] ; then
    ui_print "You are using Pixel 3(XL), removing other pixel files"
    cat $INSTALLER/common/bluecross/02BlackenedMod.sh >> $INSTALLER/common/service.sh
    rm -r $INSTALLER/common/marlin
    rm -r $INSTALLER/common/wahoo
    rm -r $INSTALLER/common/bluecross
else
	ui_print "You are not on a pixel device, Don't try to cheat! Aborting..."
	exit
fi;

ui_print " "
if keytest; then
    FUNCTION=chooseport
else
    FUNCTION=chooseportold
    ui_print "** Volume button programming **"
    ui_print " "
    ui_print "** Press Vol UP again **"
    $FUNCTION "UP"
    ui_print "**  Press Vol DOWN **"
    $FUNCTION "DOWN"
fi
ui_print "There are Zipalign and SQlite tweaks in BlackenedMod"
ui_print "These can enhance battery life and make the device run smoother"
ui_print "However, apps can stop working with sqlite tweaks"
ui_print "Please indicate whether you want them"
ui_print " "
ui_print "   Vol(+) = Yes"
ui_print "   Vol(-) = No"
ui_print " "
if $FUNCTION; then
    ui_print " Cool! Installing Sqlite tweaks... "
    ui_print " "
    set_bindir
    cat $INSTALLER/common/Zipalign_sqlite.sh >> $INSTALLER/common/service.sh
    rm -rf $INSTALLER/common/Zipalign_sqlite.sh
    ui_print " "
else
    ui_print " Skipping Sqlite Tweaks..."
    ui_print " "
fi;
