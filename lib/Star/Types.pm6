use v6;
use Star::Constants;
use Star::System::Utils;
unit module Star::Types;

=head2 Enums

#| C<BootSecurityLevel> is an enum whose variants represent the different
#| boot security levels supported by Star.
#|
#| =for item1
#| C<BASE>: One or two encrypted partitions on single device, boot, root,
#| or both. When C</boot> is stored outside the root partition, it and/or
#| the root partition may be encrypted (see: C<DmCryptTarget>). When
#| C</boot> is stored inside the root partition, C</boot> is encrypted
#| alongside the rest of the system.
#|
#| =begin item1
#|
#| C<1FA>: Mostly for development purposes. Only for use with
#| C<DiskEncryption::DMCRYPT> and either C<DmCryptTarget::ROOT> or
#| C<DmCryptTarget::BOTH>.
#|
#| Two partitions on single device, one root partition, one boot
#| partition. Root partition encrypted and headerless, its header detached
#| and stored in boot partition as applicable. Boot partition may or
#| may not be encrypted.
#|
#| =end item1
#|
#| =for item1
#| C<2FA>: Implementation depends on C<DiskEncryption> mode and
#| C<DmCryptTarget>.
#|
#| =begin item2
#|
#| With C<DiskEncryption::DMCRYPT> and C<DmCryptTarget::BOOT>: An
#| external drive connected via USB port acts as the second factor.
#| C</boot> is encrypted and stored in the external drive. Alternatively,
#| a secret key stored on external hardware is used to decrypt C</boot>.
#|
#| With C<DiskEncryption::BOTH> and C<DmCryptTarget::BOOT>: Same as the
#| above, additionally decrypting the filesystem.
#|
#| With C<DiskEncryption::DMCRYPT> and either C<DmCryptTarget::ROOT>
#| or C<DmCryptTarget::BOTH>: An external drive connected via USB port
#| acts as the second factor. C</boot> is stored in the external drive
#| either encrypted or unencrypted, depending. The root volume is
#| encrypted and headerless, its header detached and stored in boot
#| partition as applicable. Alternatively, a secret key stored on
#| external hardware is used to decrypt the boot and root partitions.
#|
#| With C<DiskEncryption::BOTH> and either C<DmCryptTarget::ROOT> or
#| C<DmCryptTarget::BOTH>: Same as the above, additionally decrypting
#| the filesystem.
#|
#| With C<DiskEncryption::FILESYSTEM>: A secret key stored on external
#| hardware is used to decrypt the filesystem.
#|
#| =end item2
#|
#| C<BootSecurityLevel> is only relevant when disk encryption is used,
#| either C<DiskEncryption::DMCRYPT>, C<DiskEncryption::FILESYSTEM>, or
#| C<DiskEncryption::BOTH>.
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
#| C<DMCRYPT>: Enable disk encryption via the dm-crypt kernel crypto
#| API. Uses I<cryptsetup>. Can be used to encrypt C</boot>.
#|
#| =for item
#| C<FILESYSTEM>: Enable disk encryption via the filesystem's native
#| encryption implementation. Only available for C<Filesystem::EXT4>
#| and C<Filesystem::F2FS>. Can't be used to encrypt C</boot>.
#|
#| =for item
#| C<BOTH>: Enable disk encryption both via the dm-crypt kernel crypto
#| API and the filesystem's native encryption implementation. Only
#| available for C<Filesystem::EXT4> and C<Filesystem::F2FS>. May be used
#| to encrypt boot partition via dm-crypt while encrypting root partition
#| via the filesystem's native encryption implementation.
enum DiskEncryption is export <
    NONE
    DMCRYPT
    FILESYSTEM
    BOTH
>;

#| C<DmCryptMode> is an enum whose variants represent the different
#| dm-crypt encryption modes available.
enum DmCryptMode is export <
    LUKS1
    LUKS2
    PLAIN
>;

#| C<DmCryptTarget> is an enum whose variants represent the different
#| targets for encryption via the dm-crypt kernel crypto API.
#|
#| =for item
#| C<ROOT>: Only encrypt the root volume or partition. C</boot> will
#| be unencrypted.
#|
#| =for item
#| C<BOOT>: Only encrypt the boot partition. The root partition will
#| be unencrypted.
#|
#| =for item
#| C<BOTH>: Encrypt both the root volume or partition in addition to
#| C</boot>. C</boot> may or may not reside on a separate partition
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
#| =item C<INTEL>: Intel or integrated graphics card
#| =item C<NVIDIA>: NVIDIA dedicated/switchable graphics card
#| =item C<RADEON>: AMD/ATI Radeon dedicated/switchable graphics card
enum Graphics is export <
    INTEL
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

