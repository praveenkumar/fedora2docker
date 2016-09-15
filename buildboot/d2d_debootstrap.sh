#!/bin/bash
set -e

#debootstrap
echo "---> debootstrapping"
supermin --prepare "$PACKAGES" -o /tmp/supermin.d
supermin --build -f chroot /tmp/supermin.d -o $BUILDDIR
