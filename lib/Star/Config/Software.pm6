use v6;
use Star::Types;

#| C<Star::Config::Software> contains distro-specific settings for
#| software to be installed.

# nyi
role Star::Config::Software[Distro:D $ where Distro::ALPINE]
{*}

# nyi
role Star::Config::Software[Distro:D $ where Distro::ARCH]
{*}

# nyi
role Star::Config::Software[Distro:D $ where Distro::CHIMERA]
{*}

# nyi
role Star::Config::Software[Distro:D $ where Distro::GENTOO]
{*}

role Star::Config::Software[Distro:D $ where Distro::VOID]
{
    #| C<$.kernel> is the kernel package to use.
    has Str:D $.kernel is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
