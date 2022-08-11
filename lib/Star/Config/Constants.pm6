use v6;

#| C<Star::Config::Constants> encapsulates constants referenced strictly
#| from within the C<Star::Config> namespace.
unit module Star::Config::Constants;

# C<$VOLUME-GROUP-NAME> is the default name for the LVM volume group.
constant $VOLUME-GROUP-NAME = 'vg0';

# vim: set filetype=raku foldmethod=marker foldlevel=0:
