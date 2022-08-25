use v6;
use Star::Config::Disk::Filesystem;
use Star::Config::Disk::Lvm;
use Star::Config::Roles;
use Star::Config::Utils;
use Star::Types;

my role RootAttributes
{
    #| C<$.device> is the target block device to mount C</> on.
    has Str:D $.device is required;

    #| C<$.filesystem> contains filesystem settings for C</>.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;
}

my role RootLvm
{
    #| C<$.lvm> contains LVM settings for C</>.
    has Star::Config::Disk::Lvm:D $.lvm is required;
}

my role Root[LvmOnRoot:D $lvm-on]
{
    also does RootAttributes;

    method lvm-on(--> LvmOnRoot:D) { $lvm-on }
}

class Star::Config::Disk::Root
{...}

# Disable LVM.
role Star::Config::Disk::Root::Opts[LvmOnRoot:D $lvm-on where LvmOnRoot::NO]
{
    also does RootAttributes;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Disk::Root(::?CLASS:D: --> Star::Config::Disk::Root:D)
    {
        Star::Config::Disk::Root.^mixin(
            Root[$lvm-on]
        ).bless(|self.get-opts);
    }
}

# Enable LVM. Use only with LVM-compatible C<Filesystem>s.
role Star::Config::Disk::Root::Opts[LvmOnRoot:D $lvm-on where LvmOnRoot::YES]
{
    also does RootAttributes;
    also does RootLvm;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Disk::Root(::?CLASS:D: --> Star::Config::Disk::Root:D)
    {
        Star::Config::Disk::Root.^mixin(
            Root[$lvm-on],
            RootLvm
        ).bless(|self.get-opts);
    }
}

class Star::Config::Disk::Root
{
    method new(
        Star::Config::Disk::Root::Opts:D $r
        --> Star::Config::Disk::Root:D
    )
    {
        Star::Config::Disk::Root($r);
    }
}

my role BootAttributes
{
    #| C<$.filesystem> contains filesystem settings for C</boot>.
    has Star::Config::Disk::Filesystem:D $.filesystem is required;
}

my role BootDevice
{
    #| C<$.device> is the target block device for C</boot>.
    #|
    #| N.B. This device must differ from the target block device for C</>.
    has Str:D $.device is required;
}

my role Boot[RelocateBootTo:D $location]
{
    also does BootAttributes;

    method location(--> RelocateBootTo:D) { $location }
}

class Star::Config::Disk::Boot
{...}

# Useful whenever a separate boot device is needed. In which case, both
# C<$.filesystem> and C<$.device> are required. The caller must ensure
# C</boot>'s C<$.device> differs from C</>'s.
role Star::Config::Disk::Boot::Opts[
    RelocateBootTo:D $location where RelocateBootTo::SEPARATE-DEVICE
]
{
    also does BootAttributes;
    also does BootDevice;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Disk::Boot(::?CLASS:D: --> Star::Config::Disk::Boot:D)
    {
        Star::Config::Disk::Boot.^mixin(
            Boot[$location],
            BootDevice
        ).bless(|self.get-opts);
    }
}

# Useful whenever a separate partition for C</boot> is needed on the block
# device for C</>. In which case, C<$.filesystem> is required.
role Star::Config::Disk::Boot::Opts[
    RelocateBootTo:D $location where RelocateBootTo::SEPARATE-PARTITION
]
{
    also does BootAttributes;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Disk::Boot(::?CLASS:D: --> Star::Config::Disk::Boot:D)
    {
        Star::Config::Disk::Boot.^mixin(
            Boot[$location]
        ).bless(|self.get-opts);
    }
}

# Useful if filesystem formats for C</> and C</boot> differ, and LVM is
# enabled. In which case, the C</boot> filesystem is created on an LVM
# logical volume, rather than on a separate partition.
role Star::Config::Disk::Boot::Opts[
    RelocateBootTo:D $location where RelocateBootTo::LVM-LOGICAL-VOLUME
]
{
    also does BootAttributes;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Disk::Boot(::?CLASS:D: --> Star::Config::Disk::Boot:D)
    {
        Star::Config::Disk::Boot.^mixin(
            Boot[$location]
        ).bless(|self.get-opts);
    }
}

