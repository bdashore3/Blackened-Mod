#!/system/bin/sh

#
# BlackenedMod v1.0 by the
# open source loving BlackenedMod team @ XDA; 
# Various strictly selected, carefully optimized & adjusted       # tweaks for better day to day performance & battery life,
# specially tuned for the Google Pixel 3 (XL) line-up;
#

#sleep for magiskboot service
sleep 45;
#make logs folder and set logs var #5
mkdir /storage/emulated/0/logs
LOG_FILE=/storage/emulated/0/logs/blackenedmodlog

#Clear log and tell that blackened mod has started #5
echo " " > $LOG_FILE;
echo "BM started" | tee -a $LOG_FILE;

# Disable sysctl.conf to prevent ROM interference
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system;
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak;
  mount -o remount,ro /system;
fi;

# Enable my own customized and optimized CPUSet configuration / set-up for achieving a better balance between battery life, power consumption as well as performance that is critically needed for daily usage;
echo "0-3" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/foreground/cpus
echo "4-5" > /dev/cpuset/kernel/cpus
echo "4-7" > /dev/cpuset/restricted/cpus

# Enable stune foreground boost for gaining a well-deserved & needed responsivness boost on top of it;
echo "5" > /dev/stune/foreground/schedtune.boost

# Disable the pre-enabled stune top-app boosting tunable for saving a very few critically & crucially needed percent of battery and thus conserving a certain amount of power;
echo "0" > /dev/stune/top-app/schedtune.sched_boost_enabled

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
echo "0" > /proc/sys/debug/exception-trace

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time

# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "2560" > /proc/sys/kernel/random/write_wakeup_threshold

# Kernel based tweaks that reduces the total amount of wasted CPU cycles and gives back a huge amount of needed performance as well as battery life savings to both the whole system and the user experience itself;
echo "0" > /proc/sys/kernel/hung_task_selective_monitoring
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "15000000" > /proc/sys/kernel/sched_latency_ns
echo "2000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given for slightly improved system stability and minimized chance of system freezes & lockups;
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

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
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "1800" > /proc/sys/net/ipv4/tcp_probe_interval
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "0" > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv6/calipso_cache_enable
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

# Disable the pre-enabled wake-vibrate functionality;
echo "0" > /sys/android_touch/wake_vibrate

# Enable CFQ group idle mode for improved scheduling effectivness by merging the IO queues in a "unified group" instead of treating them as individual IO based queues;
for i in /sys/block/*/queue/iosched; do
  echo "1" > $i/group_idle;
done;

# Disable CFQ low latency mode for overall increased IO based scheduling throughput and for better overall needed responsivness & performance from the system;
for i in /sys/block/*/queue/iosched; do
  echo "0" > $i/low_latency;
done;

# Wide block based tuning for reduced lag and less possible amount of general IO scheduling based overhead (Thanks to pkgnex @ XDA for the more than pretty much simplified version of this tweak. You really rock, dude!);
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/discard_max_bytes;
  echo "0" > $i/iopoll;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "128" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
done;

# Optimize the Adreno 630 GPU into delivering improved power efficiency, but do it without causing any real world, notable performance regressions of any possible kind;
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap

# Disable GPU frequency based throttling because it is actually not even needed anymore after all the GPU related enhancements and minor changes that I've done so far;
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Enable a tuned Boeffla wakelock blocker at boot for both better active & idle battery life;
echo "qcom_rx_wakelock;wlan;IPA_WS;netmgr_wl;wlan_pno_wl;wlan_wow_wl;wlan_ipa;wlan_extscan_wl;hal_bluetooth_lock;fts_tp;IPA_RM12;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Enable Schedutil hispeed_freq and tweak it for maximal userspace smoothness and device responsivness while keeping overall power consumption, as well as every (im)possible trace of system jank and stuttering, at bay;

# Little Cluster
echo "1228800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load

# Big Cluster
echo "825600" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_load

# Fully disable a very few CPU based & useless EDAC tunable loggers for overall slightly reduced CPU overhead;
echo "0" > /sys/devices/system/edac/cpu/log_ce
echo "0" > /sys/devices/system/edac/cpu/log_ue
echo "0" > /sys/devices/system/edac/cpu/panic_on_ue

# Tweak the kernel task scheduler for improved overall system performance and user interface responsivness during all kind of possible workload based scenarios;
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo "NO_LB_BIAS" >  /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features
echo "NO_RT_PUSH_IPI" >  /sys/kernel/debug/sched_features
echo "NO_RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features

# Turn off even more additional useless kernel debuggers, masks and modules that is not really needed & used at all;
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo "1" > /sys/module/hid/parameters/ignore_special_drivers
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "0" > /sys/module/hid_magicmouse/parameters/emulate_3button
echo "0" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "Y" > /sys/module/msm_drm/parameters/backlight_dimmer
echo "0" > /sys/module/mt20xx/parameters/tv_antenna
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
# echo "Y" > /sys/module/workqueue/parameters/power_efficient
# echo "N" > /sys/module/sync/parameters/fsync_enabled

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
echo "25000" > /sys/power/pm_freeze_timeout

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;

sleep 25;
# Script log file location

export TZ=$(getprop persist.sys.timezone);
echo $(date) | tee -a $LOG_FILE
if [ $? -eq 0 ]
then
  echo "---------------------------------------------" | tee -a $LOG_FILE;
  echo "02BlackenedMod v1.0 successfully executed!" | tee -a $LOG_FILE;
  exit 0
else
  echo "---------------------------------------------" | tee -a $LOG_FILE;
  echo "02BlackenedMod v1.0 failed, please check your installation." | tee -a $LOG_FILE;
  exit 1
fi
  
# Wait..
# Done!
#
