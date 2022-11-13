use v6;
use Star::Types;

#| C<Star::Config::Installer> encapsulates cross-distro installer
#| settings, i.e. attributes which customize the behaviour of the
#| installer irrespective of the distro being installed.
unit class Star::Config::Installer;

#| C<$.chroot-dir> contains the absolute path within which to perform
#| installation.
has AbsolutePath:D $.chroot-dir is required;

#| C<$.augment> indicates whether to launch an interactive Bash shell
#| before unmounting the system prior to finishing installation.
#|
#| Setting C<$.augment> to C<True> can be useful for debugging.
#|
#| On Void, the included utility C<void-chroot> can be used to quickly
#| chroot into the new system.
#|
#| On Arch, C<arch-chroot> from the C<arch-install-scripts> package can
#| be used to quickly chroot into the new system.
has Bool:D $.augment is required;

#| C<@.package> contains packages for the installer to install in addition
#| to the minimal default set.
has Str:D @.package is required;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
