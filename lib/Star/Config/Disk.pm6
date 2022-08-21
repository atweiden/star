use v6;
use Star::Config::Disk::Filesystem;
use Star::Config::Disk::Lvm;
use Star::Config::Utils;
use Star::Types;

my role RootLvm
{
    #| C<$.lvm> is the LVM configuration for the root partition.
    has Star::Config::Disk::Lvm:D $.lvm is required;
}

class Star::Config::Disk::Root
{
    #| C<$.device> is the target block device for the root partition.
    has Str:D $.device is required;

    #| C<$.filesystem> is the root partition filesystem configuration.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;

    multi method new(
        Filesystem:D $fs where lvm-compatible-filesystem($_),
        Star::Config::Disk::Lvm::Opts:D $l,
        Str:D :$device! where .so
        --> Star::Config::Disk::Root:D
    )
    {
        my Star::Config::Disk::Filesystem $filesystem .= new($fs);
        my Star::Config::Disk::Lvm $lvm .= new($l);
        self.^mixin(RootLvm).bless(:$device, :$filesystem, :$lvm);
    }

    multi method new(
        Filesystem:D $fs,
        Str:D :$device! where .so
        --> Star::Config::Disk::Root:D
    )
    {
        my Star::Config::Disk::Filesystem $filesystem .= new($fs);
        self.bless(:$device, :$filesystem);
    }
}

my role BootDevice
{
    #| C<$.device> is the target block device for the boot partition.
    #|
    #| N.B. This device must differ from the target block device for the
    #| root partition.
    has Str:D $.device is required;
}

class Star::Config::Disk::Boot
{
    #| C<$.filesystem> is the boot partition filesystem configuration.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;

    # Useful whenever a separate boot partition is needed (see:
    # C<Star::Config::Disk>). In which case, C<$device> is required. The
    # caller must ensure its value differs from that of the root device.
    multi method new(
        Filesystem:D $fs,
        Str:D :$device! where .so
        --> Star::Config::Disk::Boot:D
    )
    {
        my Star::Config::Disk::Filesystem $filesystem .= new($fs);
        self.^mixin(BootDevice).bless(:$device, :$filesystem);
    }

    # Useful if the root and boot filesystem formats differ, and LVM is
    # enabled. In which case, the boot filesystem is created on an LVM
    # logical volume, rather than on a separate partition.
    multi method new(
        Filesystem:D $fs
        --> Star::Config::Disk::Boot:D
    )
    {
        my Star::Config::Disk::Filesystem $filesystem .= new($fs);
        self.bless(:$filesystem);
    }
}

my role DiskRoot
{
    has Star::Config::Disk::Root:D $.root is required;
}

my role DiskBoot
{
    has Star::Config::Disk::Boot:D $.boot is required;
}

#| C<Star::Config::Disk> stores settings for the root and boot partitions.
#|
#| A boot partition is only created if one of the following conditions is
#| true:
#|
#| =begin item
#|
#| The root and boot filesystem formats differ, and LVM is disabled. If
#| the root and boot filesystem formats differ, and LVM is I<enabled>, the
#| C</boot> filesystem is created on an LVM logical volume within the root
#| partition - that is, unless another condition necessitating a separate
#| boot partition is met.
#|
#| =end item
#|
#| =begin item
#|
#| The filesystem's native encryption implementation is used. At present,
#| no bootloader is able to boot from a C</boot> directory encrypted with
#| the filesystem's native encryption implementation.
#|
#|     DiskEncryption::FILESYSTEM || DiskEncryption::DMFS
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used to encrypt the root partition only. This
#| entails having a separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT && DmCryptTarget::ROOT
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used to encrypt the boot partition only. This
#| entails having a separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT && DmCryptTarget::BOOT
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used for encrypting the root and boot partitions
#| together with C<BootSecurityLevel::<1FA>>. This entails storing the
#| dm-crypt encrypted root volume's detached header in a separate boot
#| partition.
#|
#|     DiskEncryption::DM-CRYPT
#|         && DmCryptTarget::BOTH
#|         && BootSecurityLevel::<1FA>
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used for encrypting the root and boot partitions
#| together with C<BootSecurityLevel::<2FA>> and C<SecondFactor::MORT>.
#| This entails storing the dm-crypt encrypted root volume's detached
#| header in a separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT
#|         && DmCryptTarget::BOTH
#|         && BootSecurityLevel::<2FA>
#|         && SecondFactor::MORT
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used for encrypting the root and boot partitions
#| together with C<BootSecurityLevel::<2FA>> and C<SecondFactor::FIDO2>,
#| C<SecondFactor::KEY> or C<SecondFactor::PKCS>. Since no bootloader at
#| present is able to decrypt a dm-crypt encrypted boot partition using
#| either FIDO2, an external key file, or PKCS#11-compatible security
#| token or smart card during system startup, this entails having a
#| separate boot partition. N<Arguably, a separate boot partition would be
#| required regardless in order to achieve "2FA". Without the separate
#| boot partition, the disk could be decrypted using solely the FIDO2
#| device, external key file, or PKCS#11-compatible security token or
#| smart card, respectively.>
#|
#|     DiskEncryption::DM-CRYPT
#|         && DmCryptTarget::BOTH
#|         && BootSecurityLevel::<2FA>
#|         && (SecondFactor::FIDO2 || SecondFactor::KEY || SecondFactor::PKCS)
#|
#| =end item
#|
#| Boot partition settings will only be available if one of the above
#| conditions is met.
class Star::Config::Disk
{
    # The root partition always exists.
    also does DiskRoot;

    multi method new(
        DiskEncryption::NONE,
        Star::Config::Disk::Root::Opts:D $r,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        self.bless(:$root);
    }

    multi method new(
        DiskEncryption:D $ where filesystem-encryption($_),
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskBoot).bless(:$root, :$boot);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget:D $ where dm-crypt-target-root-or-boot($_),
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskBoot).bless(:$root, :$boot);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        BootSecurityLevel:D $ where elevated-bootsec($_),
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskBoot).bless(:$root, :$boot);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        Star::Config::Disk::Root::Opts:D $r,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        self.bless(:$root);
    }
}

=head2 Helper functions

multi sub dm-crypt-target-root-or-boot(DmCryptTarget::ROOT --> True) {*}
multi sub dm-crypt-target-root-or-boot(DmCryptTarget::BOOT --> True) {*}
multi sub dm-crypt-target-root-or-boot(DmCryptTarget::BOTH --> False) {*}

multi sub filesystem-encryption(DiskEncryption::NONE --> False) {*}
multi sub filesystem-encryption(DiskEncryption::DM-CRYPT --> False) {*}
multi sub filesystem-encryption(DiskEncryption::FILESYSTEM --> True) {*}
multi sub filesystem-encryption(DiskEncryption::DMFS --> True) {*}

multi sub lvm-compatible-filesystem(Filesystem::BTRFS --> False) {*}
multi sub lvm-compatible-filesystem(Filesystem::EXT2 --> True) {*}
multi sub lvm-compatible-filesystem(Filesystem::EXT3 --> True) {*}
multi sub lvm-compatible-filesystem(Filesystem::EXT4 --> True) {*}
multi sub lvm-compatible-filesystem(Filesystem::F2FS --> True) {*}
multi sub lvm-compatible-filesystem(Filesystem::NILFS2 --> True) {*}
multi sub lvm-compatible-filesystem(Filesystem::XFS --> True) {*}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
