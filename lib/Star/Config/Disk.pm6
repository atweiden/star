use v6;
use Star::Config::Disk::Filesystem;
use Star::Config::Disk::Lvm;
use Star::Types;

my role RootLvm
{
    #| C<$.lvm> is the LVM configuration for the root partition.
    has Star::Config::Disk::Lvm:D $.lvm is required;
}

class Star::Config::Disk::Root
{
    #| C<$.device> is the target block device for the root partition.
    has Str:D $.device is required;

    #| C<$.filesystem> is the root partition filesystem configuration.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;

    # TODO: implement C<multi method new> here.
}

my role BootDevice
{
    #| C<$.device> is the target block device for the boot partition.
    #|
    #| N.B. This device must differ from the target block device for the
    #| root partition.
    has Str:D $.device is required;
}

my role BootFilesystem
{
    #| C<$.filesystem> is the boot partition filesystem configuration.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;
}

class Star::Config::Disk::Boot
{
    # TODO: implement C<multi method new> here.
}

my role DiskRoot
{
    has Star::Config::Disk::Root:D $.root is required;
}

my role DiskBoot
{
    has Star::Config::Disk::Boot:D $.boot is required;
}

class Star::Config::Disk
{
    # The root partition always exists.
    also does DiskRoot;

    # TODO: implement C<multi method new> here.
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
