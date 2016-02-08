#!/system/xbin/busybox sh

# Optimize Databases script
# Original by dorimanx for ExTweaks
# Modified by UpInTheAir for SkyHigh kernels & Synapse

BB=/system/xbin/busybox;
P=/data/media/0/hackerkernel/values/cron_sqlite;
SQLITE=`cat $P`;

if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;

if [ "$SQLITE" == 1 ]; then

	# wait till CPU is idle.
	while [ ! "$($BB cat /proc/loadavg | cut -c1-4)" -lt "3.50" ]; do
		echo "Waiting For CPU to cool down";
		sleep 30;
	done;

	for i in $(find /data -iname "*.db"); do
		sbin/sqlite3 "$i" 'VACUUM;' 2> /dev/null;
		sbin/sqlite3 "$i" 'REINDEX;' 2> /dev/null;
	done;

	for i in $(find /sdcard -iname "*.db"); do
		sbin/sqlite3 "$i" 'VACUUM;' 2> /dev/null;
		sbin/sqlite3 "$i" 'REINDEX;' 2> /dev/null;
	done;
	sync;

	date +%R-%F > /data/crontab/cron-db-optimizing;
	echo " DB Optimized" >> /data/crontab/cron-db-optimizing;

elif [ "$SQLITE" == 0 ]; then

	date +%R-%F > /data/crontab/cron-db-optimizing;
	echo " DB Optimization is disabled" >> /data/crontab/cron-db-optimizing;
fi;

$BB mount -t rootfs -o remount,ro rootfs;
