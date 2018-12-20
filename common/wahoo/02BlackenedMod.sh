#!/system/bin/sh

#
# BlackenedMod v9.1 (Test Build #3) by the open source # loving BlackenedMod team over at XDA-developers;
# Various strictly selected, carefully optimized & adjusted       # tweaks for better day to day performance & battery life,
# specially tuned for the Wahoo / Google Pixel 2 line-up;
#

# Pause script execution a little for Magisk Boot Service;
sleep 44;

# Disable sysctl.conf to prevent ROM interference
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system;
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak;
  mount -o remount,ro /system;
fi;

# Add the full possibilty to either disable and / or enable a few Google Play Services background based services;
# pm disable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService;
# pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService;
# pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService;
# pm disable com.google.android.gms/com.google.android.gms.analytics.internal.PlayLogReportingService 
# pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.RingService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.NetworkQualityAndroidService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.MdmPhoneWearableListenerService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.LockscreenMessageService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.DeviceManagerApiService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.services.GcmReceiverService;
# pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver;
# pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.RetryAfterAlarmReceiver;
# pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceImposeReceiver;
# pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceSecretCodeReceiver;
# pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceTriggerReceiver;
# pm disable com.google.android.gms/com.google.android.gms.checkin.EventLogService;
# pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinService;
# pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinApiService;
# pm disable com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService

# Mounting tweak for better overall partition performance;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /system;

# Use my own enhanced CPUSet configuration for gaining a massively improvement in performance, battery life & system responsivness, without any notable tradeoffs or regressions;
echo "6-7" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/foreground/cpus
echo "4-5" > /dev/cpuset/kernel/cpus
echo "4-7" > /dev/cpuset/restricted/cpus
echo "4-7" > /dev/cpuset/system-background/cpus
echo "0-7" > /dev/cpuset/top-app/cpus

# Enable schedtune foreground and gain a well deserved smoothness boost with one extra snap on top of it;
echo "8" > /dev/stune/foreground/schedtune.boost

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "2560" > /proc/sys/kernel/random/write_wakeup_threshold

# Kernel based tweaks that reduces the total amount of wasted CPU cycles and gives back a huge amount of needed performance as well as battery life savings to both the whole system and the user experience itself;
echo "0" > /proc/sys/kernel/compat-log
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given for slightly improved system stability and minimized chance of system freezes & lockups;
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "0" > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "1500" > /proc/sys/net/ipv4/tcp_probe_interval
echo "48" > /proc/sys/net/ipv6/ip6frag_time

# Virtual Memory tweaks & enhancements for a massively improved balance between performance and battery life;
echo "0" > /proc/sys/vm/compact_unevictable_allowed
echo "3" > /proc/sys/vm/dirty_background_ratio
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "30" > /proc/sys/vm/dirty_ratio
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "1200" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swap_ratio
echo "20" > /proc/sys/vm/swappiness
echo "60" > /proc/sys/vm/vfs_cache_pressure

# Turn off all debug_mask based sysfs kernel tunables;
for i in $(find /sys/ -name debug_mask); do
echo "0" > $i;
done

# Turn off all debug_level based sysfs kernel tunables;
for i in $(find /sys/ -name debug_level); do
echo "0" > $i;
done

# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ce); do
echo "0" > $i;
done

# Turn off all edac logging kernel based sysfs tunables;
for i in $(find /sys/ -name edac_mc_log_ue); do
echo "0" > $i;
done

# Turn off a few event logging based sysfs kernel tunables;
for i in $(find /sys/ -name enable_event_log); do
echo "0" > $i;
done

# Turn off a few ECN kernel based sysfs loggers;
for i in $(find /sys/ -name log_ecn_error); do
echo "0" > $i;
done

# Turn off all snapshot crashdumper modules;
for i in $(find /sys/ -name snapshot_crashdumper); do
echo "0" > $i;
done

