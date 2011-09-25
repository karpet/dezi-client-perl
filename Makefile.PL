use inc::Module::Install;

name 'Dezi-Client';
all_from 'lib/Dezi/Client.pm';
author q{Peter Karman <karman@cpan.org>};
license 'perl';
homepage 'https://github.com/karpet/dezi-client-perl';
bugtracker 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dezi-Client';
repository 'git://github.com/karpet/dezi-client-perl.git';

build_requires 'Test::More';

requires 'LWP::UserAgent';
requires 'JSON';
requires 'Carp';

auto_install;

WriteAll;

