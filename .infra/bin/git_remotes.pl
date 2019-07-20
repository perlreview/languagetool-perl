#!/usr/bin/perl
use v5.10;
use strict;

use Mojo::JSON qw(decode_json);
use Mojo::Util qw(dumper);

my $string = `terraform output -json -state .infra/terraform.tfstate`;

my $perl = decode_json( $string );

my $table = {
	origin    => [ $perl->{github_push_url}{value}     ],
	bitbucket => [ $perl->{bitbucket_push_url}{value}  ],
	gitlab    => [ $perl->{gitlab_push_url}{value}     ],
	};

push $table->{all}->@*, map { $table->{$_}->@* } qw(origin bitbucket gitlab);

foreach my $remote ( keys $table->%* ) {
	my $main = shift $table->{$remote}->@*;
	my @command = ( qw(git remote add), $remote, $main );
	say "command: @command";
	system { $command[0] } @command;

	if( $table->{$remote}->@* ) {
		my @command = ( qw(git remote set-url --push all), $main );
		say "command: @command";
		system { $command[0] } @command;
		}

	foreach my $push_url ( $table->{$remote}->@* ) {
		my @command = ( qw(git remote set-url --add --push all), $push_url );
		say "command: @command";
		system { $command[0] } @command;
		}
	}

my @command = qw(git push -u all --all);
system { $command[0] } @command;
