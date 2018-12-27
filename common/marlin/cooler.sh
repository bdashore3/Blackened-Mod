#!/system/bin/sh

#(c) kingbri: A service that constantly runs every five seconds to check battery temperature
# Applies cooling profile if the temperature is too high

# log file location
LOG_FILE=/storage/emulated/0/logs/chill_service

function change() {
	if "$(cat /sdcard/logs/flags)" == "stop"; then 
		:
	else
		#Execute chill script if batt. is >=35 degrees celsius
		if [ $batt_temp -ge "350" ]; then
			#check if governor is already schedutil
			cur_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
			# if current governor is chill, do nothing
			if [ cur_gov == "chill" ]; then
				:
			else
				# Otherwise, change it to chill
				#cpu0
				echo "chill" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
				#cpu1
				echo "chill" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
				#cpu2
				echo "chill" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
				#cpu3
				echo "chill" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
			fi;
		fi;
		if [ $batt_temp -lt "350" ]; then
			#check if governor is already schedutil
			cur_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
			# if current governor is schedutil, do nothing
			if  [ cur_gov == "schedutil" ]; then
				:
			# Otherwise, change it to schedutil
			else
				#change default gov to schedutil
				#cpu0
				echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
				#cpu1
				echo "schedutil" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
				#cpu2
				echo "schedutil" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
				#cpu3
				echo "schedutil" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
			fi;
		fi;
	fi;
}

#Starts after BM finishes tweaking things
echo "service started" | tee -a $LOG_FILE;
while :; do
	sleep 10;
	batt_temp=$(dumpsys battery | grep temperature | awk '{print $2}')
	change batt_temp
done
# Done!

