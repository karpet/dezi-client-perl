package Dezi::Response;
use strict;
use warnings;

our $VERSION = '0.001000';

use Carp;
use JSON;

# TODO expose all attributes?
use Class::XSAccessor { accessors =>
        [qw( results total search_time build_time query fields facets )], };

use Dezi::Doc;

sub new {
    my $class     = shift;
    my $http_resp = shift or croak "HTTP::Response required";
    my $json      = from_json( $http_resp->decoded_content );
    my @res;
    for my $r ( @{ $json->{results} } ) {
        push @res, Dezi::Doc->new(%$r);
    }

    # overwrite with objects
    $json->{results} = \@res;
    return bless $json, $class;
}

1;

__END__

=head1 AUTHOR

Peter Karman, C<< <karman at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dezi-client at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dezi-Client>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dezi::Client


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dezi-Client>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dezi-Client>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dezi-Client>

=item * Search CPAN

L<http://search.cpan.org/dist/Dezi-Client/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 Peter Karman.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
