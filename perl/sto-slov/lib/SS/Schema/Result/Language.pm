package SS::Schema::Result::Language;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::Language

=cut

__PACKAGE__->table("languages");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 code

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "code",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sqlite_autoindex_languages_2", ["name"]);
__PACKAGE__->add_unique_constraint("sqlite_autoindex_languages_1", ["code"]);

=head1 RELATIONS

=head2 dictionaries

Type: has_many

Related object: L<SS::Schema::Result::Dictionary>

=cut

__PACKAGE__->has_many(
  "dictionaries",
  "SS::Schema::Result::Dictionary",
  { "foreign.lang_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_default_dictionaries

Type: has_many

Related object: L<SS::Schema::Result::UserDefaultDictionary>

=cut

__PACKAGE__->has_many(
  "user_default_dictionaries",
  "SS::Schema::Result::UserDefaultDictionary",
  { "foreign.lang_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_lesson_limits

Type: has_many

Related object: L<SS::Schema::Result::UserLessonLimit>

=cut

__PACKAGE__->has_many(
  "user_lesson_limits",
  "SS::Schema::Result::UserLessonLimit",
  { "foreign.lang_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 extra_stop_words

Type: has_many

Related object: L<SS::Schema::Result::ExtraStopWord>

=cut

__PACKAGE__->has_many(
  "extra_stop_words",
  "SS::Schema::Result::ExtraStopWord",
  { "foreign.lang_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 known_words

Type: has_many

Related object: L<SS::Schema::Result::KnownWord>

=cut

__PACKAGE__->has_many(
  "known_words",
  "SS::Schema::Result::KnownWord",
  { "foreign.lang_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-12-13 20:59:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RgT/TMeRyb/cr04hfNinCQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
