use v6;

#| C<Star::Constants> encapsulates constants common to multiple distros.
unit module Star::Constants;

=head2 Constants for installer

    #| C<$SECRET-PREFIX-VAULT> is the directory in which Vault key files
    #| and detached headers are stored.
    constant $SECRET-PREFIX-VAULT = '/boot';

    #| C<$SECRET-PREFIX-BOOTVAULT> is the directory in which Bootvault
    #| key files are stored, for use with C<SecurityMode::1FA> and
    #| C<SecurityMode::2FA>.
    constant $SECRET-PREFIX-BOOTVAULT = '/root';

    #| C<$DIRECTORY-EFI> is the mounting point of the EFI System
    #| Partition.
    constant $DIRECTORY-EFI = '/boot/efi';

=head2 Constants for I<libcrypt>

    #| C<$CRYPT-ROUNDS> is the number of libcrypt crypt encryption rounds.
    constant $CRYPT-ROUNDS = 2_097_152;
    #= (2**21)

    #| C<$CRYPT-SCHEME> is the libcrypt crypt encryption scheme.
    constant $CRYPT-SCHEME = 'SHA512';

=head2 Constants for C<grub-mkpasswd-pbkdf2>

    #| C<$PBKDF2-ITERATIONS> is the number of PBKDF2 iterations for GRUB
    #| hashed password generation via C<grub-mkpasswd-pbkdf2>.
    #|
    #| See: C<man grub-mkpasswd-pbkdf2>.
    constant $PBKDF2-ITERATIONS = 25_000;

    #| C<$PBKDF2-LENGTH-HASH> is the length of the GRUB hashed password
    #| generated by C<grub-mkpasswd-pbkdf2>.
    #|
    #| See: C<man grub-mkpasswd-pbkdf2>.
    constant $PBKDF2-LENGTH-HASH = 100;

    #| C<$PBKDF2-LENGTH-SALT> is the length of the salt for GRUB hashed
    #| password generation via C<grub-mkpasswd-pbkdf2>.
    #|
    #| See: C<man grub-mkpasswd-pbkdf2>.
    constant $PBKDF2-LENGTH-SALT = 100;

=head2 Constants for I<gdisk>

    #| C<$GDISK-SIZE-BIOS> is the size of the BIOS Boot Partition.
    constant $GDISK-SIZE-BIOS = '2M';

    #| C<$GDISK-SIZE-EFI> is the size of the EFI System Partition.
    constant $GDISK-SIZE-EFI = '550M';

    #| C<$GDISK-SIZE-BOOT> is the size of the C</boot> partition, for
    #| use with C<SecurityMode::1FA> and C<SecurityMode::2FA>.
    constant $GDISK-SIZE-BOOT = '1024M';

    #| C<$GDISK-TYPECODE-BIOS> is the gdisk internal code for the BIOS
    #| Boot Partition.
    constant $GDISK-TYPECODE-BIOS = 'EF02';

    #| C<$GDISK-TYPECODE-EFI> is the gdisk internal code for the EFI
    #| System Partition.
    constant $GDISK-TYPECODE-EFI = 'EF00';

    #| C<$GDISK-TYPECODE-LINUX> is the gdisk internal code for Linux
    #| filesystem.
    constant $GDISK-TYPECODE-LINUX = '8300';

=head2 Constants for I<cryptsetup>

    #| C<$CRYPTSETUP-LUKS-BYTES-PER-SECTOR> is the number of bytes
    #| per cryptsetup "sector", for use with C<--vault-offset> and
    #| C<--bootvault-offset>.
    constant $CRYPTSETUP-LUKS-BYTES-PER-SECTOR = 512;

=head2 Constants for C<--enable-serial-console>

    #| C<$CONSOLE-VIRTUAL> is the foreground virtual console device.
    constant $CONSOLE-VIRTUAL = 'tty0';

    #| C<$CONSOLE-SERIAL> is the serial port device.
    constant $CONSOLE-SERIAL = 'ttyS0';

    #| C<$GRUB-SERIAL-PORT-UNIT> is the serial unit.
    constant $GRUB-SERIAL-PORT-UNIT = '0';

    #| C<$GRUB-SERIAL-PORT-BAUD-RATE> is the serial port speed.
    constant $GRUB-SERIAL-PORT-BAUD-RATE = '115200';

    #| C<$GRUB-SERIAL-PORT-PARITY> is the serial port parity.
    constant $GRUB-SERIAL-PORT-PARITY = False;

    #| C<%GRUB-SERIAL-PORT-PARITY> maps a C<Bool> representing the serial
    #| port parity to the C<Str> representation of such in GRUB settings.
    constant %GRUB-SERIAL-PORT-PARITY =
        ::(True) => %(
            GRUB_SERIAL_COMMAND => 'odd',
            GRUB_CMDLINE_LINUX_DEFAULT => 'o'
        ),
        ::(False) => %(
            GRUB_SERIAL_COMMAND => 'no',
            GRUB_CMDLINE_LINUX_DEFAULT => 'n'
        );

    #| C<$GRUB-SERIAL-PORT-STOP-BITS> is the serial port stop bits.
    constant $GRUB-SERIAL-PORT-STOP-BITS = '1';

    #| C<$GRUB-SERIAL-PORT-WORD-LENGTH-BITS> is the serial port word
    #| length.
    constant $GRUB-SERIAL-PORT-WORD-LENGTH-BITS = '8';

# vim: set filetype=raku foldmethod=marker foldlevel=0:
