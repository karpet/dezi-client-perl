use inc::Module::Install;

name 'Dezi-Client';
all_from 'lib/Dezi/Client.pm';
author q{Peter Karman <karman@cpan.org>};
license 'perl';
homepage 'https://github.com/karpet/dezi-client-perl';
bugtracker 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dezi-Client';
repository 'git://github.com/karpet/dezi-client-perl.git';

build_requires 'Test::More';

# Dezi server not required for client, but 
# should be at least version 0.001002 on server-side.

requires 'LWP::UserAgent';
requires 'Class::XSAccessor';
requires 'HTTP::Request';
requires 'SWISH::Prog::Utils' => '0.53';
requires 'Search::Tools'      => '0.62';
requires 'URI::Query';
requires 'File::Slurp';
requires 'JSON';
requires 'Carp';

install_script 'bin/dezi-client';

auto_install;

WriteAll;

