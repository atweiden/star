use v6;
use Star::Types;

my role Common[Filesystem:D $filesystem]
{
    method format(--> Filesystem:D) { $filesystem }
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::BTRFS]
{
    also does Common[Filesystem::BTRFS];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::EXT2]
{
    also does Common[Filesystem::EXT2];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::EXT3]
{
    also does Common[Filesystem::EXT3];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::EXT4]
{
    also does Common[Filesystem::EXT4];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::F2FS]
{
    also does Common[Filesystem::F2FS];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::NILFS2]
{
    also does Common[Filesystem::NILFS2];
}

role Star::Config::Disk::Filesystem::Format[Filesystem:D $ where Filesystem::XFS]
{
    also does Common[Filesystem::XFS];
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
