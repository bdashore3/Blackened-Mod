# This script will be executed in late_start service mode
# More info in the main Magisk thread
chmod 0755 '02BlackenedMod.sh'
chmod 0755 'Zipalign_sqlite.sh'
sh '02BlackenedMod.sh'
sh 'Zipalign_sqlite.sh'
