#!/bin/bash
set -e

cp -Rfp /root/hooks $BUILDDIR

echo "---> clean up the root directory"
(
        cp $BUILDDIR/lib/modules/*/vmlinuz $BUILDDIR/boot/
	cd $BUILDDIR && mv boot/vmlinuz* ../vmlinuz
	chroot $BUILDDIR /hooks/clean_dnf
	rm -rf boot
) 
echo "---> copying includes.chroot"
cp -Rfp $INCLUDESCHROOTDIR/bin/* $BUILDDIR/bin/
cp -Rfp $INCLUDESCHROOTDIR/etc/network $BUILDDIR/etc/
cp -Rfp $INCLUDESCHROOTDIR/lib/* $BUILDDIR/lib/

echo "---> running hooks"
(
	cd $BUILDDIR/hooks
	for i in *.chroot; do
		echo ' ---> running hook: ' $i
		chroot $BUILDDIR /hooks/$i
	done
	rm -rf $BUILDDIR/hooks
)

echo "---> preparing the rootfs"
(	cd $BUILDDIR
	find . | cpio --quiet -H newc -o | xz -8 > ../initramfs-data.xz
	cd /root/
	mkdir RAMFS
	cd RAMFS
	mv ../initramfs-data.xz rootfs.xz
	find . | cpio --quiet -H newc -o | gzip -1 > ../ramdisk-data.gz
	cat /root/init.gz /root/ramdisk-data.gz > /root/ramdisk-final.gz
	rm -rf $BUILDDIR
)

echo "---> building the iso"
mkdir -p /tmp/iso/boot/isolinux
mkdir -p /tmp/iso/live/
cp /usr/share/syslinux/isolinux.bin /tmp/iso/boot/isolinux/
cp /usr/share/syslinux/ldlinux.c32 /tmp/iso/boot/isolinux/
cp /root/vmlinuz /tmp/iso/live/
cp /root/ramdisk-final.gz /tmp/iso/live/initrd.img
cp -Rfp $INCLUDESBINARYDIR/* /tmp/iso/
xorriso -as mkisofs \
	-l -J -R -V feodra2docker -no-emul-boot -boot-load-size 4 -boot-info-table \
	-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
	-isohybrid-mbr /usr/share/syslinux/isohdpfx.bin \
	-o /fedora2docker.iso /tmp/iso \
