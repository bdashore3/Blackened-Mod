#!/system/bin/sh

#Install script for BlackenedMod

#Copy zipalign script
cp -af $INSTALLER/common/Zipalign_sqlite.sh /data/adb/service.d
chmod 0755 /data/adb/service.d/Zipalign_sqlite.sh

#set device variable
device="$(getprop ro.product.device)"
if [ $device == "marlin" ] || [ $device == "sailfish"] ; then
	ui_print " "; ui_print "You are using Pixel(XL), removing wahoo files"
	cp -af $INSTALLER/common/marlin/02BlackenedMod.sh /data/adb/service.d
	chmod 0755 /data/adb/service.d/02BlackenedMod.sh
	rm -r $INSTALLER/common/marlin
	rm -r $INSTALLER/common/wahoo
	ui_print "Done"
elif [ $device == "walleye" ] || [ $device == "taimen"] ; then
	ui_print "You are using Pixel 2(XL), removing OG pixel files"
	cp -af $INSTALLER/common/wahoo/02BlackenedMod.sh /data/adb/service.d
	chmod 0755 /data/adb/service.d/02BlackenedMod.sh
	rm -r $INSTALLER/common/marlin
	rm -r $INSTALLER/common/wahoo
	ui_print "Done"
else
	ui_print "You are not on Pixel or Pixel 2! Aborting..."
	exit
fi;
