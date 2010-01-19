use inc::Module::Install;
name 'Test-Fixture-DBIC-Schema';
all_from 'lib/Test/Fixture/DBIC/Schema.pm';

requires 'Kwalify' => 1.16;
requires 'DBIx::Class' => 0.08008;
requires 'YAML::Syck' => 1.00;
requires 'Params::Validate' => 0.89;

author_tests('xt');

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
