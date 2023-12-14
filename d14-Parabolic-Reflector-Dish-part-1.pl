#! /usr/bin/env perl
# Advent of Code 2023 Day 14 - Parabolic Reflector Dish - part 1
# https://adventofcode.com/2023/day/14
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum max/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
use Clone qw/clone/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
# Map is columns/rows, 0 is north
# zero-based is ok in this case
my $Map;
my $r = 1;
for my $el (@input) {
    my $c = 1;
    for my $chr ( split( //, $el ) ) {
        $Map->{$c}{$r} = $chr unless $chr eq '.';    # don't store empty space
        $c++;
    }
    $r++;
}
my $maxr = $r - 1;

dump_map($Map) if $testing;

# go column by column, adding each rock we see to the lowest platform
my $newMap;
for my $col ( sort { $a <=> $b } keys %$Map ) {
    my $row = clone $Map->{$col};

    #    say dump $row;
    my $newrow = clone $row;
    my $lowest = 0;
    for my $pos ( sort { $a <=> $b } keys %{$row} ) {
        if ( $pos <= $lowest ) {
            $lowest = $pos;
        } else {    # we can move?
            if ( $row->{$pos} ne '#' ) {
                delete $newrow->{$pos};
                $newrow->{ $lowest + 1 } = $row->{$pos};
                $lowest = $lowest + 1;
            } else {
                $newrow->{$pos} = '#';
                $lowest = $pos;
            }
        }
    }
    $newMap->{$col} = $newrow;
}

dump_map($newMap) if $testing;
my $sum;
for my $col ( keys %$newMap ) {
    for my $r ( keys %{ $newMap->{$col} } ) {
        if ( $newMap->{$col}{$r} eq 'O' ) {
            $sum += ( $maxr + 1 - $r );
        }
    }
}

### FINALIZE - tests and run time
is( $sum, 112773, "Part 1: $sum" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub dump_map {
    my ($map) = @_;
    for my $col ( 1 .. max( keys %$map ) ) {
        my %row = %{ $map->{$col} };
        for my $r ( 1 .. $maxr ) {
            print $row{$r} ? $row{$r} : '.';
        }
        print "\n";
    }
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 14: Parabolic Reflector Dish, part 1

=encoding utf8

Only part 1 for now.

Dealing with matrices yesterday helped a bit with this one.

TODO: part 2.

Score: 1

Leaderboard completion time: 17m15s.

=cut
