package Jundy;

use 5.006;
use strict;
use warnings;

our $VERSION = '1.10';

sub new
{

  my $self;
  if (${^TAINT}) { # 1: Taint mode; -1: warning Taint mode
    my $package = shift;
		$package = $1 if $package =~ /^([a-z:]+)$/i;
    my $class = ref($package) || $package;

    $self = {};
    bless($self, $class);
    $self->initialize({@_});
  }
  else {
    my $package = shift;
    my $class = ref($package) || $package;

    $self = {@_};
    bless($self, $class);
    $self->initialize;
  }


  return $self;

} # END: new

sub initialize {
}

sub create_accessor
{

  my $self = shift;

  # From "Programming Perl" 3rd Ed. p338.
  for my $attribute (@_)
  {

    no strict "refs"; # So symbolic ref to typeglob works.
    no warnings;      # Suppress "subroutine redefined" warning.

    *$attribute = sub
    {

      my $self = shift;

      $self->{$attribute} = shift if @_;
      return $self->{$attribute};

    };

  }

} # END: create_accessor

1;
__END__

=head1 NAME

Jundy - Base Class for all other Jundy modules.

=head1 DESCRIPTION

Jundy provides the bare minimum that all other classes are built upon.
It is designed soly for use in other modules and not intended to be used 
directly in a program - where program is a collection of code that is not an
object.

Jundy provides 3 functions:

=over

=item *

new()

=over

This function blesses the object and then it calls initialize().

If it determines that Taint mode is on (either fully or in warn mode) then it
will not simply make the passed data the central data structure, but create an
empyt one, passing the tainted data to initialize.  This way the object
shouldn't be tainted (if you've cleaned your data correctly).

=back

=item *

initialize()

=over

This function does nothing.  It is here because new() calls it.  You should
overwrite this function with "initializing" code for your object and (probably)
call create_accessor();

=back

=item *

create_accessor()

=over

This function accepts an array of strings.  Foreach string in the passed array
create_accessor() creates an accessor method - go figure! - for that string.  So it is
important that the strings that you provide are actually class varaibles that need accessor methods.


Each accessor then accepts 0 or 1 argument.  If an argument is provided then
the class variable will be set to the provided agrument.  The accessor method returns the current value of the class variable - no matter if an argument was provided or not.

=back

=back

=head1 AUTHOR

Erik Tank, E<lt>tank@jundy.comE<gt>

=head2 CONTRIBUTORS

Doug Miles

=head1 COPYRIGHT

Copyright (C) 2002-2013, Erik R. Tank.  All Rights Reserved.
This module is free software. It may be used, redis-
tributed and/or modified under the terms of the Perl
Artistic License (see http://www.perl.com/perl/misc/Artis-
tic.html)

=cut
