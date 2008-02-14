use strict;
use warnings;
use Test::More;
use t::Tools;
use Test::Fixture::DBIC::Schema;

eval { require DBD::SQLite; };
plan skip_all => "DBD::SQLite is not installed." if $@;

plan tests => 4;

eval { construct_fixture( schema  => schema, fixture => {},) };
like $@, qr{invalid fixture stuff. should be ARRAY: };

eval { construct_fixture() };
like $@, qr{Mandatory parameters 'fixture', 'schema' missing in call};

eval { construct_fixture(schema => schema) };
like $@, qr{Mandatory parameter 'fixture' missing in call};

eval { construct_fixture(schema => schema, fixture => [{ }]) };
like $@, qr{Expected required key};

