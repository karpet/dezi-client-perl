#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 14;

use_ok('Dezi::Client');
use_ok('Dezi::Doc');

SKIP: {

    diag("set DEZI_URL to test Dezi::Client") unless $ENV{DEZI_URL};
    skip "set DEZI_URL to test Dezi::Client", 13 unless $ENV{DEZI_URL};

    # open a connection
    ok( my $client = Dezi::Client->new( server => $ENV{DEZI_URL}, ),
        "new client" );

    # add/update a filesystem document to the index
    ok( $client->index( file => 't/test.html' ), "index t/test.html" );

    # add/update an in-memory document to the index
    my $html_doc
        = qq(<html><title>hello world</title><body>foo bar</body></html>);
    ok( $client->index( buf => \$html_doc, uri => 'foo/bar.html' ),
        "index \$html_doc" );

    # add/update a Dezi::Doc to the index
    my $dezi_doc = Dezi::Doc->new( uri => 't/test-dezi-doc.html' );
    ok( $client->index( doc => $dezi_doc ), "index Dezi::Doc" );

    # remove a document from the index

    ok( $client->delete( uri => 'foo/bar.html' ), "delete foo/bar.html" );

    # search the index
    ok( my $response = $client->search( q => 'foo' ), "search" );

    # iterate over results
    for my $result ( @{ $response->results } ) {
        ok( $result->uri, "get result uri" );
        diag(
            sprintf(
                "--\n uri: %s\n title: %s\n score: %s\n",
                $result->uri, $result->title, $result->score
            )
        );
    }

    # print stats
    is( $response->count, 3, "got 3 results" );
    ok( $response->search_time, "got search_time" );
    ok( $response->build_time,  "got build time" );
    is( $response->query, "foo", "round-trip query string" );
}
