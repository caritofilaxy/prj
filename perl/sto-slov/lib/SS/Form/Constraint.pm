package SS::Form::Constraint;

#===============================================================================
#     REVISION:  $Id: Constraint.pm 204 2012-01-15 23:03:00Z xdr.box@gmail.com $
#  DESCRIPTION:  Callback constraints for FormFu's forms
#===============================================================================

use strict;
use warnings;
use utf8;

use Readonly;
Readonly our $VERSION => qw($Revision: 204 $) [1];

use English qw( -no_match_vars );
use Lingua::RU::Numeric::Declension qw( numdecl );

#use Smart::Comments;

Readonly my $EMPTY_STR => q{};

## no critic (RequireCarping)

sub _simvolov {
    my $number = shift;

    return "$number "
        . numdecl( $number, 'символ', 'символа',
        'символов' );
}

sub username_length {
    my $value = shift || $EMPTY_STR;

    return 1 if !$value;    # This case is checked by 'Required' constraint

    my $min_username_length = SS->config()->{'min_username_length'};
    my $max_username_length = SS->config()->{'max_username_length'};

    if ( length $value < $min_username_length ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message => 'Слишком коротко: минимум '
                    . _simvolov($min_username_length)
                    . ' пожалуйста!',
            }
        );
    }

    if ( length $value > $max_username_length ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message => 'Слишком длинно: максимум '
                    . _simvolov($max_username_length)
                    . ' пожалуйста!',
            }
        );
    }

    return 1;
}

sub password_length {
    my $value = shift || $EMPTY_STR;

    return 1 if !$value;    # This case is checked by 'Required' constraint

    my $min_password_length = SS->config()->{'min_password_length'};
    my $max_password_length = SS->config()->{'max_password_length'};

    if ( length $value < $min_password_length ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message => 'Слишком коротко: минимум '
                    . _simvolov($min_password_length)
                    . ' пожалуйста!',
            }
        );
    }

    if ( length $value > $max_password_length ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message => 'Слишком длинно: максимум '
                    . _simvolov($max_password_length)
                    . ' пожалуйста!',
            }
        );
    }

    return 1;
}

sub lesson_limit_range {
    my $value = shift;

    # This case is checked by 'Required' constraint
    if ( not defined $value or $value eq q{} ) {
        return 1;
    }

    my $min_lesson_limit = SS->config()->{'min_lesson_limit'};
    my $max_lesson_limit = SS->config()->{'max_lesson_limit'};

    if ( $value !~ /\A\d+\z/xms ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message =>
                    "Введите число от $min_lesson_limit до $max_lesson_limit!",
            }
        );
    }

    if ( $value < $min_lesson_limit ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message =>
                    "Должно быть не меньше чем $min_lesson_limit!",
            }
        );
    }

    if ( $value > $max_lesson_limit ) {
        die HTML::FormFu::Exception::Constraint->new(
            {   message =>
                    "Должно быть не больше чем $max_lesson_limit!",
            }
        );
    }

    return 1;
}

1;

