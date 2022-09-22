use v6;
use Star::Constants;
use Star::System::Utils;
unit module Star::Types;

my \Utils = Star::System::Utils;

=head2 Enums

#| C<BootSecurityLevel> is an enum whose variants represent the different
#| boot security levels supported by Star.
#|
#| =for item1
#| C<BASE>: One or two encrypted partitions on single device - one for
#| C</> and one for </boot>, or one shared partition for both C</> and
#| C</boot>. When C</boot> is on a separate partition, its partition
#| and/or C</>'s may be encrypted (see: C<DmCryptTarget>). When C</boot>
#| is stored in the same partition as C</>, however, C</boot> is encrypted
#| along with the rest of the system.
#|
#| =begin item1
#|
#| C<1FA>: Mostly for development purposes. Only for use with combined
#| settings C<DiskEncryption::DM-CRYPT> (or C<DiskEncryption::DMFS>),
#| either C<DmCryptTarget::ROOT> or C<DmCryptTarget::BOTH>, and
#| C<SecondFactor::MORT>.
#|
#| Two partitions on single device, one for C</> and one for C</boot>.
#| C</boot>'s partition may or may not be encrypted, depending. C</>'s
#| partition is encrypted and headerless, its header detached and stored
#| in C</boot>'s partition as applicable.
#|
#| =end item1
#|
#| =begin item1
#|
#| C<2FA>: Implementation depends on C<DiskEncryption>, C<DmCryptTarget>,
#| and C<SecondFactor>.
#|
#| C<BootSecurityLevel::<2FA>> can't be used with the combined settings
#| C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::FIDO2>, because this would only encrypt C</boot>, and
#| no bootloader at present is able to decrypt a dm-crypt encrypted
#| C</boot> partition using FIDO2 during system startup. The second factor
#| mechanism would be unusable.
#|
#| C<BootSecurityLevel::<2FA>> can't be used with the combined settings
#| C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::KEY>, because this would only encrypt C</boot>, and no
#| bootloader at present is able to decrypt a dm-crypt encrypted C</boot>
#| partition using an external key file during system startup. The second
#| factor mechanism would be unusable.
#|
#| C<BootSecurityLevel::<2FA>> can't be used with the combined settings
#| C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::MORT>, because this would only encrypt C</boot>, and no
#| bootloader at present is able to decrypt a headerless dm-crypt
#| encrypted C</boot> partition during system startup.
#|
#| C<BootSecurityLevel::<2FA>> can't be used with the combined settings
#| C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::PKCS>, because this would only encrypt C</boot>, and no
#| bootloader at present is able to decrypt a dm-crypt encrypted C</boot>
#| partition using a PKCS#11-compatible security token or smart card
#| during system startup. The second factor mechanism would be unusable.
#|
#| C<BootSecurityLevel::<2FA>> can't be used with the combined settings
#| C<DiskEncryption::FILESYSTEM> and C<SecondFactor::MORT>, because
#| C<SecondFactor::MORT> requires the presence of a dm-crypt encrypted
#| volume.
#|
#| =end item1
#|
#| =for item2
#| With C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::FIDO2>: A FIDO2 device
#| decrypts the dm-crypt encrypted root volume.
#|
#| =for item2
#| With C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::KEY>: A key file in an
#| external storage drive decrypts the dm-crypt encrypted root volume.
#|
#| =for item2
#| With C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::MORT>: An external storage
#| drive acts as the second factor. The C</boot> partition is stored in
#| the external storage drive either encrypted or unencrypted, depending.
#| The root volume is encrypted and headerless, its header detached and
#| stored in the C</boot> partition as applicable.
#|
#| =for item2
#| With C<DiskEncryption::DM-CRYPT>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::PKCS>: A PKCS#11-compatible
#| security token or smart card decrypts the dm-crypt encrypted root
#| volume.
#|
#| =for item2
#| With C<DiskEncryption::FILESYSTEM> and C<SecondFactor::FIDO2>: A FIDO2
#| device decrypts the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::FILESYSTEM> and C<SecondFactor::KEY>: A key file
#| in an external storage drive decrypts the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::FILESYSTEM> and C<SecondFactor::PKCS>: A
#| PKCS#11-compatible security token or smart card decrypts the root
#| filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::FIDO2>: A FIDO2 device
#| decrypts both the dm-crypt encrypted root volume and the root
#| filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::KEY>: A key file in an
#| external storage drive decrypts both the dm-crypt encrypted root volume
#| and the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::MORT>: An external storage
#| drive acts as the second factor. The C</boot> partition is stored in
#| the external storage drive either encrypted or unencrypted, depending.
#| The root volume is encrypted and headerless, its header detached and
#| stored in the C</boot> partition as applicable.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::ROOT> (or
#| C<DmCryptTarget::BOTH>) and C<SecondFactor::PKCS>: A PKCS#11-compatible
#| security token or smart card decrypts both the dm-crypt encrypted root
#| volume and the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::FIDO2>: A FIDO2 device decrypts the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::KEY>: A key file in an external storage drive decrypts
#| the root filesystem.
#|
#| =for item2
#| With C<DiskEncryption::DMFS>, C<DmCryptTarget::BOOT> and
#| C<SecondFactor::PKCS>: A PKCS#11-compatible security token or smart
#| card decrypts the root filesystem.
#|
#| C<BootSecurityLevel> is only relevant when disk encryption is used,
#| either C<DiskEncryption::DM-CRYPT>, C<DiskEncryption::FILESYSTEM> or
#| C<DiskEncryption::DMFS>.
enum BootSecurityLevel is export <
    BASE
    1FA
    2FA
