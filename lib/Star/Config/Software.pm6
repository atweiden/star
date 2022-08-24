use v6;
use Star::Types;

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

    #| C<@.package> contains packages for the installer to install in
    #| addition to the minimal default set.
    #|
    #| N.B. All packages in C<@.package> must be available for download
    #| from a reachable Void package repository.
    has Str:D @.package is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
