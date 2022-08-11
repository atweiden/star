use v6;
use Star::Config::Account
use Star::Config::Disk;
use Star::Config::Distro;
use Star::Config::Installer;
use Star::Config::Security;
use Star::Config::Software;
use Star::Config::System;
use Star::Types;

role Star::Config[Distro:D :$distro!, Mode:D :$mode!, List:D :$filesystem!]
{
    has Star::Config::Account:D $.account is required;
    has Star::Config::Disk[:$mode, :$filesystem] $.disk is required;
    has Star::Config::Distro[:$distro] $.distro is required;
    has Star::Config::Installer $.installer is required;
    has Star::Config::Security[:$mode] $.security is required;
    has Star::Config::Software[:$distro] $.software is required;
    has Star::Config::System $.system is required;
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