>;

#| C<DeviceLocator> is an enum whose variants represent the different
#| identifiers by which a target device can be located.
#|
#| =item C<ID>: device ID
#| =item C<PARTUUID>: partition-table level UUID for partition
#| =item C<UUID>: filesystem-level UUID
enum DeviceLocator is export <
    ID
    PARTUUID
    UUID
>;

#| C<DiskEncryption> is an enum whose variants represent the different
#| disk encryption modes supported by Star.
#|
#| =for item
#| C<NONE>: Disable disk encryption.
#|
#| =for item
#| C<DM-CRYPT>: Enable disk encryption via the dm-crypt kernel crypto
#| API. Uses I<cryptsetup>. Can be used to encrypt C</boot>.
#|
#| =for item
#| C<FILESYSTEM>: Enable disk encryption via the filesystem's native
#| encryption implementation. Only available for C<Filesystem::EXT4>
#| and C<Filesystem::F2FS>. Can't be used to encrypt C</boot>.
#|
#| =for item
#| C<DMFS>: Enable disk encryption both via the dm-crypt kernel crypto
#| API and the filesystem's native encryption implementation. Only
#| available for C<Filesystem::EXT4> and C<Filesystem::F2FS>. May be
#| used to encrypt the C</boot> partition via dm-crypt while encrypting
#| the C</> partition via the filesystem's native encryption
#| implementation.
enum DiskEncryption is export <
    NONE
    DM-CRYPT
    FILESYSTEM
    DMFS
>;
#= C<DMFS> is named as such to avoid exporting symbol C<BOTH> twice (see:
#= C<DmCryptTarget>).

#| C<DmCryptMode> is an enum whose variants represent the different
#| dm-crypt encryption modes available.
#|
#| =item C<LUKS1>: Linux Unified Key Setup (LUKS), version 1 format
#| =item C<LUKS2>: LUKS, version 2 format
#| =item C<PLAIN>: dm-crypt plain mode
enum DmCryptMode is export <
    LUKS1
    LUKS2
    PLAIN
>;

#| C<DmCryptTarget> is an enum whose variants represent the different
#| targets for encryption via the dm-crypt kernel crypto API.
#|
#| =for item
#| C<ROOT>: Only encrypt the root volume (or C</> partition). C</boot>
#| will be unencrypted.
#|
#| =for item
#| C<BOOT>: Only encrypt the C</boot> partition. The C</> partition will
#| be unencrypted.
#|
#| =for item
#| C<BOTH>: Encrypt both the root volume (or C</> partition) in addition
#| to C</boot>. C</boot> may or may not reside on a separate partition
#| (see: C<BootSecurityLevel>).
#|
#| N.B. C<BOOT> and C<BOTH> require selecting the GRUB bootloader.
#| Currently, no other bootloader supports booting from an encrypted
#| C</boot>.
enum DmCryptTarget is export <
    ROOT
    BOOT
    BOTH
>;

