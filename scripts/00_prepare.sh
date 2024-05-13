#! /bin/bash --

set -euo pipefail
echo "--> Alpine Linux 00_prepare.sh"

DIST_NAME="alpinelinux"
DIST_VER="v${DIST#alpine}"
DIST_VER="${DIST_VER/3/3.}"
 
if [ -z "${DIST_NAME}" ]; then
    error "Please provide DIST_NAME in environment."
fi

if [ -z "${DIST_VER}" ]; then
    error "Please provide DIST_VER in environment."
fi


ALPINELINUX_PLUGIN_DIR="${ALPINELINUX_PLUGIN_DIR:-"${SCRIPTSDIR}/.."}"
ALPINELINUX_VERSION=${DIST_VER:-latest-stable}
ALPINELINUX_MIRROR=${ALPINELINUX_MIRROR:-https://dl-cdn.alpinelinux.org/alpine}
ALPINELINUX_ARCH=${ALPINELINUX_ARCH:-x86_64}

[ "$VERBOSE" -ge 2 -o "$DEBUG" -gt 0 ] && set -x

mkdir -p "${CACHEDIR}/apk_cache"

echo "  --> Downloading Alpine Linux bootstrap..."

wget -nd -N -P "$CACHEDIR" -r -l1 -np "$ALPINELINUX_MIRROR/$ALPINELINUX_VERSION/main/$ALPINELINUX_ARCH/" -A "apk-tools-static-*apk"

if [ "${CACHEDIR}/apk-tools-static"* -nt "${CACHEDIR}/bootstrap/.extracted" ]; then
    echo "  --> Extracting bootstrap tarball (nuking previous directory)..."
    rm -rf "${CACHEDIR}/bootstrap/"
    mkdir -p "${CACHEDIR}/bootstrap"
    # By default will extract to a "root.x86_64" directory; strip that off
    tar -xzC "${CACHEDIR}/bootstrap" -f "${CACHEDIR}/apk-tools-static"*.apk
    touch "${CACHEDIR}/bootstrap/.extracted"
else
    echo "  --> NB: Bootstrap tarball not newer than bootstrap directory, will use existing!"
fi
