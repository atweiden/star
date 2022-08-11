use v6;
use Star::Types;
unit role Star::Config::Account;

#| C<$.user-name-admin> is the name for the system adminstrator's user
#| account.
#|
#| N.B. This user is granted elevated privileges, e.g. the ability to
#| C<suid> to root.
has UserName:D $.user-name-admin is required;

#| C<$.user-pass-hash-admin> is the SHA512 password hash for the system
#| administrator's user account.
has Str:D $.user-pass-hash-admin is required;

#| C<$.user-name-guest> is the name for the guest's user account. This
#| user is given very limited privileges.
has UserName:D $.user-name-guest is required;

#| C<$.user-pass-hash-guest> is the SHA512 password hash for the guest's
#| user account.
has Str:D $.user-pass-hash-guest is required;

#| C<$.user-name-sftp> is the name for the "SFTP user". The SFTP user
#| account exists for the sole purpose of handling SFTP authentication
#| and remote file transfer. This user is locked down and given very
#| limited privileges.
has UserName:D $.user-name-sftp is required;

#| C<$.user-pass-hash-sftp> is the SHA512 password hash for the SFTP user.
has Str:D $.user-pass-hash-sftp is required;

#| C<$.user-pass-hash-root> is the SHA512 password hash for root.
has Str:D $.user-pass-hash-root is required;

#| C<$.user-name-grub> is the name for the "GRUB superuser". This isn't
#| a real system user account. C<$.user-name-grub> is an arbitrary name
#| used for the sole purpose of GRUB authentication. During system
#| startup, after successful authentication, this "user" can edit GRUB
#| menu entries or access the GRUB command console.
has UserName:D $.user-name-grub is required;

#| C<$.user-pass-hash-grub> is the PBKDF2 password hash for the "GRUB
#| superuser".
has Str:D $.user-pass-hash-grub is required;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
