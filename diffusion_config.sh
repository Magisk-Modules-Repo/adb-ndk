# Diffusion Installer Config
# osm0sis @ xda-developers

INST_NAME="ADB Installer Script";
AUTH_NAME="osm0sis @ xda-developers";

USE_ARCH=false
USE_ZIP_OPTS=true

custom_setup() {
  return # stub
}

custom_zip_opts() {
  return # stub
}

custom_target() {
  return # stub
}

custom_install() {
  ui_print " ";
  set_perm 0 0 755 $BIN/adb $BIN/adb.bin-arm64 $BIN/adb.bin-arm $BIN/adb.bin-armeabi $BIN/fastboot $BIN/fastboot.bin-arm64 $BIN/fastboot.bin-arm $BIN/fastboot.bin-armeabi;
  if $BIN/adb.bin-arm64 --version >/dev/null 2>&1; then
    ui_print "Installing adb (arm64) to $BIN ...";
    mv -f $BIN/adb.bin-arm64 $BIN/adb.bin;
  elif $BIN/adb.bin-arm --version >/dev/null 2>&1; then
    ui_print "Installing adb (arm) to $BIN ...";
    mv -f $BIN/adb.bin-arm $BIN/adb.bin;
  else
    ui_print "Installing adb (legacy) to $BIN ...";
    mv -f $BIN/adb.bin-armeabi $BIN/adb.bin;
  fi;
  rm -f $BIN/adb.bin-arm*;
  if $BIN/fastboot.bin-arm64 --version >/dev/null 2>&1; then
    ui_print "Installing fastboot (arm64) to $BIN ...";
    mv -f $BIN/fastboot.bin-arm64 $BIN/fastboot.bin;
  elif $BIN/fastboot.bin-arm --version >/dev/null 2>&1; then
    ui_print "Installing fastboot (arm) to $BIN ...";
    mv -f $BIN/fastboot.bin-arm $BIN/fastboot.bin;
  else
    ui_print "Installing fastboot (legacy) to $BIN ...";
    mv -f $BIN/fastboot.bin-armeabi $BIN/fastboot.bin;
  fi;
  rm -f $BIN/fastboot.bin-arm*;
}

custom_postinstall() {
  return # stub
}

custom_uninstall() {
  return # stub
}

custom_postuninstall() {
  return # stub
}

custom_cleanup() {
  return # stub
}

custom_exitmsg() {
  return # stub
}

# additional custom functions


