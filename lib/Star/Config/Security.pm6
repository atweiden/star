use v6;
use Star::Types;

my role DmCryptRootVolume
{
    #| C<$.name> is the name of the dm-crypt encrypted root volume.
    #|
    #| This name is used when opening the dm-crypt encrypted root volume,
    #| e.g.
    #|
    #|     qqx{cryptsetup luksOpen /dev/sda3 $.name}
    #|
    #| It's recorded in important system settings files, such as
    #| C</etc/default/grub> (see: C<cryptdevice> on Arch, C<rd.luks.name>
    #| on Void and distros using Dracut) and C</etc/crypttab>.
    has DeviceName:D $.name is required;

    #| C<$.pass> is the password for the dm-crypt encrypted root volume.
    #|
    #| This attribute is deliberately left optional. Passwords are best
    #| entered interactively via C<cryptsetup>.
    has DmCryptVolumePassword $.pass;

    #| C<$.key-file> is the path to the dm-crypt encrypted root volume
    #| key file stored on disk. This key is randomly generated during
    #| installation, and serves to avoid having to enter the dm-crypt
    #| encrypted root volume password twice during system startup.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    has DmCryptRootVolumeKeyFile:D $.key-file is required;

    #| C<$.cipher> contains the cipher specification for the dm-crypt
    #| encrypted root volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.cipher is required;

    #| C<$.hash> contains the passphrase hash used in the LUKS key setup
    #| scheme and dm-crypt encrypted root volume key digest.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.hash is required;

    #| C<$.iter-time> is the time to spend in ms with PBKDF passphrase
    #| processing on the dm-crypt encrypted root volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.iter-time is required;

    #| C<$.key-size> is the key size in bits for the dm-crypt encrypted
    #| root volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.key-size is required;

    #| C<$.offset> is the start offset in the dm-crypt encrypted root
    #| volume backend device.
    #|
    #| N.B. This value must be given in human-readable format, e.g. C<5G>.
    #| This differs from the behaviour of I<cryptsetup>, which requires
    #| passing a "sector count". C<$.offset> also accepts sector counts
    #| via postfix C<S>, e.g. C<10485760S>.
    #|
    #| See: C<man cryptsetup>, and C<gen-cryptsetup-luks-offset>.
    has Str $.offset;

    #| C<$.sector-size> is the sector size in bytes for use with the
    #| dm-crypt encrypted root volume.
    #|
    #| See: C<man cryptsetup>.
    has Str $.sector-size;
}

my role DmCryptRootVolumeHeader
{
    #| C<$.header> is the path to the dm-crypt encrypted root volume
    #| detached header.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    has DmCryptRootVolumeHeader:D $.header is required;
}

my role DmCryptBootVolume
{
    #| C<$.name> is the name of the dm-crypt encrypted boot volume.
    #|
    #| This name is used when opening the dm-crypt encrypted boot volume,
    #| e.g.
    #|
    #|     qqx{cryptsetup luksOpen /dev/sda3 $.name}
    #|
    #| It's recorded in important system settings files, such as
    #| C</etc/default/grub> (see: C<cryptdevice> on Arch, C<rd.luks.name>
    #| on Void and distros using Dracut) and C</etc/crypttab>.
    has DeviceName:D $.name is required;

    #| C<$.pass> is the password for the dm-crypt encrypted boot volume.
    #|
    #| This attribute is deliberately left optional. Passwords are best
    #| entered interactively via C<cryptsetup>.
    has DmCryptVolumePassword $.pass;

    #| C<$.key-file> is the path to the dm-crypt encrypted boot volume
    #| key file stored on disk. This key is randomly generated during
    #| installation, and serves to avoid having to enter the dm-crypt
    #| encrypted boot volume password twice during system startup.
    #|
    #| N.B. The path must be inside of C</root> (The Bootvault secret
    #| prefix).
    has DmCryptBootVolumeKeyFile:D $.key-file is required;

    #| C<$.cipher> contains the cipher specification for the dm-crypt
    #| encrypted boot volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.cipher is required;

    #| C<$.hash> contains the passphrase hash used in the LUKS key setup
    #| scheme and dm-crypt encrypted boot volume key digest.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.hash is required;

    #| C<$.iter-time> is the time to spend in ms with PBKDF passphrase
    #| processing on the dm-crypt encrypted boot volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.iter-time is required;

    #| C<$.key-size> is the key size in bits for the dm-crypt encrypted
    #| boot volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.key-size is required;

    #| C<$.offset> is the start offset in the dm-crypt encrypted boot
    #| volume backend device.
    #|
    #| N.B. This value must be given in human-readable format, e.g. C<5G>.
    #| This differs from the behaviour of I<cryptsetup>, which requires
    #| passing a "sector count". C<$.offset> also accepts sector counts
    #| via postfix C<S>, e.g. C<10485760S>.
    #|
    #| See: C<man cryptsetup>, and C<gen-cryptsetup-luks-offset>.
    has Str $.offset;

    #| C<$.sector-size> is the sector size in bytes for use with the
    #| dm-crypt encrypted boot volume.
    #|
    #| See: C<man cryptsetup>.
    has Str $.sector-size;
}

