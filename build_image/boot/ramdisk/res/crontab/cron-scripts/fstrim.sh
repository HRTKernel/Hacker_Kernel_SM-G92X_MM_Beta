#!/system/xbin/busybox sh

# Original by dorimanx for ExTweaks
# Modified by UpInTheAir for SkyHigh kernels & Synapse

BB=/system/xbin/busybox;
P=/data/media/0/hackerkernel/values/cron_fstrim;
FSTRIM=`cat $P`;

if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;
if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /system;
fi;

if [ "$FSTRIM" == 1 ]; then

	# wait till CPU is idle.
	while [ ! "$($BB cat /proc/loadavg | cut -c1-4)" -lt "3.50" ]; do
		echo "Waiting For CPU to cool down";
		sleep 30;
	done;

	/sbin/fstrim -v /system
	/sbin/fstrim -v /data
	/sbin/fstrim -v /cache

	$BB sync

	date +%R-%F > /data/crontab/cron-fstrim;
	echo " File System trimmed" >> /data/crontab/cron-fstrim;

elif [ "$FSTRIM" == 0 ]; then

	date +%R-%F > /data/crontab/cron-fstrim;
	echo " File System Trim is disabled" >> /data/crontab/cron-fstrim;
fi;

$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