class Star::Config::Disk::Boot
{
    method new(
        Star::Config::Disk::Boot::Opts:D $b
        --> Star::Config::Disk::Boot:D
    )
    {
        Star::Config::Disk::Boot($b);
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

#| C<Star::Config::Disk> stores settings for the C</> and C</boot>
#| filesystems.
#|
#| A separate filesystem for C</boot> is only created if one of the
#| following conditions is true:
#|
#| =begin item
#|
#| The C</> and C</boot> filesystem formats differ, and LVM is disabled.
#| If the C</> and C</boot> filesystem formats differ, and LVM is
#| I<enabled>, the C</boot> filesystem is created on an LVM logical volume
#| within the C</> filesystem - that is, unless another condition
#| necessitating a separate boot partition is met.
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
#| dm-crypt encryption is used to encrypt the C</> filesystem only. This
#| entails having a separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT && DmCryptTarget::ROOT
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used to encrypt the C</boot> filesystem only.
#| This entails having a separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT && DmCryptTarget::BOOT
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used for encrypting the C</> and C</boot>
#| filesystems together with C<BootSecurityLevel::<1FA>>. This entails
#| storing the dm-crypt encrypted root volume's detached header in a
#| separate boot partition.
#|
#|     DiskEncryption::DM-CRYPT
#|         && DmCryptTarget::BOTH
#|         && BootSecurityLevel::<1FA>
#|
#| =end item
#|
#| =begin item
#|
#| dm-crypt encryption is used for encrypting both the C</> and C</boot>
#| filesystems together with C<BootSecurityLevel::<2FA>> and
#| C<SecondFactor::MORT>. This entails storing the dm-crypt encrypted root
#| volume's detached header in a separate boot partition.
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
#| dm-crypt encryption is used for encrypting both the C</> and C</boot>
#| filesystems together with C<BootSecurityLevel::<2FA>> and
#| C<SecondFactor::FIDO2>, C<SecondFactor::KEY> or C<SecondFactor::PKCS>.
#| Since no bootloader at present is able to decrypt a dm-crypt encrypted
#| C</boot> partition using either FIDO2, an external key file, or
#| PKCS#11-compatible security token or smart card during system startup,
#| this entails having a separate boot partition. N<Arguably, a separate
#| boot partition would be required regardless in order to achieve "2FA".
#| Without the separate boot partition, the disk could be decrypted using
#| solely the FIDO2 device, external key file, or PKCS#11-compatible
#| security token or smart card, respectively.>
#|
#|     DiskEncryption::DM-CRYPT
#|         && DmCryptTarget::BOTH
#|         && BootSecurityLevel::<2FA>
#|         && (SecondFactor::FIDO2 || SecondFactor::KEY || SecondFactor::PKCS)
#|
#| =end item
class Star::Config::Disk
{
    # The C</> and C</boot> filesystem formats differ, and LVM is
    # disabled.
    multi method new(
        Star::Config::Disk::Root::Opts[LvmOnRoot::NO] $r,
        Star::Config::Disk::Boot::Opts:D $b where {
            .filesystem.format != $r.filesystem.format
        },
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskRoot, DiskBoot).bless(:$root, :$boot);
    }

    # The filesystem's native encryption implementation is used.
    multi method new(
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        DiskEncryption:D $ where filesystem-encryption($_),
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskRoot, DiskBoot).bless(:$root, :$boot);
    }

    # dm-crypt encryption is used to encrypt either the C</> or C</boot>
    # filesystem only.
    multi method new(
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        DiskEncryption::DM-CRYPT,
        DmCryptTarget:D $ where dm-crypt-target-root-or-boot($_),
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskRoot, DiskBoot).bless(:$root, :$boot);
    }

    # dm-crypt encryption is used for encrypting the C</> and C</boot>
    # filesystems together with an elevated boot security level.
    multi method new(
        Star::Config::Disk::Root::Opts:D $r,
        Star::Config::Disk::Boot::Opts:D $b,
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        BootSecurityLevel:D $ where elevated-bootsec($_),
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        my Star::Config::Disk::Boot $boot .= new($b);
        self.^mixin(DiskRoot, DiskBoot).bless(:$root, :$boot);
    }

    multi method new(
        Star::Config::Disk::Root::Opts:D $r,
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        self.^mixin(DiskRoot).bless(:$root);
    }

    multi method new(
        Star::Config::Disk::Root::Opts:D $r,
        DiskEncryption::NONE,
        *@
        --> Star::Config::Disk:D
    )
    {
        my Star::Config::Disk::Root $root .= new($r);
        self.^mixin(DiskRoot).bless(:$root);
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

# vim: set filetype=raku foldmethod=marker foldlevel=0:
