use v6;
use Star::Types;

#| C<Star::Config::Distro> contains distro-specific settings.

my role Variant[Distro:D $distro]
{
    method variant(--> Distro:D) { $distro }
}

role Star::Config::Distro[Distro:D $ where Distro::ALPINE]
{
    also does Variant[Distro::ALPINE];
}

role Star::Config::Distro[Distro:D $ where Distro::ARCH]
{
    also does Variant[Distro::ARCH];
}

role Star::Config::Distro[Distro:D $ where Distro::CHIMERA]
{
    also does Variant[Distro::CHIMERA];
}

role Star::Config::Distro[Distro:D $ where Distro::GENTOO]
{
    also does Variant[Distro::GENTOO];
}

role Star::Config::Distro[Distro:D $ where Distro::VOID]
{
    also does Variant[Distro::VOID];

    #| C<@.repository> stores locations of Void package repositories
    #| (prioritized).
    #|
    #| Elements stored in C<@.repository> are assumed to be valid paths
    #| or URLs to Void package repositories.
    #|
    #| When this attribute contains valid Void package repository paths
    #| or URLs, they will be passed to C<xbps-install> I<ahead> of any
    #| other Void package repositories, including defaults defined by
    #| the installer in addition to Void package repositories configured
    #| in system settings, i.e.
    #|
    #|      xbps-install --repository=@.repository[0] --repository=@.repository[1]...
    #|
    #| N.B. Unless C<$.ignore-conf-repos> is set to C<True>, any or all
    #| executions of C<xbps-install> run by the installer may - should the
    #| Void package repositories stored in C<@.repository> be unreachable
    #| - communicate with default Void package repositories defined by
    #| the installer and/or Void package repositories configured in
    #| system settings. Set C<$.ignore-conf-repos> to C<True> if you
    #| wish to disable this behaviour.
    has Str:D @.repository is required;

    #| C<$.ignore-conf-repos> indicates whether the installer should
    #| only honour Void package repositories in C<@.repository>.
    #|
    #| When this attribute is set to C<True>, all executions of
    #| C<xbps-install> run by the installer will ignore Void package
    #| repositories defined by the installer and/or configured in system
    #| settings. It will strictly use the Void package repositories
    #| in C<@.repository>. If the Void package repositories in
    #| C<@.repository> are unreachable, the installer will fail.
    has Bool:D $.ignore-conf-repos is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
