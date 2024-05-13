#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :
### 09_cleanup.sh : Clean up the new chroot prior to image finalisation
echo "--> Alpine Linux 09_cleanup.sh"

set -e
[ "$VERBOSE" -ge 2 -o "$DEBUG" -gt 0 ] && set -x

echo " --> Cleaning /etc/resolv.conf"
rm -f "${INSTALLDIR}/etc/resolv.conf"
cat > "${INSTALLDIR}/etc/resolv.conf" << EOF
# This file intentionally left blank

EOF
