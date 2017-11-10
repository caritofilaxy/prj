package SS::Schema::Result::KnownWord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::KnownWord

=cut

__PACKAGE__->table("known_words");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 lang_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 word

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "lang_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "word",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "sqlite_autoindex_known_words_1",
  ["user_id", "lang_id", "word"],
);

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-11-01 13:01:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hdm1AAOmZbqdyx8f74eN5w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
