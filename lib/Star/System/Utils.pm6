use v6;
use Star::Constants;

#| C<Star::Distro::Utils> is a class whose methods are designed for
#| cross-distro, untyped interactions with third-party software pertaining
#| to system settings, e.g. keymaps, locales, and time zones.
unit class Star::System::Utils;

#| C<ls> returns an C<Array> of files in the directory at C<$path>,
#| in C<Str> representation.
#|
#| Pass optional C<Bool> C<:recursive> to recursively list directory.
multi sub ls(
    Str:D $path where .IO.d.so,
    Bool:D :recursive($)! where .so
    --> Array[Str:D]
)
{
    my Str:D @path = do {
        my Str:D @path = ls($path);
        ls-r(@path);
    };
}

multi sub ls(
    Str:D $path where .IO.d.so,
    Bool :recursive($)
    --> Array[Str:D]
)
{
    my Str:D @path = dir($path).race.map({ .Str });
}

multi sub ls-r(Str:D @p --> Array[Str:D])
{
    my Str:D @path = @p.race.map(-> Str:D $path { ls-r($path) }).flat;
}

multi sub ls-r(Str:D $path where .IO.d.so --> Array[Str:D])
{
    my Str:D @path = ls($path, :recursive);
}

multi sub ls-r(Str:D $path where .IO.f.so --> Str:D)
{
    $path;
}

#| C<ls-keymaps> returns an C<Array> of keymaps installed, in C<Str>
#| representation.
method ls-keymaps(--> Array[Str:D])
{
    # Equivalent to C<localectl list-keymaps --no-pager>.
    #
    # See: C<src/basic/def.h> in I<systemd> source code
    state Str:D @keymap = do {
        my Str:D @path =
            # Filter out the C</usr/share/kbd/keymaps/include> directory.
            ls($Star::Constants::DIRECTORY-KEYMAPS).grep(none 'include');
        ls-r(@path)
            .grep(/'.map.gz'$/);
            .map({ .split('/').tail.split('.').first })
            .sort;
    };
}

#| C<ls-locales> returns a list of locales installed, in C<Str>
#| representation.
method ls-locales(--> Array[Str:D])
{
    state Str:D @locale = ls-locales($Star::Constants::DIRECTORY-LOCALES);
}

multi sub ls-locales(
    # Avoid raising an exception on musl libc systems, where locales
    # are always absent.
    Str:D $locale-dir where .IO.e.so && .IO.d.so
    --> Array[Str:D]
)
{
    my Str:D @locale = ls($locale-dir).map({ .split('/').tail }).sort;
}

multi sub ls-locales(
    Str:D $locale-dir
    --> Array[Str:D]
)
{
    my Str:D @locale;
}

#| C<ls-time-zones> returns a list of valid time zones, in C<Str>
#| representation.
method ls-time-zones(--> Array[Str:D])
{
    # Equivalent to C<timedatectl list-timezones --no-pager>.
    #
    # See: C<src/basic/time-util.c> in I<systemd> source code.
    state Str:D @time-zone = do {
        my Str:D @time-zone =
            $Star::Constants::FILE-TIME-ZONES
                .IO.lines
                .race
                .grep(/^\w.*/)
                .map({ .split(/\h+/)[2] })
                .sort;
        push(@time-zone, 'UTC');
        @time-zone;
    };
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
