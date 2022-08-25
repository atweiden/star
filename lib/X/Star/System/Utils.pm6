use v6;

# X::Star::System::Utils::LocaleDir {{{

#| C<X::Star::System::Utils::LocaleDir> is an exception for the case where
#| Star can't find a valid directory containing locales. Normally this
#| occurs on musl libc systems when the user neglects to fetch locales
#| with the provided script (C<scripts/fetch-locales.sh>).
class X::Star::System::Utils::LocaleDir
{
    also is Exception;

    has Str:D $.locale-dir is required;

    method message(::?CLASS:D: --> Str:D)
    {
        my Str:D $message = qq:to/EOF/.trim;
        Sorry, couldn't find locale directory at $.locale-dir

        If this machine uses the musl C standard library, be sure to build the
        locale directory by running:

            ./scripts/fetch-locales.sh

        Then, please try again
        EOF
    }
}

# end X::Star::System::Utils::LocaleDir }}}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
