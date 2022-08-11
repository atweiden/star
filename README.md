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

Pre-select Void, full disk encryption (including encrypted `/boot`)
with headerless root volume on unpartitioned device its header detached
and stored in encrypted boot volume on separate device, root partition
formatted NILFS2 (on LVM), boot partition formatted ext2.

```bash
star new void vault 2fa nilfs2/ext2+lvm
```

Pre-select Arch, full disk encryption (excepting `/boot`) with headerless
root volume on unpartitioned device its header detached and stored in
unencrypted boot partition on separate device, root partition formatted
ext4 (no LVM), boot partition formatted ext4.

```bash
star new arch vault half 2fa ext4
```

Pre-select Arch, full disk encryption (excepting `/boot`), root partition
formatted xfs (on LVM), boot partition formatted xfs.

```bash
star new arch vault half xfs+lvm
```

Pre-select Alpine, root partition formatted btrfs (no LVM), boot partition
formatted ext4.

```bash
star new alpine btrfs
```
