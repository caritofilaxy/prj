package HTML::FormFu::Validator::SS::DictionaryIdListIsValid;

#===============================================================================
#     REVISION:  $Id: DictionaryIdListIsValid.pm 190 2012-01-10 21:37:53Z xdr.box@gmail.com $
#  DESCRIPTION:  Check that dictionary_id_list contains only valid IDs
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 190 $) [1];

use English qw( -no_match_vars );
use Perl6::Junction qw( any );

#use Smart::Comments;

use SS::Log;

use base qw(HTML::FormFu::Validator);

# NOTE: this callback is called for each selected dictionary.
# Nevertheless, it should also work if $dictionary_id_list
# contains all selected dictionaries at once.
sub validate_value {
    my ( $self, $dictionary_id_list, $params ) = @_;

    # $dictionary_id_list can be either scalar of array ref,
    # but see NOTE: above.
    my @dictionary_id_list
        = ref $dictionary_id_list eq 'ARRAY'
        ? @{$dictionary_id_list}
        : ($dictionary_id_list);
    ### dictionary_id_list: @dictionary_id_list

    my $c = $self->form->stash->{context};
    my @valid_dictionaries
        = map { $_->id() } @{ $c->session->{'dicts_for_cur_lang'} || [] };
    ### valid_dictionaries: @valid_dictionaries

    foreach my $dictionary_id (@dictionary_id_list) {
        if ( not $dictionary_id eq any(@valid_dictionaries) ) {
            my $logger = get_logger();
            $logger->warn(
                "Unexpected dictionary ID passed: '$dictionary_id'");

            ## no critic (RequireCarping)
            die HTML::FormFu::Exception::Validator->new(
                {   message =>
                        'По крайней мере один из выбранных вами словарей '
                        . 'не существует!'
                }
            );
        }
    }

    return 1;
}

1;
