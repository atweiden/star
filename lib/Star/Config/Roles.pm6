use v6;
use Star::Types;

#| C<Star::Config::Roles::GetOpts> provides method C<get-opts> for
#| returning a C<Hash> of attributes.
role Star::Config::Roles::GetOpts
{
    method get-opts(::?CLASS:D: --> Hash:D)
    {
        my List:D $attributes = self.^attributes(:local);
        # Assign self to dynamic variable. Enables passing C<self> to
        # method C<Attribute.get_value> in subroutine.
        my $*self = self;
        my %opts = get-opts(:$attributes);
    }

    multi sub get-opts(List:D :$attributes! --> Hash:D)
    {
        my Pair:D @opt = $attributes.map(-> Attribute:D $attribute {
            get-opts(:$attribute);
        });
        my %opts = @opt.hash;
    }

    multi sub get-opts(Attribute:D :$attribute! --> Pair:D)
    {
        my Str:D $name = $attribute.name.substr(2);
        my \value = $attribute.get_value($*self);
        get-opts($name, value);
    }

    multi sub get-opts(Str:D $name, \value --> Pair:D)
    {
        my Pair:D $name-value = $name => value;
    }
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
