package HTML::FormFu::Validator::SS::DefaultDictionaryIdIsValid;

#===============================================================================
#     REVISION:  $Id: DefaultDictionaryIdIsValid.pm 103 2011-11-28 16:18:04Z xdr.box@gmail.com $
#  DESCRIPTION:  Check that default_dictionary_id is within dictionary_id_list
#       AUTHOR:  Alexander Simakov <xdr [dot] box [at] gmail [dot] com>
#===============================================================================

use strict;
use warnings;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 103 $) [1];

use English qw( -no_match_vars );
use Perl6::Junction qw( any );

#use Smart::Comments;

use base qw(HTML::FormFu::Validator);

sub validate_value {
    my ( $self, $default_dictionary_id, $params ) = @_;

    # $params->{'dictionary_id_list'} can be either scalar value or array ref
    # TODO duplicated code, move to utils
    my @dictionary_id_list
        = ref $params->{'dictionary_id_list'} eq 'ARRAY'
        ? @{ $params->{'dictionary_id_list'} }
        : ( $params->{'dictionary_id_list'} );
    ### default_dictionary_id: $default_dictionary_id
    ### dictionary_id_list: @dictionary_id_list

    if ( not $default_dictionary_id eq any(@dictionary_id_list) ) {
        ## no critic (RequireCarping)
        die HTML::FormFu::Exception::Validator->new(
            {   message =>
                    'Любимый словарь непременно должен быть '
                    . 'в списке используемых словарей!'
            }
        );
    }

    return 1;
}

1;
