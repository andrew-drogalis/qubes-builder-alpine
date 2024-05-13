#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :
### 02_install_groups.sh : Install specified additional packages into chroot
echo "--> Alpine Linux 02_install_groups.sh"

DIST_NAME="alpinelinux"
DIST_VER="v${DIST#alpine}"
DIST_VER="${DIST_VER/3/3.}"
 
if [ -z "${DIST_NAME}" ]; then
    error "Please provide DIST_NAME in environment."
fi

if [ -z "${DIST_VER}" ]; then
    error "Please provide DIST_VER in environment."
fi

set -e
if [ "${VERBOSE:-0}" -ge 2 ] || [ "${DEBUG:-0}" -eq 1 ]; then
    set -x
fi

if [ -n "$TEMPLATE_FLAVOR" ]; then
    PKGLISTFILE="${TEMPLATE_CONTENT_DIR}/packages_${TEMPLATE_FLAVOR}.list"
    if ! [ -r "$PKGLISTFILE" ]; then
        echo "ERROR: PKGLISTFILE '${PKGLISTFILE}' does not exist!"
        exit 1
    fi
else
    PKGLISTFILE="${TEMPLATE_CONTENT_DIR}/packages.list"
fi

# Strip comments, then convert newlines to single spaces
PKGGROUPS="$(sed '/^ *#/d; s/  *#.*//' "${PKGLISTFILE}" | sed ':a;N;$!ba; s/\n/ /g; s/  */ /g')"

APKTOOLS_CACHE_DIR="${CACHE_DIR}/apk_cache"
ALPINELINUX_VERSION=${DIST_VER:-latest-stable}
ALPINELINUX_MIRROR=${ALPINELINUX_MIRROR:-https://dl-cdn.alpinelinux.org/alpine}
export APKTOOLS_CACHE_DIR

echo "  --> Enabling main and community repos..."
su -c "echo '$ALPINELINUX_MIRROR/$ALPINELINUX_VERSION/main' > $INSTALLDIR/etc/apk/repositories"
su -c "echo '$ALPINELINUX_MIRROR/$ALPINELINUX_VERSION/community' >> $INSTALLDIR/etc/apk/repositories"

echo "  --> Synchronize resolv.conf..."
cp /etc/resolv.conf "${INSTALL_DIR}/etc/resolv.conf"

echo "  --> Updating installed packages..."
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALL_DIR" /bin/sh -c \
    "apk update; apk upgrade"

echo "  --> Installing Alpine Linux package groups..."
echo "    --> Selected packages: ${PKGGROUPS}"
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALL_DIR" /bin/sh -c \
    "apk add ${PKGGROUPS}"
