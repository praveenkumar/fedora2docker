#!/bin/bash
set -e

PACKAGELISTSDIR=/root/package-lists

for i in $PACKAGELISTSDIR/*
do
	PACKAGES+=" $(cat $i)"
done
echo $PACKAGES
export PACKAGES
export BUILDDIR=/root/jessieout
export INCLUDESCHROOTDIR=/root/includes.chroot
export INCLUDESBINARYDIR=/root/includes.binary

/root/buildboot/d2d_debootstrap.sh
/root/buildboot/d2d_build.sh
