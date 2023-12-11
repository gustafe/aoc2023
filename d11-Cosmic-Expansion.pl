#! /usr/bin/env perl
use Modern::Perl '2015';
# Advent of Code 2023 Day 11 - Cosmic Expansion - complete solution
# https://adventofcode.com/2023/day/11
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

# useful modules
use List::Util qw/sum any/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
no warnings 'uninitialized';
sub sec_to_hms;

my $start_time = [gettimeofday];
#### INIT - load input data from file into array
my $part2 = shift @ARGV // 0;
if ( !$part2 ) {
    say "Solving part 1, pass a true argument for part 2...";
} else {
    say "Solving part 2...";
}

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
# coordinates are rows (up to down) and cols (left to right). Each is one-based
my $Map;
my ( $maxrow, $maxcol ) = ( 0, 0 );
my $row = 1;

for my $line (@input) {
    my $col = 1;
    for my $char ( split( //, $line ) ) {
        $Map->{$row}{$col} = [ 0, 0 ] unless $char eq '.';
        if ( $col > $maxcol ) {
            $maxcol = $col;
        }
        $col++;
    }
    $row++;
}
$maxrow = $row - 1;

my $offset;
if ( !$part2 ) {
    $offset = 2;
} else {
    $offset = $testing ? 100 : 1_000_000;
}

# EXPAND SPACE
my $seencols;
for my $row ( 1 .. $maxrow ) {

    # any objects were we are ?
    if ( !$Map->{$row} ) {
        say "found empty row at $row" if $testing;
        for my $r ( sort { $a <=> $b } keys %$Map ) {
            next if $r < $row;
            for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {

                # increase offset in r-dir
                $Map->{$r}{$c}[0] += $offset - 1;
            }
        }
    }
}

for my $col ( 1 .. $maxcol ) {

    next if any { defined $_ } map { $Map->{$_}{$col} } ( 1 .. $maxrow );
    say "found empty column at $col" if $testing;
    for my $row ( sort { $a <=> $b } keys %$Map ) {
        for my $c ( sort { $a <=> $b } keys %{ $Map->{$row} } ) {
            next if $c < $col;
            $Map->{$row}{$c}[1] += $offset - 1;
        }
    }

}

say dump $Map if $testing;
my $sum1;
for my $row ( sort { $a <=> $b } keys %$Map ) {
    for my $col ( sort { $a <=> $b } keys %{ $Map->{$row} } ) {

        # find manhattan distance to each other galaxy

        for my $r ( sort { $a <=> $b } keys %$Map ) {
            for my $c ( sort { $a <=> $b } keys %{ $Map->{$r} } ) {
                next if ( $r == $row and $c == $col );
                my $dist = manhattan_distance(
                    [   $row + $Map->{$row}{$col}[0],
                        $col + $Map->{$row}{$col}[1]
                    ],
                    [ $r + $Map->{$r}{$c}[0], $c + $Map->{$r}{$c}[1] ]
                );

                $sum1 += $dist;
            }
        }
    }
}
### FINALIZE - tests and run time
if ($part2) {
    is( $sum1 / 2, 678728808158, "Part 2: " . $sum1 / 2 );
} else {
    is( $sum1 / 2, 10165598, "Part 1: " . $sum1 / 2 );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub manhattan_distance {
    my ( $p, $q ) = (@_);
    return abs( $p->[0] - $q->[0] ) + abs( $p->[1] - $q->[1] );
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 11: Cosmic Expansion

=encoding utf8

I'm proud that my part 1 solution was easily expanded to handle part
2: instead of "physically" expanding the map, I just added an offset
to each galaxy which were stored in a hash. This made changing the
offset from double to 1M trivial.

Score: 2

Leaderboard completion time: 9m18s

=cut
