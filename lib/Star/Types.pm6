use v6;
use Star::Constants;
unit module Star::Types;

=head2 Enums

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
#| =item C<NONE>: Disable full disk encryption
#| =item C<HALF>: Enable full disk encryption, C</boot> excepted
#| =item C<FULL>: Enable full disk encryption, C</boot> included
#|
#| N.B. C<FULL> requires selecting the GRUB bootloader. Currently,
#| no other bootloader supports booting from an encrypted C</boot>.
enum DiskEncryption is export <
    NONE
    HALF
    FULL
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

#| C<SecurityMode> is an enum whose variants represent the different
#| security modes supported by Star.
#|
#| =for item
#| C<BASE>: One encrypted partition on single device. Unencrypted boot
#| partition on same device optional (see: C<DiskEncryption>).
#|
#| =for item
#| C<1FA>: Two partitions on single device, one root partition, one boot
#| partition. Root partition encrypted and headerless, its header detached
#| and stored in boot partition as applicable. Boot partition encryption
#| optional (see: C<DiskEncryption>).
#|
#| =for item
#| C<2FA>: Root volume encrypted and headerless on unpartitioned device,
#| its header detached and stored in boot partition as applicable. Boot
#| partition on separate device. Boot partition encryption optional
#| (see: C<DiskEncryption>).
#|
#| C<SecurityMode> is only relevant when disk encryption is used. See:
#| C<DiskEncryption>.
enum SecurityMode is export <
    BASE
    1FA
    2FA
>;

#| C<UdevProperty> is an enum whose variants represent properties by
#| which to lookup information stored in the udev database.
enum UdevProperty is export <
    DEVLINKS
    ID_SERIAL_SHORT
>;

#| C<VaultType> is an enum whose variants represent the different disk
#| encryption methods available for encrypting volumes.
enum VaultType is export <
    LUKS1
    LUKS2
    PLAIN
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

#| C<LvmVolumeGroupName> is a valid LVM volume group name.
subset LvmVolumeGroupName of Str is export where
{
    Star::Grammar.parse($_, :rule<lvm-vg-name>);
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

multi sub rootpart(IO:D $path where $path.parent eq '/'.IO --> IO:D)
{
    my IO:D $rootpart = $path;
}

multi sub rootpart(IO:D $path --> IO:D)
{
    my IO:D $rootpart = rootpart($path.parent);
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
