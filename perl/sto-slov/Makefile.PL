#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'SS';
all_from 'lib/SS.pm';

requires 'Catalyst::Runtime' => '5.80025';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Catalyst::Plugin::Unicode::Encoding';
requires 'Catalyst::Plugin::StatusMessage';
requires 'HTML::FormFu';
requires 'HTML::FormFu::Model::DBIC';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::Any';
requires 'PerlIO::eol';
requires 'Perl6::Junction';
requires 'HTML::Strip';
requires 'Lingua::StopWords';
requires 'Lingua::Stem::Snowball';
requires 'Lingua::RU::Numeric::Declension';
requires 'Hook::LexWrap';
requires 'Log::Dispatch::File';
requires 'Log::Log4perl';
requires 'Smart::Comments';
test_requires 'Test::More' => '0.88';
test_requires 'Test::Differences';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
