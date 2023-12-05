#! /usr/bin/env perl
# Advent of Code 2023 Day 5 - If You Give A Seed A Fertilizer - part 1 
# https://adventofcode.com/2023/day/5
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum first min max/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array

my $testing = 0;
my @data;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @data, $_; }

### CODE
my $line  = shift @data;
my @seeds = ( $line =~ m/(\d+)/g );
$line = shift @data;
my $Map;
sub translate;
my ( $input, $output );
while (@data) {
    my $line = shift @data;

    if ( $line =~ m/^(\S+)\-to\-(\S+) map\:$/ ) {

        $input  = $1;
        $output = $2;
    } elsif ( $line =~ m/(\d+) (\d+) (\d+)/ ) {
        push @{ $Map->{$input}{$output} },
            { dst => [ $1, $1 + $3 - 1 ], src => [ $2, $2 + $3 - 1 ] };
    } elsif ( length $line == 0 ) {
        ( $input, $output ) = ( undef, undef );
        next;
    } else {
        die "could not parse line: $line";
    }
}

my @locations;
for my $seed (@seeds) {
    my @stages
        = qw/seed soil fertilizer water light temperature humidity location/;
    my $in = $seed;
    for my $idx ( 0 .. $#stages - 1 ) {
        my ( $from, $to ) = @stages[ $idx, $idx + 1 ];
        my $out = translate( $from, $to, $in );
        $in = $out;

    }
    push @locations, $in;
}
my $part1 = min @locations;
#say "max in part 1: " . max @locations;

### FINALIZE - tests and run time
is( $part1, 251346198, "Part1 : " . $part1 );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub translate {
    my ( $from, $to, $val ) = @_;
    my @ranges
        = sort { $a->{src}[0] <=> $b->{src}[0] } @{ $Map->{$from}{$to} };

    #    say dump @ranges;
    for my $range (@ranges) {
        next if $val > $range->{src}[1];

        #my @src = ($range->{src}[0]..$range->{src}[1]);
        if ( $val >= $range->{src}[0] and $val <= $range->{src}[1] ) {
            my $offset = $val - $range->{src}[0];
            return $range->{dst}[0] + $offset;

        }
    }
    return $val;
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 5: If You Give A Seed A Fertilizer - Part 1

=encoding utf8

A tough problem combined with a stressful day leads to only one star so far.

Score: B<1>

Leaderboard completion time: 26m37s

=cut

