# can use this while running tests
# usage example:
# % dezi --dc example-dezi-server-config.pl
#
{

    engine_config => {

        # which facets to calculate, and how many results to consider
        facets => {
            names => [qw( swishmime  )],
        },

        # see Search::OpenSearch::Engine::Lucy
        auto_commit => 0, # required for transaction tests

    }

}
