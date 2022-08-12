use v6;
use Star::Types;
unit role Star::Config::System;

#| C<$.drive-type> is the type of hard drive, e.g. SSD or HDD.
has DriveType:D $.drive-type is required;

#| C<$.graphics> is the type of graphics card, e.g. NVIDIA or Radeon.
has Graphics:D $.graphics is required;

#| C<$.hostname> is the hostname.
has Hostname:D $.hostname is required;

#| C<$.keymap> is the keyboard mapping, e.g. "us".
has Keymap:D $.keymap is required;

#| C<$.locale> is the locale, e.g. "en_US".
has Locale:D $.locale is required;

#| C<$.processor> is the type of CPU, e.g. Intel or AMD.
has Processor:D $.processor is required;

#| C<$.time-zone> is the local time zone, i.e. "Region/City".
has TimeZone:D $.time-zone is required;

#| C<$.disable-ipv6> indicates whether to disable IPv6. Set this to
#| C<True> to disable IPv6 via the kernel command line, and to disable
#| IPv6 functionality in relevant software.
has Bool:D $.disable-ipv6 is required;

#| C<$.enable-classic-ifnames> indicates whether to enable the classic
#| naming scheme for network interfaces, e.g. C<eth0>, C<eth1>, C<wlan0>.
has Bool:D $.enable-classic-ifnames is required;

#| C<$.enable-serial-console> indicates whether to enable a serial console
#| on C<ttyS0> with baud rate 115200.
has Bool:D $.enable-serial-console is required;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
