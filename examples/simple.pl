#!/usr/bin/perl
use v5.10;

use Mojo::Util qw(dumper);

use LanguageTool;

my( $text, $language ) = @ARGV;
$language //= 'en-US';


my $languagetool = LanguageTool->new(
	language => $language
	);
if( $languagetool->is_error ) {
	die "LanguageTool error: " . ref $result;
	}

unless( $languagetool->is_supported_language( $language ) ) {
	die "Unsupported language: $language\n";
	}

my $rc = $languagetool->ping ? 'good' : 'bad';
say "ping: $rc";




my $result = $languagetool->check( $text );
if( $result->is_error ) {
	die "LanguageTool error: " . ref $result;
	}

use Mojo::Util qw(dumper);

say $result->language->name;
say $result->software->version;

say dumper( $result->matches );
