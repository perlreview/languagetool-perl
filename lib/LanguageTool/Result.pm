package LanguageTool::Result;
use v5.10;
use strict;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use warnings;
no warnings;

use Mojo::Collection;
use Mojo::Util qw(dumper);

our $VERSION = '0.001_01';

=encoding utf8

=head1 NAME

LanguageTool::Result - encapsulates the various bits of the response

=head1 SYNOPSIS

	use LanguageTool;

	my $languagetool = LanguageTool->new;

	my $result = $languagetool->check( $text )

=head1 DESCRIPTION

=over 4

=item new

=cut

sub new ( $class, $json ) {
	( bless {}, $class )->init( $json )
	}

=item init

=cut

sub init ( $self, $json ) {
	$self->{language} = $self->language_class->new( $json->{language} );
	$self->{software} = $self->software_class->new( $json->{software} );

	$self->{matches} = Mojo::Collection->new;
	foreach my $match ( $json->{matches}->@* ) {
		state $count = 0;
		say "Found " . ++$count . " match";
		push $self->{matches}->@*, $self->match_class->new( $match )
		}

	$self;
	}

sub is_error ( $self ) { 0 }

sub match_class ( $self ) {
	state $class = 'LanguageTool::Result::Match';
	eval "require $class; 1" or die;
	$class;
	}

sub language_class ( $self ) {
	state $class = 'LanguageTool::Result::Language';
	eval "require $class; 1" or die;
	$class;
	}

sub software_class ( $self ) {
	state $class = 'LanguageTool::Result::Software';
	eval "require $class; 1" or die;
	$class;
	}

sub warnings_class ( $self ) {
	state $class = 'LanguageTool::Result::Warnings';
	eval "require $class; 1";
	$class;
	}

=item matches

=cut

sub matches ( $self ) {
	$self->{matches}
	}

=item language

=cut

sub language ( $self ) { $self->{language} }

=item software

=cut

sub software ( $self ) { $self->{software} }

=item warnings

=cut

sub warnings ( $self ) { $self->{warnings} }

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/perlreview/languagetool-perl

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2019, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;

__END__
