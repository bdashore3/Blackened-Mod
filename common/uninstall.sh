#!/system/bin/sh
ui_print "We're sorry to see you go..."
ui_print " "; ui_print "Removing scripts..."

rm -r /data/adb/service.d/03KingKernel.sh
rm -r /data/adb/service.d/02BlackenedMod.sh
rm -r /data/adb/service.d/Zipalign_sqlite.sh

# Add the full possibilty to either enable and / or enable a few Google Play Services background based services;
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.internal.PlayLogReportingService" 
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.RingService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.NetworkQualityAndroidService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.MdmPhoneWearableListenerService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.LockscreenMessageService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.DeviceManagerApiService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.services.GcmReceiverService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.receivers.RetryAfterAlarmReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceImposeReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceSecretCodeReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.CheckinServiceTriggerReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.EventLogService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.CheckinService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.checkin.CheckinApiService"
sleep 0.1
su -c "pm enable com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService"

