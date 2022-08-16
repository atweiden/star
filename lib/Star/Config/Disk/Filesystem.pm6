use v6;
use Star::Types;

my role DiskFilesystemFormat[Filesystem:D $filesystem]
{
    method format(--> Filesystem:D) { $filesystem }
}

#| C<DiskFilesystem[Filesystem::BTRFS]> contains Btrfs-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::BTRFS]
{
    also does DiskFilesystemFormat[Filesystem::BTRFS];
}

#| C<DiskFilesystem[Filesystem::EXT2]> contains Ext2-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::EXT2]
{
    also does DiskFilesystemFormat[Filesystem::EXT2];
}

#| C<DiskFilesystem[Filesystem::EXT3]> contains Ext3-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::EXT3]
{
    also does DiskFilesystemFormat[Filesystem::EXT3];
}

#| C<DiskFilesystem[Filesystem::EXT4]> contains Ext4-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::EXT4]
{
    also does DiskFilesystemFormat[Filesystem::EXT4];
}

#| C<DiskFilesystem[Filesystem::F2FS]> contains F2FS-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::F2FS]
{
    also does DiskFilesystemFormat[Filesystem::F2FS];
}

#| C<DiskFilesystem[Filesystem::NILFS2]> contains NILFS2-specific
#| configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::NILFS2]
{
    also does DiskFilesystemFormat[Filesystem::NILFS2];
}

#| C<DiskFilesystem[Filesystem::XFS]> contains XFS-specific configuration.
my role DiskFilesystem[Filesystem:D $ where Filesystem::XFS]
{
    also does DiskFilesystemFormat[Filesystem::XFS];
}

class Star::Config::Disk::Filesystem
{
    # TODO: implement C<multi method new> here.
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
