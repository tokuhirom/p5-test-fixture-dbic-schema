package t::Foo::Record;
use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('record');
__PACKAGE__->add_columns(qw/ recordid artist title year /);
__PACKAGE__->set_primary_key('recordid');

my $source = __PACKAGE__->result_source_instance();
my $new_source = $source->new( $source );
$new_source->source_name( 'Karaoke' );

$new_source->name( \<<SQL );
(
    SELECT
        record.recordid id,
        record.artist artist,
        record.title title,
        record.year year
    FROM
        record
    UNION ALL
    SELECT
        cd.cdid id,
        cd.artist artist,
        cd.title title,
        cd.year year
    FROM
        cd
)
SQL

DBIx::Class::Schema->register_extra_source( 'Karaoke' => $new_source );

1;
