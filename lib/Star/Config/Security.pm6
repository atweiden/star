use v6;
use Star::Types;

my role DmCryptRootVolume[
    #| C<$mode> is the dm-crypt encrypted root volume encryption mode.
    #|
    #| C<$mode> must be C<LUKS1> when C<DmCryptTarget::BOTH> and
    #| C<BootSecurityLevel::BASE>, because GRUB is presently practically
    #| speaking incapable of booting from volumes encrypted with any other
    #| dm-crypt encryption mode. This isn't enforced by the type system
    #| here, however, because even if C<DmCryptRootVolume>'s parametric
    #| signature featured the necessary parameters C<DmCryptTarget> and
    #| C<BootSecurityLevel> for detecting invalid configuration, invalid
    #| attempts would merely raise the rather general exception
    #| C<X::Role::Parametric::NoSuchCandidate>. While catching this
    #| exception and subsequently handling it would be a viable option,
    #| better to raise a specialized exception earlier on in the config
    #| instantiation process.
    DmCryptMode:D $mode
    #= C<$mode> is assumed to be valid.
]
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

    #| C<mode> returns the dm-crypt encryption mode to be used in the
    #| creation of the dm-crypt encrypted root volume.
    method mode(--> DmCryptMode:D) { $mode }
}

my role DmCryptRootVolumeHeader
{
    #| C<$.header> is the path to the dm-crypt encrypted root volume
    #| detached header.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    has DmCryptRootVolumeHeader:D $.header is required;
}

my role DmCryptBootVolume[
    #| C<$mode> is the dm-crypt encrypted boot volume encryption mode.
    #|
    #| C<$mode> must be C<LUKS1>, because GRUB is presently practically
    #| speaking incapable of booting from volumes encrypted with any other
    #| dm-crypt encryption mode. This isn't enforced by the type system
    #| here, however, for API consistency (see: C<DmCryptRootVolume>).
    DmCryptMode:D $mode
    #= C<$mode> is assumed to be valid.
]
{
    #| C<$.name> is the name of the dm-crypt encrypted boot volume.
    #|
    #| This name is used when opening the dm-crypt encrypted boot volume,
    #| e.g.
    #|
    #|     qqx{cryptsetup luksOpen /dev/sda3 $.name}
    #|
    #| It's recorded in important system settings files, such as
    #| C</etc/crypttab>.
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

    #| C<mode> returns the dm-crypt encryption mode to be used in the
    #| creation of the dm-crypt encrypted boot volume.
    method mode(--> DmCryptMode:D) { $mode }
}

class Star::Config::Security::DmCrypt::Root
{
    multi method new(
        DmCryptMode:D :$mode!,
        BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_),
        *%opts (
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        )
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        self.^mixin(
            DmCryptRootVolume[$mode],
            # Detach dm-crypt encrypted root volume header for
            # C<BootSecurityLevel::<1FA>> and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader
        ).bless(|%opts);
    }

    multi method new(
        DmCryptMode:D :$mode!,
        BootSecurityLevel :boot-security-level($),
        *%opts (
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        )
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        self.^mixin(DmCryptRootVolume[$mode]).bless(|%opts);
    }
}

class Star::Config::Security::DmCrypt::Boot
{
    method new(
        DmCryptMode:D :$mode!,
        *%opts (
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        )
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        self.^mixin(DmCryptBootVolume[$mode]).bless(|%opts);
    }
}

my role DmCryptRoot
{
    has Star::Config::Security::DmCrypt::Root:D $.root-volume is required;
}

my role DmCryptBoot
{
    has Star::Config::Security::DmCrypt::Boot:D $.boot-volume is required;
}

class Star::Config::Security::DmCrypt
{
    # C<DmCryptTarget::BOTH> {{{

    multi method new(
        %opts-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        %opts-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
        BootSecurityLevel:D :$boot-security-level! where elevated-bootsec($_)
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .=
            new(|%opts-root, :$boot-security-level);
        my Star::Config::Security::DmCrypt::Boot $boot-volume .=
            new(|%opts-boot);
        self.^mixin(
            DmCryptRoot,
            DmCryptBoot
        ).bless(:$root-volume, :$boot-volume);
    }

    # Special case for C<DiskEncryption::DMFS>.
    multi method new(
        %opts-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        %opts-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
        BootSecurityLevel:D :$boot-security-level!
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .=
            new(|%opts-root, :$boot-security-level);
        my Star::Config::Security::DmCrypt::Boot $boot-volume .=
            new(|%opts-boot);
        self.^mixin(
            DmCryptRoot,
            DmCryptBoot
        ).bless(:$root-volume, :$boot-volume);
    }

    multi method new(
        %opts-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
        BootSecurityLevel:D :$boot-security-level!
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .=
            new(|%opts-root, :$boot-security-level);
        self.^mixin(DmCryptRoot).bless(:$root-volume);
    }

    # end C<DmCryptTarget::BOTH> }}}
    # C<DmCryptTarget::ROOT> {{{

    multi method new(
        %opts-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
        BootSecurityLevel:D :$boot-security-level! where elevated-bootsec($_)
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .=
            new(|%opts-root, :$boot-security-level);
        self.^mixin(DmCryptRoot).bless(:$root-volume);
    }

    multi method new(
        %opts-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
        BootSecurityLevel:D :$boot-security-level!
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .=
            new(|%opts-root, :$boot-security-level);
        self.^mixin(DmCryptRoot).bless(:$root-volume);
    }

