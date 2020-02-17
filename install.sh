# ADB Installer Script
# osm0sis @ xda-developers

# make sure variables are correct regardless of Magisk or recovery sourcing the script
[ -z $OUTFD ] && OUTFD=/proc/self/fd/$2 || OUTFD=/proc/self/fd/$OUTFD;
[ ! -z $ZIP ] && { ZIPFILE="$ZIP"; unset ZIP; }
[ -z $ZIPFILE ] && ZIPFILE="$3";

# Magisk Manager/booted flashing support
test -e /data/adb/magisk && adb=adb;
ps | grep zygote | grep -v grep >/dev/null && BOOTMODE=true || BOOTMODE=false;
$BOOTMODE || ps -A 2>/dev/null | grep zygote | grep -v grep >/dev/null && BOOTMODE=true;
if $BOOTMODE; then
  OUTFD=/proc/self/fd/0;
  dev=/dev;
  devtmp=/dev/tmp;
  if [ -e /data/$adb/magisk ]; then
    if [ ! -f /data/$adb/magisk_merge.img -a ! -e /data/adb/modules ]; then
      (/system/bin/make_ext4fs -b 4096 -l 64M /data/$adb/magisk_merge.img || /system/bin/mke2fs -b 4096 -t ext4 /data/$adb/magisk_merge.img 64M) >/dev/null;
    fi;
    test -e /magisk/.core/busybox && magiskbb=/magisk/.core/busybox;
    test -e /sbin/.core/busybox && magiskbb=/sbin/.core/busybox;
    test -e /sbin/.magisk/busybox && magiskbb=/sbin/.magisk/busybox;
    test "$magiskbb" && export PATH="$magiskbb:$PATH";
  fi;
fi;

ui_print() { $BOOTMODE && echo "$1" || echo -e "ui_print $1\nui_print" >> $OUTFD; }
show_progress() { echo "progress $1 $2" > $OUTFD; }

ui_print " ";
ui_print "ADB Installer Script";
ui_print "by osm0sis @ xda-developers";
modname=adb-ndk;
show_progress 1.34 2;

ui_print " ";
ui_print "Mounting...";
mount -o ro /system;
mount /data;
mount /cache;
test -f /system/system/build.prop && root=/system;

# Magisk clean flash support
if [ -e /data/$adb/magisk -a ! -e /data/$adb/magisk.img -a ! -e /data/adb/modules ]; then
  make_ext4fs -b 4096 -l 64M /data/$adb/magisk.img || mke2fs -b 4096 -t ext4 /data/$adb/magisk.img 64M;
fi;

suimg=`(ls /data/$adb/magisk_merge.img || ls /data/su.img || ls /cache/su.img || ls /data/$adb/magisk.img || ls /cache/magisk.img) 2>/dev/null`;
mnt=$devtmp/$(basename $suimg .img);
if [ "$suimg" ]; then
  umount $mnt;
  test ! -e $mnt && mkdir -p $mnt;
  mount -t ext4 -o rw,noatime $suimg $mnt;
  for i in 0 1 2 3 4 5 6 7; do
    test "$(mount | grep " $mnt ")" && break;
    loop=/dev/block/loop$i;
    if [ ! -f "$loop" -o ! -b "$loop" ]; then
      test -e /dev/block/loop1 && minorx=$(ls -l /dev/block/loop1 | cut -d, -f2 | cut -c4) || minorx=1;
      mknod $loop b 7 $((i * minorx));
    fi;
    losetup $loop $suimg && mount -t ext4 -o loop,noatime $loop $mnt;
  done;
  case $mnt in
    */magisk*) magisk=/$modname/system;;
  esac;
  bin=$mnt$magisk/bin;
else
  # SuperSU BINDSBIN support
  mnt=$(dirname `find /data -name supersu_is_here | head -n1` 2>/dev/null);
  if [ -e "$mnt" ]; then
    bin=$mnt/bin;
  elif [ -e "/data/adb/modules" ]; then
    mnt=/data/adb/modules_update;
    magisk=/$modname/system;
    bin=$mnt$magisk/bin;
  else
    mount -o rw,remount /system || mount /system || mount -o rw,remount / && sar=1;
    bin=$root/system/xbin;
  fi;
fi;

ui_print " ";
ui_print "Extracting files...";
mkdir -p $dev/tmp/$modname;
cd $dev/tmp/$modname;
unzip -o "$ZIPFILE";

ui_print " ";
ui_print "Installing adb to $bin ...";
chmod 755 bin/fastboot;
bin/fastboot --version >/dev/null 2>&1 || mv -f bin/fastboot-armeabi bin/fastboot && rm -f bin/fastboot-armeabi;
mkdir -p $bin;
cp -rf bin/* $bin;
chown 0:0 "$bin/adb" "$bin/adb.bin" "$bin/fastboot";
chmod 755 "$bin/adb" "$bin/adb.bin" "$bin/fastboot";
if [ "$magisk" ]; then
  cp -f module.prop $mnt/$modname/;
  touch $mnt/$modname/auto_mount;
  chcon -hR 'u:object_r:system_file:s0' "$mnt/$modname";
  if $BOOTMODE; then
    test -e /magisk && imgmnt=/magisk || imgmnt=/sbin/.core/img;
    test -e /sbin/.magisk/img && imgmnt=/sbin/.magisk/img;
    test -e /data/adb/modules && imgmnt=/data/adb/modules;
    mkdir -p "$imgmnt/$modname";
    touch "$imgmnt/$modname/update";
    cp -f module.prop "$imgmnt/$modname/";
  fi;
fi;

ui_print " ";
ui_print "Unmounting...";
test "$suimg" && umount $mnt;
test "$loop" && losetup -d $loop;
test "$sar" && mount -o ro,remount /;
umount /system;
umount /data;
umount /cache;

cd /;
rm -rf /tmp/$modname /dev/tmp;
ui_print " ";
ui_print "Done!";
exit 0;