#| C<Distro> is an enum whose variants represent the different Linux
#| distributions Star is capable of installing.
#|
#| =item C<ALPINE>: L<https://www.alpinelinux.org>
#| =item C<ARCH>: L<https://archlinux.org>
#| =item C<CHIMERA>: L<https://chimera-linux.org>
#| =item C<GENTOO>: L<https://www.gentoo.org>
#| =item C<VOID>: L<https://voidlinux.org>
enum Distro is export <
    ALPINE
    ARCH
    CHIMERA
    GENTOO
    VOID
>;

#| C<DriveType> is an enum whose variants represent the different types
#| of hard drives.
#|
#| =item C<HDD>: hard disk drive (rotational)
#| =item C<SSD>: solid state drive (NVMe included)
#| =item C<USB>: external storage drive connected via USB port
enum DriveType is export <
    HDD
    SSD
    USB
>;

#| C<Filesystem> is an enum whose variants represent the different
#| filesystems Star is capable of creating.
#|
#| =item C<BTRFS>: L<https://btrfs.wiki.kernel.org>
#| =item C<EXT2>: L<https://www.kernel.org/doc/html/latest/filesystems/ext2.html>
#| =item C<EXT3>: L<https://www.kernel.org/doc/html/latest/filesystems/ext3.html>
#| =item C<EXT4>: L<https://ext4.wiki.kernel.org>
#| =item C<F2FS>: L<https://www.kernel.org/doc/html/latest/filesystems/f2fs.html>
#| =item C<NILFS2>: L<https://www.kernel.org/doc/html/latest/filesystems/nilfs2.html>
#| =item C<XFS>: L<https://xfs.wiki.kernel.org>
enum Filesystem is export <
    BTRFS
    EXT2
    EXT3
    EXT4
    F2FS
    NILFS2
    XFS
>;

#| C<Graphics> is an enum whose variants represent the different types
#| of graphics cards.
#|
#| =item C<INTEGRATED>: Intel or integrated graphics card
#| =item C<NVIDIA>: NVIDIA dedicated/switchable graphics card
#| =item C<RADEON>: AMD/ATI Radeon dedicated/switchable graphics card
enum Graphics is export <
    INTEGRATED
    NVIDIA
    RADEON
>;

#| C<Libc> is an enum whose variants represent the different C standard
#| library implementations.
#|
#| =item C<GLIBC>: L<https://www.gnu.org/software/libc/>
#| =item C<MUSL>: L<https://musl.libc.org>
enum Libc is export <
    GLIBC
    MUSL
>;

#| C<LvmOnRoot> is an enum whose variants represent whether LVM is enabled
#| on the root device.
#|
#| Exists as a workaround for limitations of C<Bool> in parameterized role
#| signatures.
#|
#| =item C<DISABLED>: Disable LVM on root device
#| =item C<ENABLED>: Enable LVM on root device
enum LvmOnRoot is export <
    DISABLED
    ENABLED
>;

#| C<Processor> is an enum whose variants represent the different types
#| of x86 processors supported by Star.
#|
#| =item C<AMD>
#| =item C<INTEL>
enum Processor is export <
    AMD
    INTEL
>;

#| C<RelocateBootTo> is an enum whose variants represent where to relocate
#| C</boot> to.
#|
#| =item C<LVM-LOGICAL-VOLUME>: Relocate C</boot> to LVM logical volume
#| =item C<SEPARATE-PARTITION>: Relocate C</boot> to separate partition
#| =item C<SEPARATE-DEVICE>: Relocate C</boot> to separate device
enum RelocateBootTo is export <
    LVM-LOGICAL-VOLUME
    SEPARATE-PARTITION
    SEPARATE-DEVICE
>;