my role DmCryptBootVolumeDevice
{
    #| C<$.device> is the target block device path for the dm-crypt
    #| encrypted boot volume.
    #|
    #| N.B. This device must differ from the target block device for the
    #| system root (or dm-crypt encrypted root volume).
    has Str:D $.device is required;
}

class Star::Config::Security::DmCrypt::Root
{
    also does DmCryptRootVolume;

    multi method new(
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        *%opts (
        )
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        # Detach dm-crypt encrypted root volume header when using elevated
        # boot security levels.
        self.^mixin(DmCryptRootVolumeHeader).bless(|%opts);
    }

    multi method new(
        BootSecurityLevel :boot-security-level($),
        *%opts (
        )
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        self.bless(|%opts);
    }
}

class Star::Config::Security::DmCrypt::Boot
{
    also does DmCryptBootVolume;

    multi method new(
        BootSecurityLevel:D :boot-security-level($)! where BootSecurityLevel::<2FA>,
        *%opts (
        )
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        # Install dm-crypt encrypted boot volume to separate device when
        # using 2FA boot security level.
        self.^mixin(DmCryptBootVolumeDevice).bless(|%opts);
    }

    multi method new(
        BootSecurityLevel :boot-security-level($),
        *%opts (
        )
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        self.bless(|%opts);
    }
}

my role DmCryptBoot
{
    has Star::Config::Security::DmCrypt::Boot:D $.boot-volume is required;
}

my role DmCryptRoot
{
    has Star::Config::Security::DmCrypt::Root:D $.root-volume is required;
}

class Star::Config::Security::DmCrypt
{
    multi method new(
        *%opts (
            BootSecurityLevel:D $ where BootSecurityLevel::<2FA>,
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        self.^mixin(DmCryptRoot, DmCryptBoot).bless(|%opts);
    }

    multi method new(
        *%opts (
            BootSecurityLevel:D $,
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        self.^mixin(DmCryptRoot).bless(|%opts);
    }

    multi method new(
        *%opts (
            BootSecurityLevel:D $,
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        self.^mixin(DmCryptBoot).bless(|%opts);
    }
}

class Star::Config::Security::Filesystem
{*}

my role SecurityDmCrypt
{
    has Star::Config::Security::DmCrypt:D $.dm-crypt is required;
}

my role SecurityFilesystem
{
    has Star::Config::Security::Filesystem:D $.filesystem is required;
}

class Star::Config::Security
{
    method new(
        *%opts (
            DiskEncryption :disk-encryption($),
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
        --> Star::Config::Security:D
    )
    {
        # Facilitate use of subroutines.
        my $*self = self;
        new(|%opts);
    }

    multi sub new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::NONE,
        *% (
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        new-encryption-none();
    }

    multi sub new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        new-encryption-dm-crypt(|%opts);
    }

    multi sub new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::FILESYSTEM,
        *%opts (
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        new-encryption-filesystem(|%opts);
    }

    multi sub new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::BOTH,
        *%opts (
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        new-encryption-both(|%opts),
    }

    multi sub new(
        *% (
            DiskEncryption :disk-encryption($),
            BootSecurityLevel :boot-security-level($),
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        new-encryption-none();
    }

    multi sub new-encryption-none()
    {
        self.bless;
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
        DmCryptMode:D :dm-crypt-root-volume-mode($)!,
        DmCryptMode:D :dm-crypt-boot-volume-mode($)!
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
        DmCryptMode:D :dm-crypt-root-volume-mode($)!,
        DmCryptMode :dm-crypt-boot-volume-mode($)
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOOT,
        DmCryptMode:D :dm-crypt-boot-volume-mode($)!,
        DmCryptMode :dm-crypt-root-volume-mode($)
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)!,
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
        DmCryptMode:D :dm-crypt-root-volume-mode($)!,
        DmCryptMode :dm-crypt-boot-volume-mode($)
    )
    {
        # without separate boot partition
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)!,
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
        DmCryptMode:D :dm-crypt-root-volume-mode($)!,
        DmCryptMode :dm-crypt-boot-volume-mode($)
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-dm-crypt(
        BootSecurityLevel:D :boot-security-level($)!,
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOOT,
        DmCryptMode:D :dm-crypt-boot-volume-mode($)!,
        DmCryptMode :dm-crypt-root-volume-mode($)
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-fileystem(
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        *% (
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        # with separate boot partition
    }

    multi sub new-encryption-fileystem(
        BootSecurityLevel :boot-security-level($),
        *% (
            DmCryptTarget :dm-crypt-target($),
            DmCryptMode :dm-crypt-root-volume-mode($),
            DmCryptMode :dm-crypt-boot-volume-mode($)
        )
    )
    {
        # with separate boot partition
    }
}

multi sub elevated-bootsec(BootSecurityLevel::<1FA> --> True) {*}
multi sub elevated-bootsec(BootSecurityLevel::<2FA> --> True) {*}
multi sub elevated-bootsec($ --> False) {*}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
