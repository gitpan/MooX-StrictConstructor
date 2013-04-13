## no critic (RequireUseStrict, RequireUseWarnings)
package Method::Generate::Constructor::Role::StrictConstructor;
{
  $Method::Generate::Constructor::Role::StrictConstructor::VERSION = '0.002';
}
## critic;

# ABSTRACT: a role to make Moo constructors strict.


use Moo::Role;
use B ();

around _assign_new => sub {
    my $orig = shift;
    my $self = shift;
    my $spec = $_[0];

    my @attrs = map { B::perlstring($_) . ' => 1,' }
        grep {defined}
        map  { $_->{init_arg} }    ## no critic (ProhibitAccessOfPrivateData)
        values(%$spec);

    my $body .= <<"EOF";

    # MooX::StrictConstructor
    my \%attrs = (@attrs);
    my \@bad = sort grep { ! \$attrs{\$_} }  keys \%{ \$args };
    if (\@bad) {
       die("Found unknown attribute(s) passed to the constructor: " .
           join ", ", \@bad);
    }

EOF

    $body .= $self->$orig(@_);

    return $body;
};


1;

__END__

=pod

=head1 NAME

Method::Generate::Constructor::Role::StrictConstructor - a role to make Moo constructors strict.

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This role wraps L<Method::Generate::Constructor/_assign_new> with a bit of code
that ensures that all arguments passed to the constructor are valid init_args
for the class.

=head2 STANDING ON THE SHOULDERS OF ...

This code would not exist without the examples in L<MooX::InsideOut> and
L<MooseX::StrictConstructor>.

=head1 SEE ALSO

=over 4

=item *

L<MooX::InsideOut>

=item *

L<MooseX::StrictConstructor>

=back

=head1 AUTHOR

George Hartzell <hartzell@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by George Hartzell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
