package SS::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

SS::Schema::Result::User

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 1

=head2 username

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 1 },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sqlite_autoindex_users_1", ["username"]);

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<SS::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "SS::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_checked_by_default_dictionaries

Type: has_many

Related object: L<SS::Schema::Result::UserCheckedByDefaultDictionaries>

=cut

__PACKAGE__->has_many(
  "users_checked_by_default_dictionaries",
  "SS::Schema::Result::UserCheckedByDefaultDictionaries",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_default_dictionaries

Type: has_many

Related object: L<SS::Schema::Result::UserDefaultDictionary>

=cut

__PACKAGE__->has_many(
  "user_default_dictionaries",
  "SS::Schema::Result::UserDefaultDictionary",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_lesson_limits

Type: has_many

Related object: L<SS::Schema::Result::UserLessonLimit>

=cut

__PACKAGE__->has_many(
  "user_lesson_limits",
  "SS::Schema::Result::UserLessonLimit",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 known_words

Type: has_many

Related object: L<SS::Schema::Result::KnownWord>

=cut

__PACKAGE__->has_many(
  "known_words",
  "SS::Schema::Result::KnownWord",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2011-12-13 20:31:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OuMabMakTjJWQs8zV85p8g

#use Smart::Comments;

sub get_lesson_limit_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my $row = $self->user_lesson_limits()->single( { lang_id => $lang_id } );

    return if !$row;
    return $row->lesson_limit();
}

sub get_default_dict_id_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my $row = $self->user_default_dictionaries()
        ->single( { lang_id => $lang_id } );

    return if !$row;
    return $row->dict_id();
}

sub get_known_words_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my @known_words = map { $_->word() }
        $self->known_words()->search( { lang_id => $lang_id } );
    ### known_words: @known_words

    return \@known_words;
}

sub get_known_words_with_ids_for_lang_id {
    my $self    = shift;
    my $lang_id = shift;

    my @known_words
        = map { { id => $_->id(), word => $_->word() } }
        $self->known_words()
        ->search( { lang_id => $lang_id }, { order_by => ['word'] } );
    ### known_words: @known_words

    return \@known_words;
}

sub delete_known_words {
    my $self           = shift;
    my $known_word_ids = shift;

    my $words_deleted = $self->known_words()
        ->search( { id => { '-in' => $known_word_ids } } )->delete();

    return 0 + $words_deleted;    # '0E0' if 0 records removed
}

sub add_known_word {
    my $self    = shift;
    my $lang_id = shift;
    my $word    = shift;

    my $new_row = $self->known_words()->new_result(
        {   lang_id => $lang_id,
            word    => $word,
        }
    );

    $new_row->insert();

    return;
}

1;
