# fedora2docker

### What is fedora2docker

fedora2docker is a hybrid bootable ISO which starts an amd64 Linux system based on fedora. Its main purpose is to run Docker and to allow the execution of containers using Docker. 

The ISO is currently about 116 MB and is based on Fedora 24.

### How to build

Building debian2docker is quite simple:

```
docker rm run-fedora2docker
docker build -t fedora2docker .
docker run -i -t --privileged --name run-fedora2docker fedora2docker
docker cp run-fedora2docker:/fedora2docker.iso .
```
note: the ``docker cp`` will complain ``operation not permitted`` - presumably as it tries to change the file's ownership to ``root``

### How to run

1. Create a VM.
2. Add the ISO you've built as a virtual CD/DVD image.
3. Start the VM
4. Wait for the system to boot and start using debian2docker.

Linux & qemu/kvm example:
```
$ kvm -cdrom fedora2docker.iso -m 768
# wait for the system to boot and start using fedora2docker
```

The password for the user docker is `live`.

### Goals

fedora2docker has the following goals:

1. Remain minimal - no package installation
2. Offer only the minimal tooling required to run Docker and its containers.
3. Make use of Fedora binary packages - avoid lengthy compilation times.
4. If a package is broken or has problems, it should be fixed upstream and used.

debian2docker supports the following Docker graph drivers:
- aufs
- btrfs
- devicemapper
- vfs

BTRFS will be used if the storage partition is formatted as btrfs.

Devicemapper and vfs aren't used by default, but the kernel and Docker
support these two graph drivers as well.
