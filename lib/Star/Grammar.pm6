use v6;

#| C<Star::Grammar> contains miscellaneous tokens and regexes for
#| validating types declared in C<Star::Types>.
unit grammar Star::Grammar;

#| C<alnum-lower> matches a single lowercase alphanumeric character,
#| or an underscore.
token alnum-lower
{
    <+alpha-lower +digit>
}

#| C<alpha-lower> matches a single lowercase alphabetic character,
#| or an underscore.
token alpha-lower
{
    <+lower +[_]>
}

# C<device-name> matches a valid block device name.
token device-name
{
    # Just guessing here.
    <+alnum +[_] +[\.]> ** 1
    <+alnum +[-] +[_] +[\.]> ** 0..254
}

#| C<hostname> matches a valid hostname.
#|
#| Credit: L<https://stackoverflow.com/a/106223>
regex hostname
{
    ^
    [
        [
            <+:Letter +digit>
            ||
            <+:Letter +digit>
            <+:Letter +digit +[-]>*
            <+:Letter +digit>
        ]
        '.'
    ]*
    [
        <+:Letter +digit>
        ||
        <+:Letter +digit>
        <+:Letter +digit +[-]>*
        <+:Letter +digit>
    ]
    $
}


#| C<lvm-vg-name> matches a valid LVM volume group name.
#|
#| From C<man 8 lvm>, line 136 (paraphrasing):
#|
#| =for item1
#| The LVM volume group name can only contain the following characters:
#|
#| =item2 A-Z
#| =item2 a-z
#| =item2 0-9
#| =item2 +
#| =item2 _
#| =item2 .
#| =item2 -
#|
#| =for item1
#| The LVM volume group name can't begin with a hyphen.
#|
#| =for item1
#| The LVM volume group name can't be anything that exists in C</dev>
#| at the time of creation.
#|
#| =for item1
#| The LVM volume group name can't be C<.> or C<..>.
token lvm-vg-name
{
    (
        <+alnum +[+] +[_] +[\.]>
        <+alnum +[+] +[_] +[\.] +[-]>*
    )
    { $0 !~~ /^^ '.' ** 1..2 $$/ or fail }
}

#| C<user-name> matches a valid Linux user account name.
#|
#| From C<man 8 useradd>, line 255 (paraphrasing):
#|
#| =for item
#| The Linux user account name must be between 1 and 32 characters long.
#|
#| =for item
#| The Linux user account name can't be "root".
#|
#| =for item
#| The Linux user account name must start with a lowercase letter or an
#| underscore, followed by lowercase letters, digits, underscores, or
#| dashes.
#|
#| =for item
#| The Linux user account name may end with a dollar sign ($).
regex user-name
{
    (
        <alpha-lower> ** 1
        <+alnum-lower +[-]> ** 0..30
        <+alnum-lower +[-] +[$]>?
    )
    { $0 ne 'root' or fail }
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
