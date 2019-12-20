package LanguageTool::Result::Software;
use v5.10;
use strict;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use warnings;
no warnings;

use parent qw(Hash::AsObject);

our $VERSION = '0.001_01';

=encoding utf8

=head1 NAME

LanguageTool::Result::Language - how your grammar is wrong!

=head1 SYNOPSIS

	use LanguageTool;

	my $languagetool = LanguageTool->new;

	my $result = $languagetool->check( $text )

=head1 DESCRIPTION

=over 4

=item new

=cut

sub new ( $class, $hash ) {
	( bless {}, $class )->init( $hash )
	}

=item init

=cut

sub init ( $self, $hash ) {
	%$self = $hash->%*;
	$self;
	}

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
