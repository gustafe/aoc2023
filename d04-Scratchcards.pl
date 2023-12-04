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
    my ( $info, $data ) = split( /:/, $line );
    ( $card->{id} ) = ( $info =~ m/Card\s+(\d+)/ );
    my ( $win, $num ) = split( /\|/, $data );

    %{ $card->{winning} } = map { $_ => 1 } ( $win =~ m/(\d+)/g );
    %{ $card->{numbers} } = map { $_ => 1 } ( $num =~ m/(\d+)/g );

    push @$Cards, $card;
}

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
my $sum2;
my @array = (0);
for my $card (@$Cards) {
    $array[ $card->{id} ] = 1;
}


for my $id ( 1 .. $max_id ) {
    my $cards_to_copy = $Wins->{$id};
    for my $i ( 1 .. $cards_to_copy ) {
        $array[ $id + $i ] += $array[$id] if $id + $i <= $max_id;
    }
}
$sum2 = sum @array;

### FINALIZE - tests and run time
if ($testing) {
    is( $sum1, 13, "Part 1: $sum1" );
    is( $sum2, 30, "Part 2: $sum2" );

} else {
    is( $sum1, 21088,   "Part 1: $sum1" );
    is( $sum2, 6874754, "Part 2: $sum2" );

}

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

The first attempt at part 2 was literally just implement the instructions in code: I had an array of cards, I picked the first, and depending on that card's wins and its position in the list, I prepended the cloned cards to the front of the array. 

This I<worked> in the sense that I got the correct answer, but it took 5s and a huge array. 

After thinking for a bit I realized it was more efficient to simply store the number of cloned cards in an array whose indices were the card ID. Much faster.

Previous solution: L<commit 39daebc|https://github.com/gustafe/aoc2023/blob/39daebc7a744b33b355da831f7f16b21605ccb75/d04-Scratchcards.pl>

Score: 2

Leaderboard completion time: 7m08s

=cut
