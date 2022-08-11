use v6;
use Star::Types;

my role NilBoot
{
    has Star::Config::Disk::Filesystem::Format $!boot = Nil;
    method boot(::?CLASS:D: --> Star::Config::Disk::Filesystem::Format) { $!boot }
}

my role NilLvm
{
    has Star::Config::Disk::Filesystem::Lvm $!lvm = Nil;
    method lvm(::?CLASS:D: --> Star::Config::Disk::Filesystem::Lvm) { $!lvm }
}

# base mode with btrfs root, lvm irrelevant
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)! where Mode::BASE,
    Filesystem:D :$root! where Filesystem::BTRFS,
    Filesystem :boot($)!,
    Bool :lvm($)!
]
{
    # boot filesystem n/a in base mode
    also does NilBoot;
    # lvm n/a with btrfs
    also does NilLvm;

    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
}

# base mode with non-btrfs root, lvm enabled
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)! where Mode::BASE,
    Filesystem:D :$root!,
    Filesystem :boot($)!,
    Bool:D :$lvm! where .so
]
{
    # boot filesystem n/a in base mode
    also does NilBoot;

    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
    has Star::Config::Disk::Filesystem::Lvm:D $.lvm is required;
}

# base mode with non-btrfs root, lvm disabled
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)! where Mode::BASE,
    Filesystem:D :$root!,
    Filesystem :boot($)!,
    Bool :lvm($)!
]
{
    # boot filesystem n/a in base mode
    also does NilBoot;
    # lvm disabled
    also does NilLvm;

    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
}

# non-base mode with btrfs root, lvm irrelevant
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)!,
    Filesystem:D :$root! where Filesystem::BTRFS,
    Filesystem:D :$boot!,
    Bool :lvm($)!
]
{
    # lvm n/a with btrfs
    also does NilLvm;

    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
    has Star::Config::Disk::Filesystem::Format[$boot] $.boot is required;
}

# non-base mode with non-btrfs root, lvm enabled
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)!,
    Filesystem:D :$root!,
    Filesystem:D :$boot!,
    Bool:D :lvm($)! where .so
]
{
    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
    has Star::Config::Disk::Filesystem::Format[$boot] $.boot is required;
    has Star::Config::Disk::Filesystem::Lvm:D $.lvm is required;
}

# non-base mode with non-btrfs root, lvm disabled
role Star::Config::Disk::Filesystem[
    Mode:D :mode($)!,
    Filesystem:D :$root!,
    Filesystem:D :$boot!,
    Bool :lvm($)!
]
{
    # lvm disabled
    also does NilLvm;

    has Star::Config::Disk::Filesystem::Format[$root] $.root is required;
    has Star::Config::Disk::Filesystem::Format[$boot] $.boot is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
