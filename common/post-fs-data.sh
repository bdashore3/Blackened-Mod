# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

#Force enable cpu3 
echo "1" /sys/devices/system/cpu/cpu3/online

# Trim selected partitions at boot for a more than well-deserved and nice speed boost;
fstrim /data;
fstrim /cache;
fstrim /system;
