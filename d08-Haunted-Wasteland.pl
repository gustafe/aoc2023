#! /usr/bin/env perl
# Advent of Code 2023 Day 8 - Haunted Wasteland - complete solution
# https://adventofcode.com/2023/day/8
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################
use Modern::Perl '2015';
# useful modules
use List::Util qw/sum all/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;

# this is a great module for number theory, we want the least common
# multiple

use ntheory qw/lcm/;

sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test2.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $Map;
my $Starts;
my @instr = split( //, shift @input );
shift @input;
for my $line (@input) {
    my ( $node, $left, $right )
        = $line =~ m/^(\S{3}) \= \((\S{3}), (\S{3})\)$/;
    if ( $node =~ m/..A/ ) {
        $Starts->{$node} = 0;
    }

    $Map->{$node} = { L => $left, R => $right };
}

# find the number of steps from each start '..A' to first goal in the
# form of '..Z'
for my $start ( keys %$Starts ) {
    # Start from 1 to account for the last step to reach the goal
    my $steps = 1;

    my $idx   = 0;
    my $cur   = $start;
LOOP: while (1) {

        my $next;
        my $dir = $instr[$idx];
        say "$cur -> $dir" if $testing;
        $next = $Map->{$cur}{$dir};
        say $next if $testing;
        if ( $next =~ m/..Z/ ) {
            last LOOP;
        }
        $cur = $next;
        $steps++;
        $idx = ( $idx + 1 ) % scalar @instr;
    }
    $Starts->{$start} = $steps;
}

# In my input, the end node for 'AAA' is 'ZZZ', so this value is
# correct for part 1. If it's not, you will have to change the above
# to ensure that you're looking at the path 'AAA'->'ZZZ';

my $part1 = $Starts->{'AAA'};

# Find the least common multiple for all the path lengths.

my $part2 = lcm( values %$Starts );

### FINALIZE - tests and run time
is( $part1, 20093,          "Part 1: $part1" );
is( $part2, 22103062509257, "Part 2: $part2" );
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

=head3 Day 8: Haunted Wasteland

=encoding utf8

Not the most difficult of puzzles. I realized after letting my first
naive stab at part 2 run for 10 minutes that There Had To Be A Better
Way. The obvious next step was to find the least common multiple of
each different "A to Z" path. I was a bit worried that the path
lengths would not be the same with each repetition, but either the
puzzle input assured that, or there's some math reason they're always
the same.

The LCD calculation is from the most excellent C<ntheory> module.

Score: 2

Leaderboard completion time: 10m16s

=cut
