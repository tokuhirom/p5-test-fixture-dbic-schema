use inc::Module::Install;
name 'Test-Fixture-DBIC-Schema';
all_from 'lib/Test/Fixture/DBIC/Schema.pm';

requires $_ for (qw/
/);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
