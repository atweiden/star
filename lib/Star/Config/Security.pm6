use v6;
use Star::Types;

role Star::Config::Security[Mode:D :mode($)! where Mode::BASE]
{
    #| C<$.vault-name> is the name of The Vault.
    #|
    #| This name is used when opening The Vault, e.g.
    #|
    #|     qqx{cryptsetup luksOpen /dev/sda3 $.vault-name}
    #|
    #| It's recorded in important system settings files, such as
    #| C</etc/default/grub> (see: C<cryptdevice> on Arch, C<rd.luks.name>
    #| on Void and distros using Dracut) and C</etc/crypttab>.
    has VaultName:D $.vault-name is required;

    #| C<$.vault-pass> is the password for The Vault.
    #|
    #| This attribute is deliberately left optional. Passwords are best
    #| entered interactively via C<cryptsetup>.
    has VaultPass $.vault-pass;

    #| C<$.vault-key-file> is the path to The Vault key file stored
    #| on disk. This key is randomly generated during installation -
    #| i.e. C<head -c 64 /dev/random > key> - and serves to avoid having
    #| to enter The Vault password twice during system startup.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    #|
    #| C<$.vault-key-file> is largely a vanity feature: its sole purpose
    #| is to change on disk the path to this randomly-generated key file.
    has VaultKeyFile:D $.vault-key-file is required;

    #| C<$.vault-cipher> contains the cipher specification for The Vault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.vault-cipher is required;

    #| C<$.vault-hash> contains the passphrase hash used in the LUKS
    #| key setup scheme and The Vault key digest.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.vault-hash is required;

    #| C<$.vault-iter-time> is the time to spend in ms with PBKDF
    #| passphrase processing on The Vault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.vault-iter-time is required;

    #| C<$.vault-key-size> is the key size in bits for The Vault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.vault-key-size is required;

    #| C<$.vault-offset> is the start offset in The Vault backend device.
    #|
    #| N.B. This value must be given in human-readable format, e.g. C<5G>.
    #| This differs from the behaviour of I<cryptsetup>, which requires
    #| passing a "sector count". C<$.vault-offset> also accepts sector
    #| counts via postfix C<S>, e.g. C<10485760S>.
    #|
    #| See: C<man cryptsetup>, and C<gen-cryptsetup-luks-offset>.
    has Str $.vault-offset;

    #| C<$.vault-sector-size> is the sector size in bytes for use with
    #| The Vault.
    #|
    #| See: C<man cryptsetup>.
    has Str $.vault-sector-size;
}

role Star::Config::Security[Mode:D :mode($)! where Mode::<1FA>]
{
    also does Star::Config::Security[Mode::BASE];

    #| C<$.bootvault-name> is the name of The Bootvault.
    #|
    #| This name is used when opening The Bootvault, e.g.
    #|
    #|     qqx{cryptsetup luksOpen /dev/sda3 $.bootvault-name}
    #|
    #| It's recorded in important system settings files, such as
    #| C</etc/crypttab>.
    has VaultName:D $.bootvault-name is required;

    #| C<$.bootvault-pass> is the password for The Bootvault.
    #|
    #| This attribute is deliberately left optional. Passwords are best
    #| entered interactively via C<cryptsetup>.
    has VaultPass $.bootvault-pass;

    #| C<$.bootvault-key-file> is the path to The Bootvault key file
    #| stored on disk. This key is randomly generated during installation
    #| - i.e. C<head -c 64 /dev/random > key> - and serves to avoid
    #| having to enter The Bootvault password twice during system startup.
    #|
    #| N.B. The path must be inside of C</root> (The Bootvault secret
    #| prefix).
    #|
    #| C<$.bootvault-key-file> is largely a vanity feature: its sole
    #| purpose is to change on disk the path to this randomly-generated
    #| key file.
    has BootvaultKeyFile:D $.bootvault-key-file is required;

    #| C<$.bootvault-cipher> contains the cipher specification for
    #| The Bootvault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.bootvault-cipher is required;

    #| C<$.bootvault-hash> contains the passphrase hash used in the LUKS
    #| key setup scheme and The Bootvault key digest.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.bootvault-hash is required;

    #| C<$.bootvault-iter-time> is the time to spend in ms with PBKDF
    #| passphrase processing on The Bootvault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.bootvault-iter-time is required;

    #| C<$.bootvault-key-size> is the key size in bits for The Bootvault.
    #|
    #| See: C<man cryptsetup>.
    has Str:D $.bootvault-key-size is required;

    #| C<$.bootvault-offset> is the start offset in The Bootvault backend
    #| device.
    #|
    #| N.B. This value must be given in human-readable format, e.g. C<5G>.
    #| This differs from the behaviour of I<cryptsetup>, which requires
    #| passing a "sector count". C<$.bootvault-offset> also accepts
    #| sector counts via postfix C<S>, e.g. C<10485760S>.
    #|
    #| See: C<man cryptsetup>, and C<gen-cryptsetup-luks-offset>.
    has Str $.bootvault-offset;

    #| C<$.bootvault-sector-size> is the sector size in bytes for use with
    #| The Bootvault.
    #|
    #| See: C<man cryptsetup>.
    has Str $.bootvault-sector-size;

    #| C<$.vault-header> is the path to The Vault detached header.
    #|
    #| N.B. The path must be inside of C</boot> (The Vault secret prefix).
    has VaultHeader:D $.vault-header is required;
}

role Star::Config::Security[Mode:D :mode($)! where Mode::<2FA>]
{
    also does Star::Config::Security[Mode::<1FA>];

    #| C<$.bootvault-device> is the target block device path for The
    #| Bootvault. The Bootvault will be created on this device.
    #|
    #| N.B. This device must differ from the target block device for
    #| The Vault.
    has Str:D $.bootvault-device is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
