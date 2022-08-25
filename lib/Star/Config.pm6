use v6;
use Star::Config::Account;
use Star::Config::Disk;
use Star::Config::Distro;
use Star::Config::Installer;
use Star::Config::Security;
use Star::Config::Software;
use Star::Config::System;
use Star::Types;
unit class Star::Config;

has Star::Config::Account:D $.account is required;
has Star::Config::Disk:D $.disk is required;
has Star::Config::Distro:D $.distro is required;
has Star::Config::Installer:D $.installer is required;
has Star::Config::Security:D $.security is required;
has Star::Config::Software:D $.software is required;
has Star::Config::System:D $.system is required;

method new(--> Star::Config:D)
{
    my Star::Config::Account:D $account = new-account();
    my Star::Config::Disk:D $disk = new-disk();
    my Star::Config::Distro:D $distro = new-distro();
    my Star::Config::Installer:D $installer = new-installer();
    my Star::Config::Security:D $security = new-security();
    my Star::Config::Software:D $software = new-software();
    my Star::Config::System:D $system = new-system();
}

sub new-account(--> Star::Config::Account:D)
{
    my UserName:D $user-name-admin = 'admin-name';
    my Str:D $user-pass-hash-admin = 'admin-pass-hash';
    my UserName:D $user-name-guest = 'guest-name';
    my Str:D $user-pass-hash-guest = 'guest-pass-hash';
    my UserName:D $user-name-sftp = 'sftp-name';
    my Str:D $user-pass-hash-sftp = 'sftp-pass-hash';
    my Str:D $user-pass-hash-root = 'root-pass-hash';
    my UserName:D $user-name-grub = 'grub-name';
    my Str:D $user-pass-hash-grub = 'grub-pass-hash';
    my Star::Config::Account $account .= new(
        :$user-name-admin,
        :$user-pass-hash-admin,
        :$user-name-guest,
        :$user-pass-hash-guest,
        :$user-name-sftp,
        :$user-pass-hash-sftp,
        :$user-pass-hash-root,
        :$user-name-grub,
        :$user-pass-hash-grub
    );
}

sub new-disk(--> Star::Config::Disk:D)
{
    my Star::Config::Disk::Root::Opts:D $r = do {
        my Str:D $device = '/dev/sda';
        my Star::Config::Disk::Filesystem $filesystem .= new(Filesystem::BTRFS);
        my LvmOnRoot:D $lvm-on = LvmOnRoot::NO;
        Star::Config::Disk::Root::Opts[$lvm-on].new(:$device, :$filesystem);
    };
    my DiskEncryption:D $disk-encryption = DiskEncryption::DM-CRYPT;
    my DmCryptTarget:D $dm-crypt-target = DmCryptTarget::BOTH;
    Star::Config::Disk.new($r, $disk-encryption, $dm-crypt-target);
}

sub new-distro(--> Star::Config::Distro:D)
{
    my Distro:D $distro = Distro::VOID;
    my Str:D @repository;
    my Bool:D $ignore-conf-repos = False;
    Star::Config::Distro[$distro].new(:@repository, :$ignore-conf-repos);
}

sub new-installer(--> Star::Config::Installer:D)
{
    my AbsolutePath:D $chroot-dir = '/mnt';
    my Bool:D $augment = False;
    Star::Config::Installer.new(:$chroot-dir, :$augment);
}

sub new-security(--> Star::Config::Security:D)
{
    my DiskEncryption:D $disk-encryption = DiskEncryption::DM-CRYPT;
    my DmCryptTarget:D $dm-crypt-target = DmCryptTarget::BOTH;
    my Star::Config::Security::DmCrypt::Root::Opts:D $r = do {
        my BootSecurityLevel:D $boot-security-level = BootSecurityLevel::BASE;
        my DmCryptMode:D $mode = 'LUKS1';
        my DeviceName:D $name = 'vault';
        my DmCryptRootVolumeKeyFile:D $key-file = '/boot/keys/root.key';
        my Str:D $cipher = 'cipher';
        my Str:D $hash = 'hash';
        my Str:D $iter-time = 'iter-time';
        my Str:D $key-size = 'key-size';
        Star::Config::Security::DmCrypt::Root::Opts[$boot-security-level].new(
            $mode,
            $name,
            $key-file,
            $cipher,
            $hash,
            $iter-time,
            $key-size
        );
    };
    Star::Config::Security.new($disk-encryption, $dm-crypt-target, $r);
}

sub new-software(--> Star::Config::Software:D)
{
    my Distro:D $distro = Distro::VOID;
    my Str:D $kernel = 'linux';
    my Str:D @package;
    Star::Config::Software[$distro].new(:$kernel, :@package);
}

sub new-system(--> Star::Config::System:D)
{
    my DriveType:D $drive-type = DriveType::SSD;
    my Graphics:D $graphics = Graphics::INTEGRATED;
    my Hostname:D $hostname = 'vault';
    my Keymap:D $keymap = 'us';
    my Locale:D $locale = 'en_US';
    my Processor:D $processor = Processor::INTEL;
    my TimeZone:D $time-zone = 'Antarctica/South_Pole';
    my Bool:D $disable-ipv6  = False;
    my Bool:D $enable-classic-ifnames  = False;
    my Bool:D $enable-serial-console = False;
    Star::Config::Software[$distro].new(:$kernel, :@package);
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
