#! /usr/bin/env perl
# Advent of Code 2023 Day 18 - Lavaduct Lagoon - complete solution
# https://adventofcode.com/2023/day/18
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
my $part2   = shift @ARGV // 0;
if ( !$part2 ) {
    say "solving part 1, pass a true argument to solve part 2...";
} else {
    say "solving part 2...";
}
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %moves = (
    L => [ 0,  -1 ],
    R => [ 0,  1 ],
    U => [ 1,  0 ],
    D => [ -1, 0 ],
    0 => 'R',
    1 => 'D',
    2 => 'L',
    3 => 'U',
);

my @instr;
for my $line (@input) {
    my ( $dir, $step, $color ) = split( /\s+/, $line );

    #    say "$dir $step $color" if $testing;
    if ($part2) {
        $color =~ s/[\#\(\)]//g;
        my ( $hex, $d ) = $color =~ m/(.....)(.)/;
#        say "\#$color = " . $moves{$d} . ' ' . hex($hex);
        push @instr, { dir => $moves{$d}, step => hex($hex) };
    } else {
        push @instr, { dir => $dir, step => $step, color => $color };
    }

}

my $Map;

my @coords = ( [ 0, 0 ] );
#my ( $maxr, $maxc ) = ( 0,    0 );
#my ( $minr, $minc ) = ( 1000, 1000 );
my $ditch = 0;
while (@instr) {
    my $in   = shift @instr;
    my $dir  = $moves{ $in->{dir} };
    my $step = $in->{step};
    my $cur  = $coords[-1];
    push @coords,
        [ $cur->[0] + $step * $dir->[0], $cur->[1] + $step * $dir->[1] ];
    $ditch += $step;
}


# Shoelace algo - https://en.wikipedia.org/wiki/Shoelace_formula
my $interior;
for my $idx ( 0 .. $#coords - 1 ) {
    my $p1 = $coords[$idx];
    my $p2 = $coords[ $idx + 1 ];

    # determinant
    $interior += ( $p1->[0] * $p2->[1] ) - ( $p1->[1] * $p2->[0] );
}


# Pick's theorem states that the area of a polygon is A = i + b/2 -1,
# where i is the interior integer points and b the number of points on
# the border

# in this case we know the interior points from the shoelace above,
# and we've added up the boundary ditch points, so we need to add 1 to
# get the total area

my $ans = $ditch / 2 + $interior / 2 + 1;

if ($part2) {
    is( $ans, 97874103749720, "Part 2: $ans" );
} else {
    is( $ans, 36725, "Part 1: $ans" );
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

=head3 Day 18: Lavaduct Lagoon

=encoding utf8

This was a fun one. Part 1 was basically interior point finding like
in Day 10, but I struggled to get it to work with the "shapes"
involved. Finally got an answer... and realized part 2 was gonna be a
whole different ballgame.

But I'd head about the Shoelace formula when studying Day 10, and when
I saw people referencing it I used that, along with parts of Pick's
theorem to get the correct values.

Score: 2

Leaderboard completion time: 20m55s

=cut
