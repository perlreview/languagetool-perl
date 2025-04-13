package LanguageTool;
use v5.10;
use strict;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use warnings;
no warnings;

our $VERSION = '0.001_01';

use Carp qw(carp);

use Mojo::JSON qw(decode_json);
use Mojo::URL;
use Mojo::UserAgent;

=encoding utf8

=head1 NAME

LanguageTool - Interact with the LanguageTool API through Perl

=head1 SYNOPSIS

	use LanguageTool;

	my $languagetool = LanguageTool->new( api_key => $key );

	$languagetool->check( $text )

=head1 DESCRIPTION


http://wiki.languagetool.org/java-api
https://languagetool.org/http-api/languagetool-swagger.json

=over 4

=item new

=cut

sub new ( $class, @args ) {
	( bless {}, $class )->init( @args )
	}

=item init

=cut

package LanguageTool::Null {
	use overload
		'bool'   => sub { 0 },
		'""'     => sub { '' },
		'0+'     => sub { 0 },
		fallback => 1;
  	our $null = bless {}, __PACKAGE__;
	use Carp qw(carp);
	sub new { $null }
	sub is_error { 1 }
	sub DESTROY { 1 }
	sub AUTOLOAD {
		carp "Using the LanguageTool::Null object (usually an error)";
		$null
		}
	}

sub init ( $self, @args ) {
	my %args = @args;
	$self->{ua} = Mojo::UserAgent->new;

	$self->{base_url} = Mojo::URL->new($args{base_url}) if exists $args{base_url};

	$self->{language} = do {
		if( exists $args{language} ) {
			unless( $self->is_supported_language( $args{language} ) ) {
				carp "<$args{language}> is not a supported language.";
				warn "Supported languages: @{[ keys $self->supported_languages->%* ]}\n";
				return LanguageTool::Null->new;
				}
			$args{language}
			}
		else {
			$self->default_language;
			}
		};

	say "Language is " . $self->{language};
	$self;
	}

sub ua ( $self ) { $self->{ua} }

sub ping ( $self ) {
	$self->ua->head( $self->languages_url )->result->code eq "200";
	}

sub is_error { 0 }

sub check_url ( $self ) {
	state $u = $self->endpoint( 'check' ); $u
	}

sub languages_url ( $self ) {
	state $u = $self->endpoint( 'languages' ); $u
	}

sub endpoint ( $self, $action ) {
	my $url = $self->base_url->path( $action );
	}

=item check

=cut

sub check ( $self, $text ) {
	if( length $text > 50_000 ) {
		carp( "Text must be less than 50,000 characters" );
		return LanguageTool::Null->new;
		}
	unless( length $text ) {
		carp( "Text is empty" );
		return LanguageTool::Null->new;
		}
	my %form_params = (
		text     => $text,
		language => $self->language
		);

	my $tx = $self->ua->get( $self->check_url() => form => \%form_params );
	say $tx->req->to_string;
	say $tx->result->to_string;
	my $rc = $self->validate_json( $tx->result->body )
		if -1 < index $tx->result->headers->content_type, 'application/json';
	unless( $rc ) {
		carp "Invalid response!";
		return $self->error_class->new( $tx->result->text );
		}

say "this far";
	$self->result_class->new( $tx->result->json )
	}

=pod

Error: Internal Error: java.lang.RuntimeException: Not found or is not a directory:
/home/deploy/languagetool/shared/ngrams/fr
As ngram directory, please select the directory that has a subdirectory like 'en'
(or whatever language code you're using).

Error: 'fr-FR' is not a language code known to LanguageTool. Supported language codes are: ast-ES, be-BY, br-FR, ca-ES, ca-ES-valencia, da-DK, de, de-AT, de-CH, de-DE, de-DE-x-simple-language, el-GR, en, en-AU, en-CA, en-GB, en-NZ, en-US, en-ZA, eo, es, fa, fr, gl-ES, it, ja-JP, km-KH, nl, pl-PL, pt, pt-AO, pt-BR, pt-MZ, pt-PT, ro-RO, ru-RU, sk-SK, sl-SI, sr, sr-BA, sr-HR, sr-ME, sr-RS, sv, ta-IN, tl-PH, uk-UA, zh-CN. The list of languages is read from META-INF/org/languagetool/language-module.properties in the Java classpath. See http://wiki.languagetool.org/java-api for details.

=cut

sub validate_json ( $self, $text ) {
	my $rc = eval { decode_json( $text ); 1 };
	if( $ENV{DEBUG} and ! $rc ) {
		say "Error: $@";
		say "Bad text:\n----\n$text\n----\n";
		}
	$rc;
	}

sub result_class ( $self ) {
	state $class = 'LanguageTool::Result';
	eval "require $class; 1" or die;
	$class;
	}

sub error_class ( $self ) {
	state $class = 'LanguageTool::Error';
	eval "require $class; 1" or die;
	$class;
	}

=item default_base_url

This returns the base API URL to use if you don't specify your own. It
returns the one mentioned in the instructions to run a local LangaugeTool
server: I<http://localhost:8081/v2>.

=cut

sub default_base_url ( $self ) {
	Mojo::URL->new('http://localhost:8081/v2/');
	}

sub base_url ( $self ) {
	$self->{base_url} // $self->default_base_url
	}

sub api_key ( $self ) {
	$self->{api_key}
	}

sub default_language ( $self ) { 'en-US' }

sub supported_languages ( $self ) {
	state $hash = do {
		my %hash = map {
			$_->{code}     => $_,
			lc($_->{name}) => $_,
			$_->{longCode} => $_,
			}
			$self->ua->get( $self->languages_url )
				->result
				->json
				->@*;

		\%hash
		};

	$hash;
	}

sub is_supported_language ( $self, $language ) {
	exists ${ $self->supported_languages }{$language}
	}

sub language ( $self ) {
	$self->{language}
	}

=back

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
