use v6;
use Star::Config::Constants;
use X::Star::Config::Disk;
unit class Star::Config::Disk::Lvm;

my constant $VOLUME-GROUP-NAME =
    $Star::Config::Constants::VOLUME-GROUP-NAME;

my constant $VOLUME-GROUP-NAME-RETRY-ATTEMPTS =
    $Star::Config::Constants::VOLUME-GROUP-NAME-RETRY-ATTEMPTS;

#| C<$.volume-group-name> is the name for the LVM volume group.
has Str:D $.volume-group-name is required;

method new(
    Str:D :$volume-group-name = $VOLUME-GROUP-NAME
    --> Star::Config::Disk::Lvm:D
)
{
    self.bless(:volume-group-name(volume-group-name($volume-group-name)));
}

#| C<volume-group-name> scans C</dev> for device names conflicting with
#| C<$volume-group-name> and adjusts C<$volume-group-name> if necessary.
multi sub volume-group-name(
    Str:D $,
    0
    --> Str:D
)
{
    # Crash rather than wasting too many cycles on this.
    die(X::Star::Config::Disk::Lvm::VolumeGroupName.new);
}

multi sub volume-group-name(
    Str:D $volume-group-name where { .so && "/dev/$_".IO.e.not },
    UInt:D $?
    --> Str:D
)
{
    $volume-group-name;
}

multi sub volume-group-name(
    Str:D $volume-group-name is copy where .so,
    UInt:D $tries-remaining = $VOLUME-GROUP-NAME-RETRY-ATTEMPTS
    --> Str:D
)
{
    # Increment by one, e.g. vg0 -> vg1.
    my UInt:D $n = $volume-group-name.comb.tail + 1;
    my Int:D $i = $volume-group-name.chars - 1;
    $volume-group-name.substr-rw($i, 1) = ~$n;
    volume-group-name($volume-group-name, $tries-remaining - 1);
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
