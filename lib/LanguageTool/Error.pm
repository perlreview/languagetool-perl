package LanguageTool::Error;
use v5.10;
use strict;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use warnings;
no warnings;

use Mojo::Util qw(dumper);

our $VERSION = '0.001_01';

=encoding utf8

=head1 NAME

LanguageTool::Error - encapsulates the various errors

=head1 SYNOPSIS

	use LanguageTool;

	my $languagetool = LanguageTool->new;

	my $result = $languagetool->check( $text )

=head1 DESCRIPTION

=over 4

=item new

=cut

sub new ( $class, $text ) {
	( bless {}, $class )->init( $text )
	}

=item init

=cut

sub init ( $self, $text ) {
	return unless $text =~ /\AError:\s+/gc;
	$self->{text} = $text;

	if( $text =~ /\GInternal Error:\s+/gc ) {
		bless $self, $self->internal_error_class;
		}
	elsif( $text =~ /\G\S+ is not a language code/gc ) {
		bless $self, $self->language_error_class;
		}

	$self;
	}

sub is_error ( $self ) { 1 }

sub internal_error_class ( $self ) {
	$self->_create_class('LanguageTool::Error::Internal');
	}

sub language_error_class ( $self ) {
	$self->_create_class('LanguageTool::Error::LanguageError');
	}

sub _create_class ( $self, $class ) {
	no strict 'refs';
	@{$class . '::ISA'} = __PACKAGE__;
	$class;
	}

=back

=head1 Encountered Errors

Error: 'fr-FR' is not a language code known to LanguageTool. Supported language codes are: ast-ES, be-BY, br-FR, ca-ES, ca-ES-valencia, da-DK, de, de-AT, de-CH, de-DE, de-DE-x-simple-language, el-GR, en, en-AU, en-CA, en-GB, en-NZ, en-US, en-ZA, eo, es, fa, fr, gl-ES, it, ja-JP, km-KH, nl, pl-PL, pt, pt-AO, pt-BR, pt-MZ, pt-PT, ro-RO, ru-RU, sk-SK, sl-SI, sr, sr-BA, sr-HR, sr-ME, sr-RS, sv, ta-IN, tl-PH, uk-UA, zh-CN. The list of languages is read from META-INF/org/languagetool/language-module.properties in the Java classpath. See http://wiki.languagetool.org/java-api for details.

Error: Internal Error: java.lang.RuntimeException: Not found or is not a directory:
/home/deploy/languagetool/shared/ngrams/fr
As ngram directory, please select the directory that has a subdirectory like 'en'
(or whatever language code you're using).

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/perlreview/languagetool-perl

=head1 AUTHOR

brian d foy, C<< <briandfoy@pobox.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019-2021, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;

__END__
