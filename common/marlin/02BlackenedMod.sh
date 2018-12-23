#!/system/bin/sh

# (c) KingKernel kernel changes, some taken from xfirefly's flash kernel modification script since
# my kernel relies a lot on it (couldn't have done this without you dude)

#make logs folder
mkdir /storage/emulated/0/logs

sleep 44;

# Disable sysctl.conf to prevent ROM interference #1
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system;
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak;
  mount -o remount,ro /system;
fi;

# Add the full possibilty to either disable and / or enable a few Google Play Services background based services;
pm disable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService;
pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService;
pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService;
pm disable com.google.android.gms/com.google.android.gms.analytics.internal.PlayLogReportingService 
pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.RingService;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.NetworkQualityAndroidService;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.MdmPhoneWearableListenerService;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.LockscreenMessageService;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.DeviceManagerApiService;
pm disable com.google.android.gms/com.google.android.gms.mdm.services.GcmReceiverService;
pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver;
pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.RetryAfterAlarmReceiver;
pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceImposeReceiver;
pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceSecretCodeReceiver;
pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceTriggerReceiver;
pm disable com.google.android.gms/com.google.android.gms.checkin.EventLogService;
pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinService;
pm disable com.google.android.gms/com.google.android.gms.checkin.CheckinApiService;
pm disable com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService

# Mounting tweak for better overall partition performance (Need busybox magisk module);
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /system;

#xfirefly's cpuset profile to be applied when device is finished booting

# A customized CPUSet profile for the first generation of Pixels (By xfirefly93) - with the goal of increasing both battery life, system responsivness and overall daily needed performance without any notable regressions, possible sacrifices and tradeoffs;
echo "3" > /dev/cpuset/background/cpus
echo "1,3" > /dev/cpuset/camera-daemon/cpus
echo "0-1" > /dev/cpuset/foreground/cpus
echo "2" > /dev/cpuset/kernel/cpus
echo "2-3" > /dev/cpuset/restricted/cpus
echo "2-3" > /dev/cpuset/system-background/cpus
echo "0-3" > /dev/cpuset/top-app/cpus

if [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor/schedutil ]; then
    #change default gov to schedutil (if present)
    #cpu0
    echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    #cpu1
    echo "schedutil" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
    #cpu2
    echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    #cpu3
    echo "schedutil" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

    # Optimize and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions; (If schedutil is present, else, sched tweaks will be applied)

    # Cpu 0;
    echo "18500" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
    echo "775" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us

    # Cpu 1;
    echo "18500" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/down_rate_limit_us
    echo "775" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/up_rate_limit_us

    # Cpu 2;
    echo "18500" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
    echo "775" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us

    # Cpu 3;
    echo "18500" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/down_rate_limit_us
    echo "775" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/up_rate_limit_us

else
    # Optimize the battery consumption of the Sched governor by biasing it to use slightly lower frequency steps whenever possible. Just like a in-kernel powersaving mode, but without any trace of the typical "included" performance penalty; (if schedutil isn't present)

    # CPU0;
    echo "85000000" > /sys/devices/system/cpu/cpu0/cpufreq/sched/down_throttle_nsec
    echo "125000" > /sys/devices/system/cpu/cpu0/cpufreq/sched/up_throttle_nsec

    # CPU1;
    echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
    echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec

    # CPU2;
    echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
    echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec

    # CPU3;
    echo "85000000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/down_throttle_nsec
    echo "125000" > /sys/devices/system/cpu/cpu1/cpufreq/sched/up_throttle_nsec
fi;

# Enable schedtune foreground and gain a well deserved smoothness boost with one extra snap on top of it;
echo "5" > /dev/stune/foreground/schedtune.boost

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "2560" > /proc/sys/kernel/random/write_wakeup_threshold

# Kernel based tweaks that reduces the amount of wasted CPU cycles to maximum and gives back a huge amount of needed performance to both the system and the user;
echo "0" > /proc/sys/kernel/compat-log
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/perf_cpu_time_max_percent

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given for slightly improved system stability and minimized chance of system freezes & lockups;
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
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

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!); #5
for i in /sys/block/*/queue; do
  echo 0 > $i/add_random;
  echo 0 > $i/iostats;
  echo 0 > $i/nomerges;
  echo 128 > $i/read_ahead_kb;
  echo 0 > $i/rotational;
  echo 1 > $i/rq_affinity;
done;

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo 128 > $i/tx_queue_len;
done;

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Fully disable a very few CPU based & useless EDAC loggers;
echo "0" > /sys/devices/system/edac/cpu/log_ce
echo "0" > /sys/devices/system/edac/cpu/log_ue

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features


# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

# Turn off a few additional kernel debuggers and what not for gaining a slight boost in both performance and battery life;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
# echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
# echo "200" > /sys/module/mdss_fb/parameters/backlight_max
# echo "N" > /sys/module/sync/parameters/fsync_enabled

#Enable audio high performance mode by default
echo "1" > /sys/module/snd_soc_wcd9330/parameters/high_perf_mode

# Trim selected partitions at boot for a more than well-deserved and nice speed boost;
fstrim /data;
fstrim /cache;
fstrim /system;

sleep 10;
# Script log file location
LOG_FILE=/storage/emulated/0/logs

export TZ=$(getprop persist.sys.timezone);
echo $(date) > /storage/emulated/0/logs/blackenedmodlog
if [ $? -eq 0 ]
then
  echo "02BlackenedMod v9.1 (Test Build #5) successfully executed!" >> /storage/emulated/0/logs/blackenedmodlog
  exit 0
else
  echo "02BlackenedMod v9.1 (Test Build #5) failed." >> /storage/emulated/0/logs/blackenedmodlog
  exit 1
fi
  
# Wait..
# Done!
#
