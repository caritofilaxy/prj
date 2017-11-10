package SS::Schema::Result::Dictionary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::Dictionary

=cut

__PACKAGE__->table("dictionaries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 lang_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 url

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 hidden

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 checked_by_default

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "lang_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "hidden",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "checked_by_default",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 type

Type: belongs_to

Related object: L<SS::Schema::Result::DictionaryType>

=cut

__PACKAGE__->belongs_to(
  "type",
  "SS::Schema::Result::DictionaryType",
  { id => "type_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 lang

Type: belongs_to

Related object: L<SS::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "lang",
  "SS::Schema::Result::Language",
  { id => "lang_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 users_checked_by_default_dictionaries

Type: has_many

Related object: L<SS::Schema::Result::UserCheckedByDefaultDictionaries>

=cut

__PACKAGE__->has_many(
  "users_checked_by_default_dictionaries",
  "SS::Schema::Result::UserCheckedByDefaultDictionaries",
  { "foreign.dict_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_default_dictionaries

Type: has_many

Related object: L<SS::Schema::Result::UserDefaultDictionary>

=cut

__PACKAGE__->has_many(
  "user_default_dictionaries",
  "SS::Schema::Result::UserDefaultDictionary",
  { "foreign.dict_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-12-13 20:31:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b149wTROCEVhkqxARvrIeQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
