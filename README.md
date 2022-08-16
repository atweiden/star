Star
====

Polyglot Linux installer (WIP)

Synopsis
--------

Launch TUI. Choose distro for installation, along with disk encryption,
security level, filesystem, and more.

```bash
star new
```

Same as the above, but with Alpine pre-selected.

```bash
star new alpine
```

Pre-select Alpine, root partition formatted Ext4 `/boot` included.

```bash
star new alpine ext4
```

Pre-select Alpine, LVM on dm-crypt full disk encryption (including
encrypted `/boot`), root volume LVM logical volumes formatted Ext4.

```bash
# --disk-encryption and --dm-crypt-target default to "dm-crypt" and "both", respectively
star --disk-encryption=dm-crypt --dm-crypt-target=both new alpine vault ext4+lvm
# or, equivalently:
star new alpine vault ext4+lvm
```

Pre-select Arch, LVM on dm-crypt full disk encryption (including encrypted
`/boot`), root volume LVM logical volumes excepting `/boot` formatted
Ext4, `/boot` LVM logical volume formatted Ext2.

```bash
star new arch vault ext4/ext2+lvm
```

Pre-select Arch, dm-crypt full disk encryption (including encrypted
`/boot`), root volume formatted Btrfs.

```bash
star new arch vault btrfs
```

Pre-select Arch, LVM on dm-crypt full disk encryption (including encrypted
`/boot`) with headerless root volume on unpartitioned device its header
detached and stored in encrypted boot volume on separate device, root
volume LVM logical volumes formatted NILFS2, boot volume formatted Ext2.

```bash
star new arch vault 2fa nilfs2/ext2+lvm
```

Pre-select Void, dm-crypt full disk encryption (excepting `/boot`) with
headerless root volume on unpartitioned device its header detached and
stored in unencrypted boot partition on separate device, root volume
formatted Ext4, boot partition formatted Ext4.

```bash
# pass --dm-crypt-target=root to omit /boot encryption
star --dm-crypt-target=root new void vault 2fa ext4
```

Pre-select Void, hybrid fscrypt/dm-crypt full disk encryption (including
encrypted `/boot`), fscrypt on root partition formatted Ext4, dm-crypt
boot volume formatted Ext4.

```bash
star --disk-encryption=both --dm-crypt-target=boot new void vault ext4
```

Pre-select Void, fscrypt full disk encryption (excepting `/boot`), fscrypt
on root partition formatted F2FS, unencrypted boot partition formatted
F2FS.

```bash
star --disk-encryption=filesystem new void vault f2fs
```

Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.
