#! /usr/bin/env perl
# Advent of Code 2023 Day 4 - Scratchcards - complete solution
# https://adventofcode.com/2023/day/4
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;

sub sec_to_hms;
my $start_time = [gettimeofday];

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $Cards;
for my $line (@input) {
    my $card;
    my ($info, $data) = split( /:/, $line );
    ( $card->{id} ) = ( $info =~ m/Card\s+(\d+)/ );
    my ($win,$num) = split( /\|/, $data );

    %{ $card->{winning} } = map { $_ => 1 } ( $win =~ m/(\d+)/g );
    %{ $card->{numbers} } = map { $_ => 1 } ( $num =~ m/(\d+)/g );

    push @$Cards, $card;
}

say "==> Part 1...";
my $sum1;
my $Wins;
for my $card (@$Cards) {
    my $wins = 0;
    for my $num ( keys %{ $card->{winning} } ) {
        if ( exists $card->{numbers}{$num} ) {
            $wins++;
        }
    }

    $Wins->{ $card->{id} } = $wins;
    $sum1 += 2**( $wins - 1 ) if $wins;
}

my $max_id = $Cards->[-1]{id};

my @array = map { $_->{id} } @{$Cards};
my $sum2;
say "==> Part 2...";

while (@array) {
    my $next = shift @array;
    $sum2++;
    printf( "~~> %7d %7d\n", $sum2, scalar @array ) if $sum2 % 500_000 == 0;
    my $cards_to_copy = $Wins->{$next};
    for my $i ( 1 .. $cards_to_copy ) {
        push @array, $next + $i if $next + $i <= $max_id;
    }
    say "$next " . join( ',', @array ) if $testing;
}

### FINALIZE - tests and run time
is( $sum1, 21088,   "Part 1: $sum1" );
is( $sum2, 6874754, "Part 2: $sum2" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 4: Scratchcards

=encoding utf8

Score: 2

Leaderboard completion time: 7m08s

=cut