#| C<SecondFactor> is an enum whose variants represent the different
#| mechanisms for achieving C<BootSecurityLevel::<2FA>>.
#|
#| =for item
#| C<FIDO2>: Decrypt C</> partition with FIDO2 device. Not necessarily a
#| true second factor mechanism unless combined with a dm-crypt encrypted
#| C</boot> partition. N<And even then, only if the term "2FA" is allowed
#| to be satisfied in the broader context of system startup, as opposed to
#| disk decryption itself. The limitation here is the fact the dm-crypt
#| encrypted C</boot> partition can only be decrypted with a password
#| (something you know), while the C</> partition can only be decrypted
#| with the FIDO2 device (something you have). Hence, neither the C</boot>
#| nor the C</> partition require I<both> something you have I<and>
#| something you know to decrypt. Only C<SecondFactor::MORT> can stop an
#| adversary from decrypting the C</boot> and C</> partitions separately
#| or together without possessing both something you know and something
#| you have.>
#|
#| =for item
#| C<KEY>: Decrypt C</> partition with key file in external storage drive.
#| Not necessarily a true second factor mechanism unless combined with a
#| dm-crypt encrypted C</boot> partition. N<The caveat in the
#| C<SecondFactor::FIDO2> footnote applies to C<SecondFactor::KEY> - that
#| is, unless the key file is encrypted. Encrypting the key file can stop
#| an adversary from decrypting the C</> partition without possessing both
#| something you know and something you have, but it would remain possible
#| for an adversary to decrypt the C</boot> partition with only something
#| you know.>
#|
#| =for item
#| C<MORT>: Decrypt dm-crypt encrypted volume with detached header stored
#| on C</boot> partition in external storage drive.
#|
#| =for item
#| C<PKCS>: Decrypt C</> partition with PKCS#11-compatible security token
#| or smart card. Not necessarily a true second factor mechanism unless
#| combined with a dm-crypt encrypted C</boot> partition. N<The caveat in
#| the C<SecondFactor::FIDO2> footnote applies to C<SecondFactor::PKCS>.>
enum SecondFactor is export <
    FIDO2
    KEY
    MORT
    PKCS
>;

#| C<UdevProperty> is an enum whose variants represent properties by
#| which to look up information stored in the udev database.
enum UdevProperty is export <
    DEVLINKS
    ID_SERIAL_SHORT
>;

=head2 Grammar

#| C<TypesSubsetsGrammar> contains tokens and regexes for validating
#| C<Star::Types> subsets.
my grammar TypesSubsetsGrammar
{
    #| C<alnum-lower> matches a single lowercase alphanumeric character,
    #| or an underscore.
    token alnum-lower
    {
        <+alpha-lower +digit>
    }

    #| C<alpha-lower> matches a single lowercase alphabetic character,
    #| or an underscore.
    token alpha-lower
    {
        <+lower +[_]>
    }

    # C<device-name> matches a valid block device name.
    token device-name
    {
        # Just guessing here.
        <+alnum +[_] +[\.]> ** 1
        <+alnum +[-] +[_] +[\.]> ** 0..254
    }

    #| C<hostname> matches a valid hostname.
    #|
    #| Credit: L<https://stackoverflow.com/a/106223>
    regex hostname
    {
        ^
        [
            [
                <+:Letter +digit>
                ||
                <+:Letter +digit>
                <+:Letter +digit +[-]>*
                <+:Letter +digit>
            ]
            '.'
        ]*
        [
            <+:Letter +digit>
            ||
            <+:Letter +digit>
            <+:Letter +digit +[-]>*
            <+:Letter +digit>
        ]
        $
    }

    #| C<lvm-vg-name> matches a valid LVM volume group name.
    #|
    #| From C<man 8 lvm>, line 136 (paraphrasing):
    #|
    #| =for item1
    #| The LVM volume group name can only contain the following
    #| characters:
    #|
    #| =item2 A-Z
    #| =item2 a-z
    #| =item2 0-9
    #| =item2 +
    #| =item2 _
    #| =item2 .
    #| =item2 -
    #|
    #| =for item1
    #| The LVM volume group name can't begin with a hyphen.
    #|
    #| =for item1
    #| The LVM volume group name can't be anything that exists in C</dev>
    #| at the time of creation.
    #|
    #| =for item1
    #| The LVM volume group name can't be C<.> or C<..>.
    token lvm-vg-name
    {
        (
            <+alnum +[+] +[_] +[\.]>
            <+alnum +[+] +[_] +[\.] +[-]>*
        )
        { $0 !~~ /^^ '.' ** 1..2 $$/ or fail }
    }

    #| C<user-name> matches a valid Linux user account name.
    #|
    #| From C<man 8 useradd>, line 255 (paraphrasing):
    #|
    #| =for item
    #| The Linux user account name must be between 1 and 32 characters
    #| long.
    #|
    #| =for item
    #| The Linux user account name can't be "root".
    #|
    #| =for item
    #| The Linux user account name must start with a lowercase letter or
    #| an underscore, followed by lowercase letters, digits, underscores,
    #| or dashes.
    #|
    #| =for item
    #| The Linux user account name may end with a dollar sign ($).
    regex user-name
    {
        (
            <alpha-lower> ** 1
            <+alnum-lower +[-]> ** 0..30
            <+alnum-lower +[-] +[$]>?
        )
        { $0 ne 'root' or fail }
    }
}

