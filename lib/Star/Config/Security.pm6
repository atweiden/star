use v6;
use Star::Config::Roles;
use Star::Config::Utils;
use Star::Types;

my role DmCryptRootVolumeAttributes
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
    has DmCryptRootVolumeKeyFilePath:D $.key-file is required;

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

my role DmCryptRootVolumeAttributesLuks
{
    #| C<$.iter-time> is the time to spend in ms with PBKDF passphrase
    #| processing on the dm-crypt LUKS-encrypted root volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.iter-time is required;
}

my role DmCryptRootVolumeAttributesLuksHeader
{
    #| C<$.header> is the path to the dm-crypt LUKS-encrypted root volume
    #| detached header.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    has DmCryptRootVolumeLuksHeaderPath:D $.header is required;
}

my role DmCryptRootVolumeMode[
    #| C<$mode> is the dm-crypt encrypted root volume encryption mode.
    #|
    #| C<$mode> must be C<LUKS1> when C<DmCryptTarget::BOTH> and
    #| C<BootSecurityLevel::BASE>, because GRUB is presently practically
    #| speaking incapable of booting from volumes encrypted with any
    #| other dm-crypt encryption mode. This isn't enforced by the type
    #| system here, however, because even if C<DmCryptRootVolumeMode>'s
    #| parametric signature featured the necessary parameters
    #| C<DmCryptTarget> and C<BootSecurityLevel> for detecting invalid
    #| configuration, invalid attempts would merely raise the rather
    #| general exception C<X::Role::Parametric::NoSuchCandidate>. While
    #| catching this exception and subsequently handling it would be a
    #| viable option, better to raise a specialized exception earlier
    #| on in the config instantiation process.
    DmCryptMode:D $mode
    #= C<$mode> is assumed to be valid.
]
{
    #| C<mode> returns the dm-crypt encryption mode to be used in the
    #| creation of the dm-crypt encrypted root volume.
    method mode(--> DmCryptMode:D) { $mode }
}

my role DmCryptBootVolumeAttributes
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
    has DmCryptBootVolumeKeyFilePath:D $.key-file is required;

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

my role DmCryptBootVolumeAttributesLuks
{
    #| C<$.iter-time> is the time to spend in ms with PBKDF passphrase
    #| processing on the dm-crypt LUKS-encrypted boot volume.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.iter-time is required;
}

my role DmCryptBootVolumeMode[
    #| C<$mode> is the dm-crypt encrypted boot volume encryption mode.
    #|
    #| C<$mode> must be C<LUKS1>, because GRUB is presently practically
    #| speaking incapable of booting from volumes encrypted with any other
    #| dm-crypt encryption mode. This isn't enforced by the type system
    #| here, however, for API consistency (see: C<DmCryptRootVolumeMode>).
    DmCryptMode:D $mode
    #= C<$mode> is assumed to be valid.
]
{
    #| C<mode> returns the dm-crypt encryption mode to be used in the
    #| creation of the dm-crypt encrypted boot volume.
    method mode(--> DmCryptMode:D) { $mode }
}

class Star::Config::Security::DmCrypt::Root
{...}

