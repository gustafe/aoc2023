#! /usr/bin/env perl
# Advent of Code 2023 Day 16 - The Floor Will Be Lava - complete solution
# https://adventofcode.com/2023/day/16
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
my $Map;
my $r    = 0;
my $maxr = 0;
my $maxc = 0;
for my $line (@input) {
    my $c = 0;
    for my $chr ( split( //, $line ) ) {
        $Map->{$r}{$c} = $chr unless $chr eq '.';
        $maxc = $c if $c > $maxc;
        $c++;
    }
    $maxr = $r if $r > $maxr;
    $r++;
}

my %moves = (
    'N' => sub { [ -1, 0,  'N' ] },
    'S' => sub { [ 1,  0,  'S' ] },
    'E' => sub { [ 0,  1,  'E' ] },
    'W' => sub { [ 0,  -1, 'W' ] },
);

my %splits = (
    '|' => sub {
        my ($d) = @_;
        if ( $d eq 'S' or $d eq 'N' ) {
            return [$d];
        } else {
            return [ 'N', 'S' ];
        }
    },
    '-' => sub {
        my ($d) = @_;
        if ( $d eq 'E' or $d eq 'W' ) {
            return [$d];
        } else {
            return [ 'E', 'W' ];
        }
    },
    '/' => sub {
        my ($d) = @_;
        if ( $d eq 'N' ) { return ['E'] }
        if ( $d eq 'S' ) { return ['W'] }
        if ( $d eq 'E' ) { return ['N'] }
        if ( $d eq 'W' ) { return ['S'] }
    },

    # \
    '\\' => sub {
        my ($d) = @_;
        if ( $d eq 'N' ) { return ['W'] }
        if ( $d eq 'S' ) { return ['E'] }
        if ( $d eq 'E' ) { return ['S'] }
        if ( $d eq 'W' ) { return ['N'] }
    },
);
dump $Map if $testing;
my @starts = ();
for my $row ( 0 .. $maxr ) {
    push @starts, [ $row, -1, 'E' ];
    push @starts, [ $row, $maxc + 1, 'W' ];
}
for my $col ( 0 .. $maxc ) {
    push @starts, [ -1, $col, 'S' ];
    push @starts, [ $maxr + 1, $col, 'N' ];
}
my $part1;
my $maxE = 0;

#@starts = ($starts[0]);
while (@starts) {
    my $start = shift @starts;
    my @queue = ($start);

    my $energ;
    my $beam_seen;

    # modified BFS - add beams of light to a queue, queue is empty of
    # beam hits an obstacle or passes outside the map. Beam has origin
    # (r,c) and direction N,S,E,W

QUEUE: while (@queue) {
        my $b = shift @queue;

        # try to move
        my $dir = $b->[2];
        my $n   = [
            $b->[0] + $moves{$dir}->($b)->[0],
            $b->[1] + $moves{$dir}->($b)->[1],
            $moves{$dir}->($b)->[2]
        ];

        #    dump $n if $testing;
        # move along the direction until we hit a mirror or the edge
        while ( !defined $Map->{ $n->[0] }{ $n->[1] }
            and ( $n->[0] >= 0 and $n->[0] <= $maxr )
            and ( $n->[1] >= 0 and $n->[1] <= $maxc ) )
        {

            $energ->{ $n->[0] }{ $n->[1] }++;

            $n = [
                $n->[0] + $moves{$dir}->($n)->[0],
                $n->[1] + $moves{$dir}->($n)->[1],
                $moves{$dir}->($n)->[2]
            ];
        }

        # we've hit something
        if ( defined $Map->{ $n->[0] }{ $n->[1] } ) {
            my $chr   = $Map->{ $n->[0] }{ $n->[1] };
            my $split = $chr;

            # if we've seen the combination of mirror position and
            # beam direction before, we're in a loop, break
            if ( $beam_seen->{ join( ',', @$n ) } ) {
                next QUEUE;
            } else {
                $beam_seen->{ join( ',', @$n ) }++;
            }
            $energ->{ $n->[0] }{ $n->[1] }++;
            my $newdir = $splits{$split}->( $n->[2] );

            for my $d (@$newdir) {
                push @queue, [ $n->[0], $n->[1], $d ];
            }

        }
        dump \@queue if $testing;
    }

    # count the energized cells
    my $count = 0;
    for my $r ( 0 .. $maxr ) {
        for my $c ( 0 .. $maxc ) {
            if ( $energ->{$r}{$c} ) {
                print '#' if $testing;
                $count++;
            } else {
                print '.' if $testing;
            }
        }
        print "\n" if $testing;
    }
    if ( $start->[0] == 0 and $start->[1] == -1 and $start->[2] eq 'E' )
    {    # part 1
        $part1 = $count;
    }
    $maxE = $count if $count > $maxE;

    #    dump [$start, $maxE];
}
say "Max E:" . $maxE;
### FINALIZE - tests and run time
if ( !$testing ) {
    is( $part1, 8901, "Part 1: $part1" );
    is( $maxE,  9064, "Part 2: $maxE" );
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

=head3 Day 16: The Floor Will Be Lava

=encoding utf8

My first solution to part one used a counter to detect loops, which gave each entry point a runtime of about 30s. I quickly realized it would take 2hrs to bruteforce this, but I had a Christmas tree to deal with so I just set it to run. After about 50% I noticed the number of energized cells wasn't changing, so I just put that in as the part 2 answer and it was accepted! 

Obviously this wasn't general enough so I coded up a better loop detection. Now the entire brute force runs in 30s...

Incidentally for my input part 2 was for the very next row, but from the opposite direction... 

Score: 2

Leaderboard completion time: 15m30s

=cut
