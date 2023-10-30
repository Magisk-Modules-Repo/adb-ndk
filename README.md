## ADB & Fastboot for Android NDK
### osm0sis & Surge1223 @ xda-developers
*Static arm/arm64 adb and fastboot binaries for Android built with the NDK*

### Links
* [GitHub](https://github.com/Magisk-Modules-Repo/adb-ndk)
* [Support](https://is.gd/osm0_)
* [Sponsor](https://github.com/sponsors/osm0sis)
* [Donate](https://www.paypal.me/osm0sis)

### Description
Marshmallow removed adb from the /system/bin/ directory. For those wanting this functionality back, here's an installer to push static compiles of adb and fastboot to /system/xbin/, with a wrapper to point adb to the correct HOME directory and set TMPDIR for compatibility. Detects and supports SuperSU/Magisk systemless installs. Can then be used from Terminal while booted.