#| C<Processor> is an enum whose variants represent the different types
#| of x86 processors supported by Star.
#|
#| =item C<AMD>
#| =item C<INTEL>
enum Processor is export <
    AMD
    INTEL
>;

#| C<UdevProperty> is an enum whose variants represent properties by
#| which to lookup information stored in the udev database.
enum UdevProperty is export <
    DEVLINKS
    ID_SERIAL_SHORT
>;

=head2 Subsets

#| C<AbsolutePath> represents an absolute path in C<Str> representation.
subset AbsolutePath of Str is export where .defined && .IO.is-absolute.so;

#| C<RelativePath> represents a relative path in C<Str> representation.
subset RelativePath of Str is export where .defined && .IO.is-relative.so;

#| C<Hostname> is a valid hostname for identification on a network.
subset Hostname of Str is export where
{
    Star::Grammar.parse($_, :rule<hostname>);
}

#| C<Locale> represents a locale found in C</usr/share/i18n/locales>.
subset Locale of Str is export where
{
    is-locale($_);
}

#| C<LvmVolumeGroupName> is a valid LVM volume group name.
subset LvmVolumeGroupName of Str is export where
{
    Star::Grammar.parse($_, :rule<lvm-vg-name>);
}

#| C<TimeZone> represents a "Region/City" found in C</usr/share/zoneinfo>,
#| or UTC.
subset TimeZone of Str is export where
{
    is-time-zone($_);
}

#| C<UserName> is a valid Linux user account name.
subset UserName of Str is export where
{
    Star::Grammar.parse($_, :rule<user-name>);
}

#| C<VaultSecretPrefix> is an absolute path inside The Vault secret
#| prefix where Vault secret material can reside.
subset VaultSecretPrefix of AbsolutePath is export where
{
    rootpart($_.IO) eq $Star::Constants::SECRET-PREFIX-VAULT.IO;
}

#| C<BootvaultSecretPrefix> is an absolute path inside The Bootvault
#| secret prefix where Bootvault secret material can reside.
subset BootvaultSecretPrefix of AbsolutePath where
{
    rootpart($_.IO) eq $Star::Constants::SECRET-PREFIX-BOOTVAULT.IO;
}

#| C<VaultHeader> is a type alias to C<VaultSecretPrefix>. It exists to
#| ensure The Vault detached header resides within The Vault secret
#| prefix.
subset VaultHeader of VaultSecretPrefix is export;

#| C<VaultKeyFile> is a type alias to C<VaultSecretPrefix>. It exists
#| to ensure The Vault key file - for double password entry avoidance
#| on system startup - resides within The Vault secret prefix.
subset VaultKeyFile of VaultSecretPrefix is export;

#| C<BootvaultKeyFile> is a type alias to C<BootvaultSecretPrefix>. It
#| exists to ensure The Bootvault key file resides within The Bootvault
#| secret prefix.
subset BootvaultKeyFile of BootvaultSecretPrefix is export;

#| C<VaultName> is a valid device mapper name for encrypted volumes.
subset VaultName of Str is export where
{
    Star::Grammar.parse($_, :rule<vault-name>);
}

#| C<VaultPass> is a valid password for encrypted volumes. N.B. password
#| length must be between 1-512 characters.
subset VaultPass of Str is export where { 0 < .chars <= 512 };

=head2 Helper functions

multi sub is-keymap(Str:D $ where Star::System::Utils.ls-keymaps.grep($_) --> True) {*}
multi sub is-keymap(Str $ --> False) {*}

multi sub is-locale(Str:D $ where Star::System::Utils.ls-locales.grep($_) --> True) {*}
multi sub is-locale(Str $ --> False) {*}

multi sub is-time-zone(Str:D $ where Star::System::Utils.ls-time-zones.grep($_) --> True) {*}
multi sub is-time-zone(Str $ --> False) {*}

multi sub rootpart(IO:D $path where $path.parent eq '/'.IO --> IO:D) { $path }
multi sub rootpart(IO:D $path --> IO:D) { rootpart($path.parent) }

# vim: set filetype=raku foldmethod=marker foldlevel=0:
