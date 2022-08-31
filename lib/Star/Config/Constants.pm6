use v6;

#| C<Star::Config::Constants> encapsulates constants referenced strictly
#| from within the C<Star::Config> namespace.
unit module Star::Config::Constants;

#| C<$VOLUME-GROUP-NAME> is the default name for the LVM volume group.
constant $VOLUME-GROUP-NAME = 'vg0';

#| C<$VOLUME-GROUP-NAME-RETRY-ATTEMPTS> is the number of times Star will
#| attempt to modify either C<$VOLUME-GROUP-NAME> or a user-provided
#| corollary before finding a suitable replacement.
constant $VOLUME-GROUP-NAME-RETRY-ATTEMPTS = 100;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
