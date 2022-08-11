use v6;
use Star::Config::Disk::Filesystem;
use Star::Types;

role Star::Config::Disk[
    Mode:D :$mode!,
    List:D :filesystem($)! (Filesystem $root, Filesystem $boot, Bool $lvm)
]
{
    #| C<$.target> is the target block device path for system
    #| installation.
    has Str:D $.device is required;

    has Star::Config::Disk::Filesystem[
        :$mode,
        :$root,
        :$boot,
        :$lvm
    ] $.filesystem is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
