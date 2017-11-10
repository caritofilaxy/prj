package SS::Schema::Result::DictionaryType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::DictionaryType

=cut

__PACKAGE__->table("dictionary_types");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 dictionaries

Type: has_many

Related object: L<SS::Schema::Result::Dictionary>

=cut

__PACKAGE__->has_many(
  "dictionaries",
  "SS::Schema::Result::Dictionary",
  { "foreign.type_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-10-20 18:55:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kUK9dKIoLPJP/SQHY1fSew


# You can replace this text with custom content, and it will be preserved on regeneration
1;
