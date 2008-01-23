package Test::Fixture::DBIC::Schema;
use strict;
use warnings;
our $VERSION = '0.01';
use base 'Exporter';
our @EXPORT = qw/construct_fixture/;

sub construct_fixture {
    validate(
        @_ => +{
            schema  => +{ isa => 'DBIx::Class::Schema' },
            fixture => 1,
        }
    );
    my %args = @_;

    _delete_all($args{schema});
    return _insert($args{schema}, _load_fixture($args{fixture}));
}

sub _load_fixture {
    my $stuff = shift;

    if (ref $stuff eq 'ARRAY') {
        return $stuff;
    } else {
        require YAML::Syck;
        return YAML::Syck::LoadFile($stuff);
    }
}

sub _delete_all {
    my $schema = shift;

    for my $table ( map { $schema->source($_)->from } $schema->sources ) {
        $schema->storage->dbh->do("DELETE FROM $table");
    }
}

sub _insert {
    my ($schema, $fixture) = @_;

    my $rows = {};
    for my $row ( @{ $fixture } ) {
        # store and get the data.
        my $data = $schema->resultset( $row->{schema} )->create( $row->{data} );
        $self->{ $row->{name} } = $schema->resultset( $row->{schema} )->find( { id => $data->id } );
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Test::Fixture::DBIC::Schema - load fixture data to storage.

=head1 SYNOPSIS

  # in your t/*.t
  use Test::Fixture::DBIC::Schema;
  my $data = construct_fixture(
    schema  => $self->model,
    fixture => 'fixture.yaml',
  );

  # in your fixture.yaml
  - schema: Entry
    data:
      id: 1
      title: my policy
      body: shut the f*ck up and write some code
      timestamp: 2008-01-01 11:22:44
  - schema::Entry
    data:
      id: 2
      title: please join
      body: #coderepos-en@freenode.
      timestamp: 2008-02-23 23:22:58

=head1 DESCRIPTION

Test::Fixture::DBIC::Schema is fixture data loader for DBIx::Class::Schema.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

Kan Fushihara

=head1 SEE ALSO

L<DBIx::Class>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
