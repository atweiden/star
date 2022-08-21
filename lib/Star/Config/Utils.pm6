use v6;
use Star::Types;

#| C<Star::Config::Utils> encapsulates helper functions used strictly from
#| within the C<Star::Config> namespace.
unit module Star::Config::Utils;

my constant \ONEFA = BootSecurityLevel::<1FA>;
my constant \TWOFA = BootSecurityLevel::<2FA>;

proto sub elevated-bootsec($ --> Bool:D) is export {*}
multi sub elevated-bootsec(BootSecurityLevel:D $ where ONEFA --> True) {*}
multi sub elevated-bootsec(BootSecurityLevel:D $ where TWOFA --> True) {*}
multi sub elevated-bootsec($ --> False) {*}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