#| C<Star::Config::Security::DmCrypt::Root::Opts> stores properly typed
#| instantiation arguments for C<Star::Config::Security::DmCrypt::Root>,
#| for passing to C<Star::Config::Security::DmCrypt::Root.new>. This is
#| less error prone than perilously passing a C<Hash>.
role Star::Config::Security::DmCrypt::Root::Opts[
    DmCryptMode:D $mode where .&dm-crypt-luks,
    BootSecurityLevel:D $ where .&elevated-bootsec,
    SecondFactor:D $ where SecondFactor::MORT
]
{
    also does DmCryptRootVolumeAttributes;
    also does DmCryptRootVolumeAttributesLuks;
    also does DmCryptRootVolumeAttributesLuksHeader;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Security::DmCrypt::Root(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        Star::Config::Security::DmCrypt::Root.^mixin(
            DmCryptRootVolumeAttributes,
            DmCryptRootVolumeAttributesLuks,
            # Detach dm-crypt LUKS-encrypted root volume header.
            DmCryptRootVolumeAttributesLuksHeader,
            DmCryptRootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

role Star::Config::Security::DmCrypt::Root::Opts[
    DmCryptMode:D $mode where .&dm-crypt-luks,
    # C<BootSecurityLevel::<1FA>> is only used with C<SecondFactor::MORT>.
    BootSecurityLevel:D $ where BootSecurityLevel::<2FA>,
    SecondFactor:D $
]
{
    also does DmCryptRootVolumeAttributes;
    also does DmCryptRootVolumeAttributesLuks;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Security::DmCrypt::Root(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        Star::Config::Security::DmCrypt::Root.^mixin(
            DmCryptRootVolumeAttributes,
            DmCryptRootVolumeAttributesLuks,
            DmCryptRootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

role Star::Config::Security::DmCrypt::Root::Opts[
    DmCryptMode:D $mode where .&dm-crypt-luks,
    BootSecurityLevel:D $ where BootSecurityLevel::BASE
]
{
    also does DmCryptRootVolumeAttributes;
    also does DmCryptRootVolumeAttributesLuks;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Security::DmCrypt::Root(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        Star::Config::Security::DmCrypt::Root.^mixin(
            DmCryptRootVolumeAttributes,
            DmCryptRootVolumeAttributesLuks,
            DmCryptRootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

role Star::Config::Security::DmCrypt::Root::Opts[
    DmCryptMode:D $mode where DmCryptMode::PLAIN,
    BootSecurityLevel:D $,
    SecondFactor:D $?
]
{
    also does DmCryptRootVolumeAttributes;
    also does Star::Config::Roles::GetOpts;

    method Star::Config::Security::DmCrypt::Root(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        Star::Config::Security::DmCrypt::Root.^mixin(
            DmCryptRootVolumeAttributes,
            DmCryptRootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

class Star::Config::Security::DmCrypt::Root
{
    method new(
        Star::Config::Security::DmCrypt::Root::Opts:D $opts,
        --> Star::Config::Security::DmCrypt::Root:D
    )
    {
        Star::Config::Security::DmCrypt::Root($opts);
    }
}

class Star::Config::Security::DmCrypt::Boot
{...}

#| C<Star::Config::Security::DmCrypt::Boot::Opts> stores properly typed
#| instantiation arguments for C<Star::Config::Security::DmCrypt::Boot>,
#| for passing to C<Star::Config::Security::DmCrypt::Boot.new>. This is
#| less error prone than perilously passing a C<Hash>.
role Star::Config::Security::DmCrypt::Boot::Opts[
    DmCryptMode:D $mode where .&dm-crypt-luks
]
{
    also does DmCryptBootVolumeAttributes;
    also does DmCryptBootVolumeAttributesLuks;

    method Star::Config::Security::DmCrypt::Boot(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        Star::Config::Security::DmCrypt::Boot.^mixin(
            DmCryptBootVolumeAttributes,
            DmCryptBootVolumeAttributesLuks,
            DmCryptBootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

role Star::Config::Security::DmCrypt::Boot::Opts[
    DmCryptMode:D $mode where DmCryptMode::PLAIN
]
{
    also does DmCryptBootVolumeAttributes;

    method Star::Config::Security::DmCrypt::Boot(
        ::?CLASS:D:
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        Star::Config::Security::DmCrypt::Boot.^mixin(
            DmCryptBootVolumeAttributes,
            DmCryptBootVolumeMode[$mode]
        ).bless(|self.get-opts);
    }
}

class Star::Config::Security::DmCrypt::Boot
{
    method new(
        Star::Config::Security::DmCrypt::Boot::Opts:D $opts,
        --> Star::Config::Security::DmCrypt::Boot:D
    )
    {
        Star::Config::Security::DmCrypt::Boot($opts);
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
    multi method new(
        DmCryptTarget::BOTH,
        Star::Config::Security::DmCrypt::Root::Opts:D $r,
        Star::Config::Security::DmCrypt::Boot::Opts:D $b
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .= new($r);
        my Star::Config::Security::DmCrypt::Boot $boot-volume .= new($b);
        self.^mixin(
            DmCryptRoot,
            DmCryptBoot
        ).bless(:$root-volume, :$boot-volume);
    }

    multi method new(
        DmCryptTarget::BOTH,
        Star::Config::Security::DmCrypt::Root::Opts:D $r
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .= new($r);
        self.^mixin(DmCryptRoot).bless(:$root-volume);
    }

    multi method new(
        DmCryptTarget::ROOT,
        Star::Config::Security::DmCrypt::Root::Opts:D $r
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Root $root-volume .= new($r);
        self.^mixin(DmCryptRoot).bless(:$root-volume);
    }

    multi method new(
        DmCryptTarget::BOOT,
        Star::Config::Security::DmCrypt::Boot::Opts:D $b
        --> Star::Config::Security::DmCrypt:D
    )
    {
        my Star::Config::Security::DmCrypt::Boot $boot-volume .= new($b);
        self.^mixin(DmCryptBoot).bless(:$boot-volume);
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
    # C<DiskEncryption::NONE> {{{

    multi method new(
        DiskEncryption::NONE
        --> Star::Config::Security:D
    )
    {
        self.bless;
    }

    # end C<DiskEncryption::NONE> }}}
    # C<DiskEncryption::DM-CRYPT> {{{

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        # This covers both C<BootSecurityLevel::<2FA>> with any
        # C<SecondFactor> variant and C<BootSecurityLevel::<1FA>>
        # (which is only compatible with C<SecondFactor::MORT>).
        Star::Config::Security::DmCrypt::Root::Opts $r where .&second-factor,
        Star::Config::Security::DmCrypt::Boot::Opts $b
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::BOTH, $r, $b);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOTH,
        Star::Config::Security::DmCrypt::Root::Opts[BootSecurityLevel::BASE] $r
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::BOTH, $r);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::ROOT,
        Star::Config::Security::DmCrypt::Root::Opts:D $r
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::ROOT, $r);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    multi method new(
        DiskEncryption::DM-CRYPT,
        DmCryptTarget::BOOT,
        Star::Config::Security::DmCrypt::Boot::Opts:D $b
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::BOOT, $b);
        self.^mixin(SecurityDmCrypt).bless(:$dm-crypt);
    }

    # end C<DiskEncryption::DM-CRYPT> }}}
    # C<DiskEncryption::FILESYSTEM> {{{

    multi method new(
        DiskEncryption::FILESYSTEM
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(SecurityFilesystem).bless(:$filesystem);
    }

    # end C<DiskEncryption::FILESYSTEM> }}}
    # C<DiskEncryption::DMFS> {{{

    multi method new(
        DiskEncryption::DMFS,
        DmCryptTarget::BOTH,
        Star::Config::Security::DmCrypt::Root::Opts:D $r,
        Star::Config::Security::DmCrypt::Boot::Opts:D $b
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::BOTH, $r, $b);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # A separate C</boot> partition is needed for C<DiskEncryption::DMFS>
    # plus C<DmCryptTarget::ROOT>, but it won't be encrypted. Hence, we
    # don't want C<Star::Config::Security::DmCrypt::Boot::Opts>, here.
    multi method new(
        DiskEncryption::DMFS,
        DmCryptTarget::ROOT,
        Star::Config::Security::DmCrypt::Root::Opts:D $r
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::ROOT, $r);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);

    }

    multi method new(
        DiskEncryption::DMFS,
        DmCryptTarget::BOOT,
        Star::Config::Security::DmCrypt::Boot::Opts:D $b
        --> Star::Config::Security:D
    )
    {
        my Star::Config::Security::DmCrypt $dm-crypt .=
            new(DmCryptTarget::BOOT, $b);
        my Star::Config::Security::Filesystem $filesystem .= new;
        self.^mixin(
            SecurityDmCrypt,
            SecurityFilesystem
        ).bless(:$dm-crypt, :$filesystem);
    }

    # end C<DiskEncryption::DMFS> }}}
}

=head2 Helper functions

multi sub dm-crypt-luks(DmCryptMode::LUKS1 --> True) {*}
multi sub dm-crypt-luks(DmCryptMode::LUKS2 --> True) {*}
multi sub dm-crypt-luks(DmCryptMode::PLAIN --> False) {*}

multi sub second-factor(
    Star::Config::Security::DmCrypt::Root::Opts[
        Mode:D,
        BootSecurityLevel::<1FA>,
        SecondFactor:D
    ] $
    --> True
)
{*}

multi sub second-factor(
    Star::Config::Security::DmCrypt::Root::Opts[
        Mode:D,
        BootSecurityLevel::<2FA>,
        SecondFactor:D
    ] $
    --> True
)
{*}

multi sub second-factor(
    Star::Config::Security::DmCrypt::Root::Opts[
        Mode:D,
        BootSecurityLevel::BASE
    ] $
    --> False
)
{*}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
