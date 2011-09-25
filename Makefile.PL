use inc::Module::Install;

name     'Dezi-Client';
all_from 'lib/Dezi/Client.pm';
author   q{Peter Karman <karman@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

