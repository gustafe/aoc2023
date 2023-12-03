#! /usr/bin/env perl
# Advent of Code 2023 Day 2 - Cube Conundrum - complete solution
# https://adventofcode.com/2023/day/2
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum product/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
no warnings 'uninitialized';
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $Games;
for my $line (@input) {
    my $game;
    my @game = split( /:/, $line );
    if ( $game[0] =~ m/Game (\d+)/ ) {
        $game->{id} = $1;
    }
    for my $el ( split( /;/, $game[1] ) ) {
        my $set;
        for my $color ( split( /,/, $el ) ) {
            if ( $color =~ m/(\d+) (blue|green|red)/ ) {
                $set->{$2} = $1;
            }
        }
        push @{ $game->{sets} }, $set;
    }
    push @{$Games}, $game;
}

my $sum1;
my $sum2;

for my $game (@$Games) {
    my $impossible = 0;
    my $max_values = { blue => 0, green => 0, red => 0 };

    for my $set ( @{ $game->{sets} } ) {
        if ( $set->{blue} > 14 or $set->{green} > 13 or $set->{red} > 12 ) {
            $impossible++;
        }
        for my $color (qw/blue green red/) {
            if ( $set->{$color} > $max_values->{$color} ) {
                $max_values->{$color} = $set->{$color};
            }
        }
    }

    $sum1 += $game->{id} unless $impossible;
    $sum2 += product( values %$max_values );
}

### FINALIZE - tests and run time
is( $sum1, 1931,  "Part 1: $sum1" );
is( $sum2, 83105, "Part 2: $sum2" );
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

=head3 Day 2: Cube Conundrum

=encoding utf8

Not a very hard problem, but I overthought how to parse the input and store it in a datastructure, which caused me a lot of problems in the beginning.

Score: 2

Leaderboard completion time: 6m15s

=cut