=head2 Subsets

#| C<AbsolutePath> is an absolute path in C<Str> representation.
subset AbsolutePath of Str is export where .defined && .IO.is-absolute.so;

#| C<RelativePath> is a relative path in C<Str> representation.
subset RelativePath of Str is export where .defined && .IO.is-relative.so;

#| C<VaultSecretPrefix> is an absolute path (in C<Str> representation)
#| inside The Vault secret prefix where Vault secret material can reside.
subset VaultSecretPrefix of AbsolutePath is export where
{
    .IO.&rootpart eq $Star::Constants::SECRET-PREFIX-VAULT.IO;
}

#| C<BootvaultSecretPrefix> is an absolute path (in C<Str> representation)
#| inside The Bootvault secret prefix where Bootvault secret material can
#| reside.
subset BootvaultSecretPrefix of AbsolutePath is export where
{
    .IO.&rootpart eq $Star::Constants::SECRET-PREFIX-BOOTVAULT.IO;
}

#| C<DmCryptVolumePassword> is a valid password for dm-crypt encrypted
#| volumes. Password length must be between 1-512 characters.
subset DmCryptVolumePassword of Str is export where { 0 < .chars <= 512 };

#| C<DmCryptRootVolumeHeaderPath> is a type alias to C<VaultSecretPrefix>.
#| It exists to ensure the dm-crypt encrypted root volume detached header
#| resides within The Vault secret prefix.
subset DmCryptRootVolumeHeaderPath of VaultSecretPrefix is export;

#| C<DmCryptRootVolumeKeyFilePath> is a type alias to
#| C<VaultSecretPrefix>. It exists to ensure the dm-crypt encrypted root
#| volume key file - for double password entry avoidance on system
#| startup - resides within The Vault secret prefix.
subset DmCryptRootVolumeKeyFilePath of VaultSecretPrefix is export;

#| C<DmCryptBootVolumeKeyFilePath> is a type alias to
#| C<BootvaultSecretPrefix>. It exists to ensure the dm-crypt
#| encrypted boot volume key file resides within The Bootvault
#| secret prefix.
subset DmCryptBootVolumeKeyFilePath of BootvaultSecretPrefix is export;

#| C<DeviceName> is a valid device mapper name for encrypted volumes.
subset DeviceName of Str is export where
{
    TypesSubsetsGrammar.parse($_, :rule<device-name>);
}

#| C<Hostname> is a valid hostname for identification on a network.
subset Hostname of Str is export where
{
    TypesSubsetsGrammar.parse($_, :rule<hostname>);
}

#| C<Keymap> is a keymap found in C</usr/share/kbd/keymaps>.
subset Keymap of Str is export where .&is-keymap;

#| C<Locale> is a locale found in C</usr/share/i18n/locales>.
subset Locale of Str is export where .&is-locale;

#| C<LvmVolumeGroupName> is a valid LVM volume group name.
subset LvmVolumeGroupName of Str is export where
{
    TypesSubsetsGrammar.parse($_, :rule<lvm-vg-name>);
}

#| C<TimeZone> is a "Region/City" in the I<tzdb> time zone descriptions
#| file (C</usr/share/zoneinfo/zone1970.tab>), or UTC.
subset TimeZone of Str is export where .&is-time-zone;

#| C<UserName> is a valid Linux user account name.
subset UserName of Str is export where
{
    TypesSubsetsGrammar.parse($_, :rule<user-name>);
}

=head2 Helper functions

multi sub is-keymap(Str:D $ where { Utils.ls-keymaps.grep($_) } --> True) {*}
multi sub is-keymap(Str $ --> False) {*}

multi sub is-locale(Str:D $ where { Utils.ls-locales.grep($_) } --> True) {*}
multi sub is-locale(Str $ --> False) {*}

multi sub is-time-zone(Str:D $ where { Utils.ls-time-zones.grep($_) } --> True) {*}
multi sub is-time-zone(Str $ --> False) {*}

multi sub rootpart(IO:D $path where .parent eq '/'.IO --> IO:D) { $path }
multi sub rootpart(IO:D $path --> IO:D) { rootpart($path.parent) }

# vim: set filetype=raku foldmethod=marker foldlevel=0:
