#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :
### 04_install_qubes.sh : Prepare chroot instance as a Qubes template
echo "--> Alpine linux 04_install_qubes.sh"

DIST_NAME="alpinelinux"
DIST_VER="v${DIST#alpine}"
DIST_VER="${DIST_VER/3/3.}"
 
if [ -z "${DIST_NAME}" ]; then
    error "Please provide DIST_NAME in environment."
fi

if [ -z "${DIST_VER}" ]; then
    error "Please provide DIST_VER in environment."
fi

APKTOOLS_CACHE_DIR="${CACHEDIR}/apk_cache"
ALPINELINUX_VERSION=${DIST_VER:-latest-stable}
QUBESALPINE_MIRROR="${QUBESALPINE_MIRROR:-https://lab.ilot.io/ayakael/repo-apk/-/raw}"
QUBESALPINE_KEYFILE="${QUBESALPINE_KEYFILE:-antoine.martin@protonmail.com-5b3109ad.rsa.pub}"
QUBES_REL="${QUBES_REL:-r4.2}"
export APK_CACHE_DIR

set -e
if [ "$VERBOSE" -ge 2 ] || [ "$DEBUG" -gt 0 ]; then
    set -x
fi

echo "  --> Adding Qubes custom repository..."
su -c "echo '$QUBESALPINE_MIRROR/$ALPINELINUX_VERSION/qubes/$QUBES_REL' >> $INSTALLDIR/etc/apk/repositories"
wget "$QUBESALPINE_MIRROR/$ALPINELINUX_VERSION/$QUBESALPINE_KEYFILE" -P "$INSTALLDIR"/etc/apk/keys

echo "  --> Synchronize resolv.conf..."
cp /etc/resolv.conf "${INSTALLDIR}/etc/resolv.conf"

echo "  --> Updating apk repos..."
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" /bin/sh -c \
    "apk update; apk upgrade"

echo "  --> Installing mandatory qubes packages..."
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" /bin/sh -c \
    "apk add qubes-vm-dependencies"

echo "  --> Installing recommended qubes apps"
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" /bin/sh -c \
    "apk add qubes-vm-recommended qubes-vm-passwordless-root"

echo "  --> Updating template fstab file..."
cat > "${INSTALLDIR}/etc/fstab" <<EOF
#
# /etc/fstab: static file system information
#

# Templates Directories
/dev/mapper/dmroot /                       ext4 defaults,discard,noatime        1 1
/dev/xvdb		/rw			auto	noauto,defaults,discard	1 2
/dev/xvdc1      swap                    swap    defaults        0 0

# Template Binds
/rw/home        /home       none    noauto,bind,defaults 0 0
/rw/usrlocal    /usr/local  none    noauto,bind,defaults 0 0

# Template Customizations
tmpfs                   /dev/shm                                    tmpfs   defaults,size=1G            0 0

EOF

echo "  --> Configuring system to our preferences..."
# add hcv0 to inittab
echo "hvc0::respawn:/sbin/getty -L hvc0 115200 vt220" >> "$INSTALLDIR"/etc/inittab

# user and groups
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" addgroup qubes
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" addgroup user
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" adduser -D user -G user -s /bin/bash
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" addgroup user qubes

# create /lib/modules for qubes-kernel module mount
"${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" mkdir /lib/modules

# lo device
cat > "${INSTALLDIR}/etc/network/interfaces" <<EOF
auto lo
iface lo inet loopback
EOF


# enable services
for i in udev udev-trigger xendriverdomain qubes-qrexec-agent qubes-db qubes-meminfo-writer qubes-sysinit qubes-core-early qubes-core qubes-gui-agent qubes-updates-proxy-forwarder crond acpid; do
    "${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" rc-update add $i default
done
for i in bootmisc hostname hwclock loadkmap modules networking seedrng swap sysctl syslog; do
    "${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" rc-update add $i boot
done
for i in devfs dmesg hwdrivers mdev; do
    "${TEMPLATE_CONTENT_DIR}/alpine-chroot" "$INSTALLDIR" rc-update add $i sysinit
done
