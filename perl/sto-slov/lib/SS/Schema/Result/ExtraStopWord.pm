package SS::Schema::Result::ExtraStopWord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::ExtraStopWord

=cut

__PACKAGE__->table("extra_stop_words");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

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
  "lang_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "word",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sqlite_autoindex_extra_stop_words_1", ["lang_id", "word"]);

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


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-12-13 20:59:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5JrVCBhcQcuwxdDLZcDFEw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
