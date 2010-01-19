package t::Tools;
use strict;
use warnings;
use t::Foo;

my $schema = t::Foo->connect("dbi:SQLite:", '', '');
$schema->storage->dbh->do(
    q{
        CREATE TABLE cd (
            cdid   INTEGER,
            artist INTEGER,
            title  VARCHAR(255),
            year   INTEGER
        );
    }
);
$schema->storage->dbh->do(
    q{
        CREATE TABLE artist (
            artistid INTEGER,
            name     VARCHAR(255)
        );
    }
);

sub import {
    my $pkg = caller(0);
    no strict 'refs'; ## no critic.
    *{"$pkg\::schema"} = sub () {
        $schema;
    };
}


1;
