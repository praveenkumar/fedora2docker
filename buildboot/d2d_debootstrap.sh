#!/bin/bash
set -e

#debootstrap
echo "---> debootstrapping"
dnf install -y $PACKAGES
supermin -v --prepare $PACKAGES -o /tmp/supermin.d
supermin --build -f chroot /tmp/supermin.d -o $BUILDDIR