    # end C<DmCryptTarget::ROOT> }}}
    # C<DmCryptTarget::BOOT> {{{

    multi method new(
        %opts-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOOT,
        BootSecurityLevel:D :boot-security-level($)
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Boot $boot-volume .=
            new(|%opts-boot);
        self.^mixin(DmCryptBoot).bless(:$boot-volume);
    }

    # end C<DmCryptTarget::BOOT> }}}
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
    # C<DiskEncryption::NONE> {{{

    multi method new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::NONE,
        --> Star::Config::Security::DmCrypt:D
    )
    {
        self.bless;
    }

    # end C<DiskEncryption::NONE> }}}
    # C<DiskEncryption::DM-CRYPT> {{{

    # --- C<DmCryptTarget::BOTH> {{{

    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        %opts-dm-crypt-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
            BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, %opts-dm-crypt-boot, |%opts);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
            BootSecurityLevel:D :boot-security-level($)!
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, |%opts);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    # --- end C<DmCryptTarget::BOTH> }}}
    # --- C<DmCryptTarget::ROOT> {{{

    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
            BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, |%opts);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
            BootSecurityLevel:D :boot-security-level($)!
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, |%opts);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    # --- end C<DmCryptTarget::ROOT> }}}
    # --- C<DmCryptTarget::BOOT> {{{

    multi method new(
        %opts-dm-crypt-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DM-CRYPT,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOOT,
            BootSecurityLevel:D :boot-security-level($)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-boot, |%opts);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    # --- end C<DmCryptTarget::BOOT> }}}

    # end C<DiskEncryption::DM-CRYPT> }}}
    # C<DiskEncryption::FILESYSTEM> {{{

    multi method new(
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::FILESYSTEM,
        *%opts (
            BootSecurityLevel:D :boot-security-level($)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(SecurityFilesystem).bless(:$filesystem);
    }

    # end C<DiskEncryption::FILESYSTEM> }}}
    # C<DiskEncryption::DMFS> {{{

    # --- C<DmCryptTarget::BOTH> {{{

    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        %opts-dm-crypt-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DMFS,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
            BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, %opts-dm-crypt-boot, |%opts);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # This would only require a dm-crypt encrypted root volume if we had
    # C<DiskEncryption::DM-CRYPT> here instead of C<DiskEncryption::DMFS>.
    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        # Separate dm-crypt encrypted boot volume needed, because dm-crypt
        # encrypted root volume I<filesystem> will be encrypted with the
        # filesystem's native encryption implementation, which GRUB can't
        # decrypt.
        %opts-dm-crypt-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DMFS,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOTH,
            # Regardless of C<BootSecurityLevel>, we need a separate
            # dm-crypt encrypted boot partition. N.B. This multi method
            # signature only differs from the multi method signature which
            # precedes it by not requiring a C<header> key be passed in
            # C<%opts-dm-crypt-root>. C<header> attribute required for
            # C<BootSecurityLevel::<1FA>> and C<BootSecurityLevel::<2FA>>.
            BootSecurityLevel:D :boot-security-level($)!
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, %opts-dm-crypt-boot, |%opts);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # --- end C<DmCryptTarget::BOTH> }}}
    # --- C<DmCryptTarget::ROOT> {{{

    # A separate boot partition is needed for C<DiskEncryption::DMFS> plus
    # C<DmCryptTarget::ROOT>, but it won't be encrypted. Hence, we don't
    # want C<%opts-dm-crypt-boot>.
    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            # C<header> attribute required for C<BootSecurityLevel::<1FA>>
            # and C<BootSecurityLevel::<2FA>>.
            DmCryptRootVolumeHeader:D :header($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DMFS,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
            BootSecurityLevel:D :boot-security-level($)! where elevated-bootsec($_)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, |%opts);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # Similar to the multi method signature which precedes it, a separate
    # boot partition is needed here, but it's unencrypted. Hence, we don't
    # want C<%opts-dm-crypt-boot>.
    multi method new(
        %opts-dm-crypt-root (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptRootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DMFS,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::ROOT,
            BootSecurityLevel:D :boot-security-level($)!
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-root, |%opts);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # --- end C<DmCryptTarget::ROOT> }}}
    # --- C<DmCryptTarget::BOOT> {{{

    multi method new(
        %opts-dm-crypt-boot (
            DmCryptMode:D :mode($)!,
            DeviceName:D :name($)!,
            DmCryptBootVolumeKeyFile:D :key-file($)!,
            Str:D :cipher($)!,
            Str:D :hash($)!,
            Str:D :iter-time($)!,
            Str:D :key-size($)!,
            DmCryptVolumePassword :pass($),
            Str :offset($),
            Str :sector-size($)
        ),
        DiskEncryption:D :disk-encryption($)! where DiskEncryption::DMFS,
        *%opts (
            DmCryptTarget:D :dm-crypt-target($)! where DmCryptTarget::BOOT,
            BootSecurityLevel:D :boot-security-level($)
        )
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(%opts-dm-crypt-boot, |%opts);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # --- end C<DmCryptTarget::BOOT> }}}

    # end C<DiskEncryption::DMFS> }}}
}

multi sub elevated-bootsec(BootSecurityLevel::<1FA> --> True) {*}
multi sub elevated-bootsec(BootSecurityLevel::<2FA> --> True) {*}
multi sub elevated-bootsec($ --> False) {*}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
