#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :
### 01_install_core.sh : Create build chroot install of Alpine Linux using apk
echo "--> Alpine Linux 01_install_core.sh"

ALPINELINUX_PLUGIN_DIR="${ALPINELINUX_PLUGIN_DIR:-"${SCRIPTSDIR}/.."}"
ALPINELINUX_VERSION=${ALPINELINUX_VERSION:-latest-stable}
ALPINELINUX_SRC_PREFIX="${ALPINELINUX_SRC_PREFIX:-https://dl-cdn.alpinelinux.org/alpine/"$ALPINELINUX_VERSION"/main}"

set -e
[ "$VERBOSE" -ge 2 -o "$DEBUG" -gt 0 ] && set -x

"${ALPINELINUX_PLUGIN_DIR}/prepare-chroot-base" "$INSTALLDIR" "$DIST"
