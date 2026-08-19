#!/bin/sh
set -e

# Xcode 16+ requires dSYMs for every embedded framework in App Store uploads.
# Flutter.framework and sqlite3.framework are prebuilt without bundled dSYMs.
FRAMEWORKS_DIR="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
DSYM_OUTPUT_DIR="${DWARF_DSYM_FOLDER_PATH}"

if [ ! -d "${FRAMEWORKS_DIR}" ]; then
  exit 0
fi

generate_dsym() {
  framework_name="$1"
  binary="${FRAMEWORKS_DIR}/${framework_name}.framework/${framework_name}"
  dsym="${DSYM_OUTPUT_DIR}/${framework_name}.framework.dSYM"

  if [ -f "${binary}" ] && [ ! -d "${dsym}" ]; then
    echo "Generating dSYM for ${framework_name}.framework"
    dsymutil "${binary}" -o "${dsym}"
  fi
}

generate_dsym "Flutter"
generate_dsym "sqlite3"
