#!/system/bin/sh
keytest() {
  ui_print "** Vol Key Test **"
  ui_print "** Press Vol UP **"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
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

#actuall stuff

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
KEYCHECK=$INSTALLER/common/keycheck
chmod 755 $KEYCHECK

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
ui_print "You can either uninstall the sqlite tweaks or the whole mod"
ui_print "Please indicate your choice..."
ui_print " "
ui_print "   Vol(+) = Just Sqlite"
ui_print "   Vol(-) = Whole Mod"
ui_print " "
if $FUNCTION; then
    ui_print " Uninstalling Sqlite tweaks... "
    rm -r /data/adb/service.d/Zipalign_sqlite.sh
    ui_print " "
else
    ui_print " Removing Whole mod..."
    ui_print "We're sorry to see you go..."
    rm -r /data/adb/service.d/03KingKernel.sh
    rm -r /data/adb/service.d/02BlackenedMod.sh
    rm -r /data/adb/service.d/Zipalign_sqlite.sh
    ui_print " "
fi;
