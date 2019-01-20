#!/system/bin/sh

# (c) KingKernel kernel changes, some taken from xfirefly's flash kernel modification script since
# my kernel relies a lot on it (couldn't have done this without you dude)

#make logs folder
mkdir /storage/emulated/0/logs
LOG_FILE=/storage/emulated/0/logs/blackenedmodlog

echo " " > $LOG_FILE;
echo "BM started" | tee -a $LOG_FILE;

#Immediate executions for boot

#perfd can go screw itself, reduce to 10 on boot
echo "10" > /dev/stune/top-app/schedtune.boost

#Enable msm_thermal and core_control because of the improved thermals
echo "Y" > /sys/module/msm_thermal/parameters/enabled
echo "1" > /sys/module/msm_thermal/core_control/enabled

# A customized CPUSet profile for the first generation of Pixels (By xfirefly93) - with the goal of increasing both battery life, system responsivness and overall daily needed performance without any notable regressions, possible sacrifices and tradeoffs;
echo "3" > /dev/cpuset/background/cpus
echo "1,3" > /dev/cpuset/camera-daemon/cpus
echo "0-1" > /dev/cpuset/foreground/cpus
echo "2" > /dev/cpuset/kernel/cpus
echo "2-3" > /dev/cpuset/restricted/cpus
echo "2-3" > /dev/cpuset/system-background/cpus
echo "0-3" > /dev/cpuset/top-app/cpus

#Immediately Change default to schedutil if present #3
#cpu0
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#cpu1
echo "schedutil" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
#cpu2
echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
#cpu3
echo "schedutil" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

# Optimize and lower both the battery drain and overall power consumption that is caused by the Schedutil governor by biasing it to use slightly lower frequency steps, but do this without sacrificing performance or overall UI fluidity. See this as a balanced in-kernel power save mode, but without any notable traces of the "semi-typical" smoothness regressions;

#Add hispeed freq tweaks and enable pl from pixel 3 because I have ported the governor

echo "850" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable
echo "1275" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
#echo "1228800" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
#echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl

#cpu1
echo "850" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/iowait_boost_enable
echo "1275" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/up_rate_limit_us
#echo "1228800" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/hispeed_freq
#echo "1" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/pl

#cpu2
echo "850" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/iowait_boost_enable
echo "1275" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us
#echo "825600" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/hispeed_freq
#echo "1" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/pl

#cpu3
echo "850" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/down_rate_limit_us
echo "1" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/iowait_boost_enable
echo "1275" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/up_rate_limit_us
#echo "825600" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/hispeed_freq
#echo "1" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/pl

sleep 30;

# Disable sysctl.conf to prevent ROM interference #1
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system;
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak;
  mount -o remount,ro /system;
fi;

# Mounting tweak for better overall partition performance (Need busybox magisk module);
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys;
busybox mount -o remount,nosuid,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /data;
busybox mount -o remount,nodev,noatime,nodiratime,barrier=0,noauto_da_alloc,discard -t auto /system;

#Default I/o sched cfq
echo "cfq" > /sys/block/sda/queue/scheduler
echo "cfq" > /sys/block/sdb/queue/scheduler
echo "cfq" > /sys/block/sdc/queue/scheduler
echo "cfq" > /sys/block/sdd/queue/scheduler
echo "cfq" > /sys/block/sde/queue/scheduler
echo "cfq" > /sys/block/sdf/queue/scheduler

# Tweak the various Flag Tuners for achieving slightly improved multitasking as well as overall better system performance and reduced power consumption;

setprop MIN_HIDDEN_APPS false
setprop ACTIVITY_INACTIVE_RESET_TIME false
setprop MIN_RECENT_TASKS false
setprop PROC_START_TIMEOUT false
setprop CPU_MIN_CHECK_DURATION false
setprop GC_TIMEOUT false
setprop SERVICE_TIMEOUT false
setprop MIN_CRASH_INTERVAL false
setprop ENFORCE_PROCESS_LIMIT false

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
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "48" > /proc/sys/net/ipv6/ip6frag_time

# Virtual Memory tweaks & enhancements for a massively improved balance between performance and battery life;
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

# Enable CFQ group idle mode for improved scheduling effectivness by merging the IO queues in a "unified group" instead of treating them as individual IO based queues;
for i in /sys/block/*/queue/iosched; do
  echo "1" > $i/group_idle;
done;

# Disable CFQ low latency mode for overall increased IO based scheduling throughput and for better overall needed responsivness & performance from the system;
for i in /sys/block/*/queue/iosched; do
  echo "0" > $i/low_latency;
done;

# Disable gesture based vibration because it is honestly not even worth having enabled at all;
echo "0" > /sys/android_touch/vib_strength

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!); #5
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/io_poll;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "32" > $i/nr_requests;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
  echo "write through" > $i/write_cache;
done;
# Optimize the Adreno 530 GPU into delivering better overall graphical rendering performance, but do it with "respect" to battery life as well as power consumption as far as possible with less amount of possible tradeoffs;
# echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
# echo "72" > /sys/class/kgsl/kgsl-3d0/deep_nap_timer
# echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
# echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
# echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on

# Decrease both battery as well as power consumption that is being caused by the screen by lowering how much light the pixels, the built-in LED switches and the LCD backlight module is releasing & "kicking out" by carefully tuning / adjusting their maximum values a little bit to the balanced overall range of their respective spectrums;
echo "170" > /sys/class/leds/blue/max_brightness
echo "170" > /sys/class/leds/green/max_brightness
echo "170" > /sys/class/leds/lcd-backlight/max_brightness
echo "170" > /sys/class/leds/led:switch/max_brightness
echo "170" > /sys/class/leds/red/max_brightness

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "enable_wlan_ws;enable_wlan_wow_wl_ws;enable_wlan_extscan_wl_ws;enable_timerfd_ws;enable_qcom_rx_wakelock_ws;enable_netmgr_wl_ws;enable_netlink_ws;enable_ipa_ws;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker


# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port, which can be good for the people that is often on the run or have limited access to a wall socket;
echo "1" > /sys/kernel/fast_charge/force_fast_charge

# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "Y" > /sys/module/mdss_fb/parameters/backlight_dimmer
echo "N" > /sys/module/otg_wakelock/parameters/enabled
# echo "N" > /sys/module/sync/parameters/fsync_enabled

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

#Enable audio high performance mode by default
echo "1" > /sys/module/snd_soc_wcd9330/parameters/high_perf_mode

#perfd can go screw itself, reduce to 10 again because it may go up to 50 because perfd
echo "10" > /dev/stune/top-app/schedtune.boost

#Fstrim for a final boost
fstrim /data;
fstrim /cache;
fstrim /system;

sleep 25;
# Script log file location


export TZ=$(getprop persist.sys.timezone);
echo $(date) | tee -a $LOG_FILE
if [ $? -eq 0 ]
then
  echo "---------------------------------------------" | tee -a $LOG_FILE;
  echo "03KingKernel v1.0 successfully executed!" | tee -a $LOG_FILE;
  exit 0
else
  echo "---------------------------------------------" | tee -a $LOG_FILE;
  echo "03KingKernel v1.0 failed, please check your installation." | tee -a $LOG_FILE;
  exit 1
fi
  
# Wait..
# Done!
#
