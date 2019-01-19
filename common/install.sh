#!/system/bin/sh

#Install script for BlackenedMod

#Remove old versions
ui_print " "; ui_print "Removing old versions..."
rm -r /data/adb/service.d/02BlackenedMod.sh
rm -r /data/adb/service.d/Zipalign_sqlite.sh
rm -r /data/adb/service.d/03KingKernel.sh

cp -af $INSTALLER/common/Zipalign_sqlite.sh /data/adb/service.d
chmod 0755 /data/adb/service.d/Zipalign_sqlite.sh

#set device variable
device="$(getprop ro.product.device)"
if [ $device == "marlin" ] || [ $device == "sailfish" ] ; then
	ui_print " "; ui_print "You are using Pixel(XL), removing other files"
    kernelver=$(uname -a)
    #check for KingKernel and install its boot tweaks
	case "$kernelver" in
	  *KingKernel*)
		  ui_print " "; ui_print "You're using KingKernel, nice! Applying my modified version of BM..."
		  cp -af $INSTALLER/common/marlin/03KingKernel.sh /data/adb/service.d
		  chmod 0755 /data/adb/service.d/03KingKernel.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
      *)
		  cp -af $INSTALLER/common/marlin/02BlackenedMod.sh /data/adb/service.d
		  chmod 0755 /data/adb/service.d/02BlackenedMod.sh
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
		  cp -af $INSTALLER/common/wahoo/03KingKernel.sh /data/adb/service.d
		  chmod 0755 /data/adb/service.d/03KingKernel.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
      *)
		  cp -af $INSTALLER/common/wahoo/02BlackenedMod.sh /data/adb/service.d
		  chmod 0755 /data/adb/service.d/02BlackenedMod.sh
		  rm -r $INSTALLER/common/marlin
		  rm -r $INSTALLER/common/wahoo
          rm -r $INSTALLER/common/bluecross
		  ;;
	esac
elif [ $device == "walleye" ] || [ $device == "taimen" ] ; then
    ui_print "You are using Pixel 3(XL), removing other pixel files"
    cp -af $INSTALLER/common/bluecross/02BlackenedMod.sh /data/adb/service.d
    chmod 0755 /data/adb/service.d/02BlackenedMod.sh
    rm -r $INSTALLER/common/marlin
    rm -r $INSTALLER/common/wahoo
    rm -r $INSTALLER/common/bluecross
else
	ui_print "You are not on Pixel or Pixel 2! Aborting..."
	exit
fi;
