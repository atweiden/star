use v6;

# X::Star::Config::Disk::Lvm::VolumeGroupName {{{

#| C<X::Star::Config::Disk::Lvm::VolumeGroupName> is an exception for
#| the rare case where Star can't in 100 attempts find a valid name for
#| the LVM volume group (by default, Star tries C<vg0>..C<vg100> until
#| it finds a name not taken by another device).
class X::Star::Config::Disk::Lvm::VolumeGroupName
{
    also is Exception;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message =
            "Sorry, couldn't create valid LVM volume group name";
    }
}

# end X::Star::Config::Disk::Lvm::VolumeGroupName }}}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
