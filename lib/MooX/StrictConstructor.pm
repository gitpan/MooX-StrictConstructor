package MooX::StrictConstructor;

# ABSTRACT: Make your Moo-based object constructors blow up on unknown attributes.


use strictures 1;

use Moo 1.001000 ();    # $Moo::MAKERS support
use Moo::Role ();
use Class::Method::Modifiers qw(install_modifier);

use constant
    CON_ROLE => 'Method::Generate::Constructor::Role::StrictConstructor';
{
  $MooX::StrictConstructor::VERSION = '0.006';
}

#
# The gist of this code was copied directly from Graham Knop (HAARG)'s
# MooX::InsideOut, specifically its import sub.  It has diverged a bit to
# handle goal specific differences.
#
sub import {
    my $class  = shift;
    my $target = caller;
    unless ( $Moo::MAKERS{$target} && $Moo::MAKERS{$target}{is_class} ) {
        die "MooX::StrictConstructor can only be used on Moo classes.";
    }

    _apply_role($target);

    install_modifier($target, 'after', 'extends', sub {
        _apply_role($target);
    });
}

sub _apply_role {
    my $target = shift;
    my $con = Moo->_constructor_maker_for($target);
    Moo::Role->apply_roles_to_object($con, CON_ROLE)
        unless Role::Tiny::does_role($con, CON_ROLE);
}


1;

__END__

=pod

=head1 NAME

MooX::StrictConstructor - Make your Moo-based object constructors blow up on unknown attributes.

=head1 VERSION

version 0.006

=head1 SYNOPSIS

    package My::Class;

    use Moo;
    use Moo::StrictConstructor;

    has 'size' => ( is => 'rw');

    # then somewhere else, when constructing a new instance
    # of My::Class ...

    # this blows up because color is not a known attribute
    My::Class->new( size => 5, color => 'blue' );

=head1 DESCRIPTION

Simply loading this module makes your constructors "strict". If your
constructor is called with an attribute init argument that your class does not
declare, then it dies. This is a great way to catch small typos.

=head2 STANDING ON THE SHOULDERS OF ...

Most of this package was lifted from L<MooX::InsideOut> and most of the Role
that implements the strictness was lifted from L<MooseX::StrictConstructor>.

=head2 SUBVERTING STRICTNESS

L<MooseX::StrictConstructor> documents two tricks for subverting strictness and
avoid having problematic arguments cause an exception: handling them in BUILD
or handle them in BUILDARGS.

In L<MooX::StrictConstructor> you can use a BUILDARGS function to handle them,
e.g. this will allow you to pass in a parameter called "spy" without raising an
exception.  Useful?  Only you can tell.

   sub BUILDARGS {
       my ($self, %params) = @_;
       my $spy delete $params{spy};
       # do something useful with the spy param
       return \%params;
   }

Because C<BUILD> methods are run after an object has been constructed and this
code runs before the object is constructed the C<BUILD> trick will not work.

=head1 BUGS

=over 4

=item Inheritance

A class that uses L<MooX::StrictConstructor> but extends another class that
does not will not be handled properly.  This code hooks into the constructor
as it is being strung up (literally) and that happens in the parent class,
not the one using strict.

=item Subverting strictness

L<MooseX::StrictConstructor> documents a trick
for subverting strictness using BUILD.  This does not work here because
strictness is enforced in the early stage of object construction but the
BUILD subs are run after the objects has been built.

=back

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