# Disable gesture based vibration because it is honestly not even worth having enabled at all;
echo "0" > /sys/android_touch/vib_strength

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo 0 > $i/add_random;
  echo 0 > $i/iostats;
  echo 0 > $i/nomerges;
  echo 128 > $i/read_ahead_kb;
  echo 0 > $i/rotational;
  echo 1 > $i/rq_affinity;
done;

# Disable GPU frequency based throttling because it is actually not even needed anymore after all the GPU related enhancements and minor changes that I've done so far;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster critically needed network speed and performance;
echo "128" > /sys/class/net/bond0/tx_queue_len
echo "128" > /sys/class/net/dummy0/tx_queue_len
echo "128" > /sys/class/net/ip6_vti0/tx_queue_len
echo "128" > /sys/class/net/ip6tnl0/tx_queue_len
echo "128" > /sys/class/net/ip_vti0/tx_queue_len
echo "128" > /sys/class/net/lo/tx_queue_len
echo "128" > /sys/class/net/p2p0/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data0/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data1/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data2/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data3/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data4/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data5/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data6/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data7/tx_queue_len
echo "128" > /sys/class/net/r_rmnet_data8/tx_queue_len
echo "128" > /sys/class/net/rmnet_data0/tx_queue_len
echo "128" > /sys/class/net/rmnet_data1/tx_queue_len
echo "128" > /sys/class/net/rmnet_data2/tx_queue_len
echo "128" > /sys/class/net/rmnet_data3/tx_queue_len
echo "128" > /sys/class/net/rmnet_data4/tx_queue_len
echo "128" > /sys/class/net/rmnet_data5/tx_queue_len
echo "128" > /sys/class/net/rmnet_data6/tx_queue_len
echo "128" > /sys/class/net/rmnet_data7/tx_queue_len
echo "128" > /sys/class/net/rmnet_ipa0/tx_queue_len
echo "128" > /sys/class/net/sit0/tx_queue_len
echo "128" > /sys/class/net/wlan0/tx_queue_len

# Display Calibration that will be close to D65 (6500K) (Boosted). Thanks to Juzman @ XDA for this contribution;
# echo "256 249 226" > /sys/devices/platform/kcal_ctrl.0/kcal
# echo "5" > /sys/devices/platform/kcal_ctrl.0/kcal_min
# echo "257" > /sys/devices/platform/kcal_ctrl.0/kcal_val

# Optimize and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions;

# Little Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
echo "775" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us

# BIG Cluster;
echo "18500" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
echo "775" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us

# Fully disable a very few CPU based & useless EDAC loggers;
echo "0" > /sys/devices/system/edac/cpu/log_ce
echo "0" > /sys/devices/system/edac/cpu/log_ue

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Turn off a few additional kernel debuggers and what not for gaining a slight boost in both performance and battery life;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "N" > /sys/module/cpufreq/parameters/enable_underclock
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "N" > /sys/module/hid_logitech_hidpp/parameters/disable_raw_mode
echo "N" > /sys/module/hid_logitech_hidpp/parameters/disable_tap_to_click
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
# echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
# echo "200" > /sys/module/mdss_fb/parameters/backlight_max
echo "N" > /sys/module/otg_wakelock/parameters/enabled
echo "0" > /sys/module/service_locator/parameters/enable
# echo "N" > /sys/module/sync/parameters/fsync_enabled

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

# Trim selected partitions at boot for a more than well-deserved and nice speed boost;
fstrim /data;
fstrim /cache;
fstrim /system;

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;

# Script log file location
LOG_FILE=/storage/emulated/0/logs

export TZ=$(getprop persist.sys.timezone);
echo $(date) > /storage/emulated/0/logs/blackenedmodlog
if [ $? -eq 0 ]
then
  echo "02BlackenedMod v9.1 (Test Build #3) successfully executed!" >> /storage/emulated/0/logs/blackenedmodlog
  exit 0
else
  echo "02BlackenedMod v9.1 (Test Build #3) failed." >> /storage/emulated/0/logs/blackenedmodlog
  exit 1
fi
  
# Wait..
# Done!
#

