package SS::Schema::Result::UserCheckedByDefaultDictionaries;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::UserCheckedByDefaultDictionaries

=cut

__PACKAGE__->table("user_checked_by_default_dictionaries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 dict_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 checked_by_default

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "dict_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "checked_by_default",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "sqlite_autoindex_user_checked_by_default_dictionaries_1",
  ["user_id", "dict_id"],
);

=head1 RELATIONS

=head2 dict

Type: belongs_to

Related object: L<SS::Schema::Result::Dictionary>

=cut

__PACKAGE__->belongs_to(
  "dict",
  "SS::Schema::Result::Dictionary",
  { id => "dict_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<SS::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "SS::Schema::Result::User",
  { id => "user_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-12-13 20:45:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OMqExlmlXqqsApfEt8kFfw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
