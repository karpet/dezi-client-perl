package Dezi::Client;

use warnings;
use strict;

our $VERSION = '0.001000';

use Carp;
use LWP::UserAgent;
use JSON;

=head1 NAME

Dezi::Client - interact with a Dezi server

=head1 SYNOPSIS

 use Dezi::Client;
 
 # open a connection
 my $client = Dezi::Client->new(
    server  => 'http://localhost:5000',
 );
 
 # add/update a filesystem document to the index
 $client->index( file => 'path/to/file.html' );
 
 # add/update an in-memory document to the index
 $client->index( buf => \$html_doc, uri => 'foo/bar.html' );
 
 # add/update a Dezi::Doc to the index
 $client->index( doc => $dezi_doc );
 
 # remove a document from the index
 $client->delete( uri => '/doc/uri/relative/to/index' );
 
 # search the index
 my $response = $client->search( q => 'foo' );
 
 # iterate over results
 for my $result (@{ $response->results }) {
     printf("--\n uri: %s\n title: %s\n score: %s\n",
        $result->uri, $result->title, $result->score);
 }
 
 # print stats
 printf("       hits: %d\n", $response->count);
 printf("search time: %s\n", $response->search_time);
 printf(" build time: %s\n", $response->build_time);
 printf("      query: %s\n", $response->query);
 
 
=head1 DESCRIPTION

Dezi::Client is a client for the Dezi search platform.

=head1 METHODS

=head2 new( I<params> )

Instantiate a Client instance. Expects the following params:

=over

=item server I<url>

The I<url> of the Dezi server. If the B<search> or B<index>
params are not passed to new(), then the server will be
interrogated at initial connect for the correct paths
for searching and indexing.

=item search I<path>

The URI path for searching. Dezi defaults to B</search>.

=item index I<path>

The URI path for indexing. Dezi defaults to B</index>.

=back

=cut

sub new {
    my $class = shift;
    my %args  = @_;
    if ( !%args or !exists $args{server} ) {
        croak "server param required";
    }
    my $self = bless { server => delete $args{server} }, $class;
    $self->{ua} = LWP::UserAgent->new();
    if ( $args{search} and $args{index} ) {
        $self->{search_uri} = $self->{server} . delete $args{search};
        $self->{index_uri}  = $self->{server} . delete $args{index};
    }
    else {
        my $resp  = $self->{ua}->get( $self->{server} );
        my $paths = from_json( $resp->decoded_content );
        if (   !$resp->is_success
            or !$paths
            or !$paths->{search}
            or !$paths->{index} )
        {
            croak "Bad response from server $self->{server}: "
                . $resp->status_line . " "
                . $resp->decoded_content;
        }
        $self->{search_uri} = $paths->{search};
        $self->{index_uri}  = $paths->{index};
    }

    if (%args) {
        croak "Invalid params to new(): " . join( ", ", keys %args );
    }

    return $self;
}

=head2 index( I<params> )

Add or update a document. I<params> should be a key/value pair
where the key is one of:

=over

=item file I<path>

I<path> should be a readable file on an accessible filesystem.
I<path> will be read with File::Slurp.

=item buf I<scalar_ref>

I<scalar_ref> should be a reference to a string representing
the document to be indexed.

=item doc I<dezi_doc>

I<dezi_doc> should be a Dezi::Doc object.

=back

Returns a HTTP::Response object which can be interrogated to
determine the result. Example:

 my $resp = $client->index( file => 'path/to/foo.html' );
 if (!$resp->is_success) {
    die "Failed to add path/to/foo.html to the Dezi index!";
 }

=cut

sub index {

}

=head2 search( I<params> )

Fetch search results from a Dezi server. I<params> can be
any key/value pair as described in Search::OpenSearch. The only
required key is B<q> for the query string.

Returns a Dezi::Client::Response object.

=cut

sub search {

}

=head2 delete( I<params> )

Remove a document from the server. I<params> must include a key/value
pair of B<uri> and the document's I<uri>.

=cut

sub delete {

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
