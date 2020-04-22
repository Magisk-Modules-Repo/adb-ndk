# Diffusion Installer Config
# osm0sis @ xda-developers

INST_NAME="ADB Installer Script";
AUTH_NAME="osm0sis @ xda-developers";

USE_ARCH=false
USE_ZIP_OPTS=true

custom_zip_opts() {
  return # stub
}

custom_target() {
  return # stub
}

custom_install() {
  ui_print " ";
  ui_print "Installing adb to $BIN ...";
  set_perm 0 0 755 $BIN/adb $BIN/adb.bin $BIN/fastboot $BIN/fastboot-armeabi;
  if $BIN/fastboot --version >/dev/null 2>&1; then
    ui_print "Installing fastboot to $BIN ...";
    rm -f $BIN/fastboot-armeabi;
  else
    ui_print "Installing fastboot (legacy) to $BIN ...";
    mv -f $BIN/fastboot-armeabi $BIN/fastboot;
  fi;
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


