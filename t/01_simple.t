use strict;
use warnings;
use Test::More;
use t::Tools;
use Test::Fixture::DBIC::Schema;
use File::Temp qw/tempfile/;
use Test::Requires 'DBD::SQLite';

plan tests => 35;

schema->storage->dbh->do(
    q{
        INSERT INTO artist (artistid, name) VALUES (1, 'foo');
    }
);

is schema->resultset('Artist')->count, 1;

my @fixture_sources = (
    't/fixture.yaml',
    [
        {
            data => {
                cdid   => 3,
                artist => 2,
                title  => 'foo',
                year   => 2007,
            },
            schema => 'CD',
            name   => 'cd',
        },
        {
            data => {
                artistid => 2,
                name     => 'beatles',
            },
            schema => 'Artist',
            name   => 'artist',
        },
        {
            data => {
                recordid => 11,
                artist   => 11,
                title    => 'record',
                year     => 2019,
            },
            schema => 'Record',
            name   => 'record',
        },
    ]
);

for my $fixture_src (@fixture_sources) {
    my $fixture = construct_fixture(
        schema  => schema,
        fixture => $fixture_src
    );

    is schema->resultset('Artist')->count, 1;
    is schema->resultset('CD')->count, 1;
    is schema->resultset('ViewAll')->count, 1;
    is schema->resultset('Record')->count, 1;
    is schema->resultset('Karaoke')->count, 2;
    ok $fixture->{cd}, 'has key';
    ok $fixture->{artist}, 'has key';
    ok $fixture->{record}, 'has key';
    is $fixture->{cd}->id, 3;
    is $fixture->{cd}->title, 'foo';
    is $fixture->{artist}->name, 'beatles';
    is $fixture->{record}->id, 11;
    is $fixture->{record}->title, 'record';
    my @karaoke_list = schema->resultset('Karaoke')->search(
        {},
        {
            select => [qw/id artist title year/],
            as     => [qw/id artist title year/],
            order_by => 'id'
        }
    )->all;
    is $karaoke_list[0]->get_column('id'), 3;
    is $karaoke_list[0]->get_column('title'), 'foo';
    is $karaoke_list[1]->get_column('id'), 11;
    is $karaoke_list[1]->get_column('title'), 'record';
}
