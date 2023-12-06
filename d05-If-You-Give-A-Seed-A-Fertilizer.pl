#! /usr/bin/env perl
# Advent of Code 2023 Day 5 - If You Give A Seed A Fertilizer - complete solution
# https://adventofcode.com/2023/day/5
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum first min max/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
use Clone qw/clone/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my $part2   = shift @ARGV // 0;
if ($part2) {
    say "Solving part 2...";
} else {
    say "Solving part 1, pass a true argument to solve part 2...";
}
my @data;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @data, $_; }

### CODE
my $line  = shift @data;
my @seeds = ( $line =~ m/(\d+)/g );
$line = shift @data;
my $Maps;
my ( $input, $output );
my $idx = 0;

while (@data) {
    my $line = shift @data;
    if ( $line =~ m/^(\S+)\-to\-(\S+) map\:$/ ) {

        $input  = $1;
        $output = $2;
        $Maps->[$idx]{desc} = [ $input, $output ];

    } elsif ( $line =~ m/(\d+) (\d+) (\d+)/ ) {

        push @{ $Maps->[$idx]{intervals} }, [ $1, $2, $3 ];

    } elsif ( length $line == 0 ) {
        ( $input, $output ) = ( undef, undef );

        $idx++;
        next;
    } else {
        die "could not parse line: $line";
    }
}

my $ranges;
if ( !$part2 ) {
    for my $s (@seeds) {
        push @$ranges, [ $s, 1 ];
    }
} else {
    while (@seeds) {
        my $start = shift @seeds;
        my $len   = shift @seeds;
        push @$ranges, [ $start, $len ];
    }

}
for my $map (@$Maps) {
    my @nextranges;
    for my $interval ( @{ $map->{intervals} } ) {

        my ( $dst, $src, $len ) = @$interval;
        my @noopranges;
        for my $range (@$ranges) {
            my ( $rpos, $rlen ) = @$range;

            if ( $rpos + $rlen < $src ) {
                push @noopranges, [ $rpos, $rlen ];
            } elsif ( $rpos >= $src + $len ) {
                push @noopranges, [ $rpos, $rlen ];
            } else {
                my $start  = max( $rpos, $src );
                my $end    = min( $rpos + $rlen, $src + $len );
                my $newPos = $dst + $start - $src;
                my $newLen = $end - $start;
                push @nextranges, [ $newPos, $newLen ];
                if ( $rpos < $src ) {
                    push @noopranges, [ $rpos, $src - $rpos ];
                }
                if ( $rpos + $rlen > $src + $len ) {
                    push @noopranges,
                        [ $src + $len, $rpos + $rlen - $src - $len ];

                }
            }
        }
        $ranges = \@noopranges;
    }
    push @nextranges, @$ranges;
    $ranges = \@nextranges;
}
my $ans = min map { $_->[0] } @$ranges;
### FINALIZE - tests and run time

if ($part2) {
    is( $ans, 72263011, "Part 2: " . $ans );
} else {
    is( $ans, 251346198, "Part 1: " . $ans );

}

#is($part1,251346198,"Part1 : ".$part1);

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

=head3 Day 5: If You Give A Seed A Fertilizer

=encoding utf8

I solved both parts after thinking about it for a while.

I had the right idea from the start for part 2, which was handling ranges of integers instead of arrays. But I got lost in the weeds trying to get my iterations to to work. Studying some other solution put me on the right track.

This solution supersedes my earlier part 1, which can be dredged from the repo is one wishes to see it.

Score: 2

Leaderboard completion time: 26m37s

=cut

