# ADB & Fastboot for Android NDK
### osm0sis & Surge1223 @ xda-developers
*Static ARM adb and fastboot binaries for Android built with the NDK*

### Links
* [GitHub](https://github.com/Magisk-Modules-Repo/adb-Installer)
* [Support](https://forum.xda-developers.com/showthread.php?t=2239421)
* [Sponsor](https://github.com/sponsors/osm0sis)
* [Donate](https://www.paypal.me/osm0sis)

### Description
Marshmallow removed adb from the /system/bin directory. For those wanting this functionality back, here's a simple installer to push static compiles of adb and fastboot to /system/xbin and uses a command wrapper to point adb to the correct HOME directory and set TMPDIR for compatibility. Detects and supports "systemless" install via SuperSU/Magisk as well. It can then be used from Terminal while booted from that point on.
