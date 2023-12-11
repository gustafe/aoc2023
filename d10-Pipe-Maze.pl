#! /usr/bin/env perl
# Advent of Code 2023 Day 10 - Pipe Maze - complete solution
# https://adventofcode.com/2023/day/10
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
my $file = $testing ? 'test6.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $Map;

# map is in rows/cols, indexed from 1
my $start;
my $row = 1;
while (@input) {
    my $line = shift @input;
    my $col  = 1;
    for my $char ( split( //, $line ) ) {
        $Map->{$row}{$col} = $char;

        if ( $char eq 'S' ) {
            $start = [ $row, $col ];
        }
        $col++;
    }
    $row++;
}

#            N           S           W           E
my %move = (
    '|' => [ [ -1, 0 ],  [ 1, 0 ] ],
    '-' => [                         [ 0,  -1 ], [ 0, 1 ] ],
    'L' => [ [ -1, 0 ],                          [ 0, 1 ] ],
    'J' => [ [ -1, 0 ],              [ 0, -1 ] ],
    '7' => [             [ 1,  0 ],  [ 0, -1 ] ],
    'F' => [             [ 1,  0 ],              [ 0, 1 ] ],
);

# determine what S is
my $start_shape;
my $N = $Map->{ $start->[0] - 1 }{ $start->[1] };
my $S = $Map->{ $start->[0] + 1 }{ $start->[1] };
my $E = $Map->{ $start->[0] }{ $start->[1] + 1 };
my $W = $Map->{ $start->[0] }{ $start->[1] - 1 };

$N = undef unless ( $N =~ m/[|7F]/ );
$S = undef unless ( $S =~ m/[|LJ]/ );
$E = undef unless ( $E =~ m/[-J7]/ );
$W = undef unless ( $W =~ m/[-FL]/ );

if ( $N and $S ) { $start_shape = '|' }
if ( $N and $E ) { $start_shape = 'J' }
if ( $N and $W ) { $start_shape = 'L' }
if ( $E and $W ) { $start_shape = '-' }
if ( $S and $E ) { $start_shape = 'F' }
if ( $S and $W ) { $start_shape = '7' }

$Map->{ $start->[0] }{ $start->[1] } = $start_shape;

# walk the loop, use flood fill and count the number of visited nodes
my @queue;
my @visited;
my %loop;
push @queue,   $start;
push @visited, $start;
$loop{ $start->[0] }{ $start->[1] } = 1;
while (@queue) {
    my $cur = shift @queue;

    my $shape = $Map->{ $cur->[0] }{ $cur->[1] };
    next unless defined $shape;
    for my $dir ( @{ $move{$shape} } ) {
        my $next = [ $cur->[0] + $dir->[0], $cur->[1] + $dir->[1] ];
        next if $loop{ $next->[0] }{ $next->[1] };
        push @queue,   [ $next->[0], $next->[1] ];
        push @visited, [ $next->[0], $next->[1] ];
        $loop{ $next->[0] }{ $next->[1] }++;
    }
}
my $part1;
my $length = scalar @visited;
if ( $length % 2 == 0 ) {
    $part1 = $length / 2;
} else {
    $part1 = ( $length - 1 ) / 2;    # remove starting location
}

### part 2
my $part2;
for my $row ( sort { $a <=> $b } keys %$Map ) {
    for my $col ( sort { $a <=> $b } keys %{ $Map->{$row} } ) {
        if ( $loop{$row}{$col} ) {
            next;
        }

        # move diagonally +1,+1, counting crossings
        # |,-,F,J count as crossings here, L and 7 do not
        my $crossings = 0;
        my ( $dr, $dc ) = ( 1, 1 );
        while ( $Map->{ $row + $dr }{ $col + $dc } ) {
            if ( $loop{ $row + $dr }{ $col + $dc } ) {
                $crossings++
                    if $Map->{ $row + $dr }{ $col + $dc } =~ m/[FJ\-|]/;
            }

            $dr++;
            $dc++;
        }
        if ( $crossings % 2 != 0 ) {
            $part2++;
        }
    }
}

### FINALIZE - tests and run time

if ( !$testing ) {
    is( $part1, 6815, "Part 1: " . $part1 );
    is( $part2, 269,  "Part 2: " . $part2 );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

=pod

=head3 Day 10: Pipe Maze

=encoding utf8

Toughest puzzle so far this year.

On Sun, I found an ugly brute force but had to put off solving part 2.

On Mon I read up a bit on the theory of how to determine interior
points and implemented that. I also cleaned up my part 1, using a
modified flood-fill algo to "paint" the loop.

Regarding counting crossings, many commentators in the subreddit
pointed out that moving diagonally simplified the logic of when the
loop was crossed.

Score: 2

Leaderboard completion time: 36m31s

=cut
