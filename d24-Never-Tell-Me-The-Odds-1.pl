# Advent of Code 2023 Day 23 - Never Tell Me The Odds - part 1
# https://adventofcode.com/2023/day/22
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################
#! /usr/bin/env perl
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
my $Data;
my $id = 1;
for my $line (@input) {
    my ( $pos, $vel ) = split( /@/, $line );
    @{ $Data->{$id}{pos} } = $pos =~ m/(-?\d+)/g;
    @{ $Data->{$id}{vel} } = $vel =~ m/(-?\d+)/g;
    $id++;
}
dump $Data if $testing;
my ( $minx, $miny, $maxx, $maxy )
    = $testing
    ? ( 7, 7, 27, 27 )
    : ( 200000000000000, 200000000000000, 400000000000000, 400000000000000 );

### Part 1

my $seen;
my $count;
for my $id ( sort { $a <=> $b } keys %$Data ) {
    for my $id2 ( sort { $a <=> $b } keys %$Data ) {
        next if $id == $id2;
        next if $seen->{$id}{$id2};
        my $in1 = $Data->{$id};
        my $in2 = $Data->{$id2};
        my $P   = intersection2d( $in1, $in2 );

        unless ( defined $P->[0] and defined $P->[1] ) {
            next;
        }
        my ( $x1, $y1 ) = @{ $in1->{pos} }[ 0, 1 ];
        my ( $x2, $y2 ) = @{ $in2->{pos} }[ 0, 1 ];
        my ( $dx1, $dy1 ) = ( $P->[0] - $x1, $P->[1] - $y1 );
        my ( $dx2, $dy2 ) = ( $P->[0] - $x2, $P->[1] - $y2 );

        # check that direction vectors are the same for the original
        # velocity and the meeting points

        if (    ( $dx1 * $in1->{vel}[0] > 0 and $dy1 * $in1->{vel}[1] > 0 )
            and ( $dx2 * $in2->{vel}[0] > 0 and $dy2 * $in2->{vel}[1] > 0 ) )
        {
            say "meeting in the future" if $testing;
            if (    $P->[0] >= $minx
                and $P->[0] <= $maxx
                and $P->[1] >= $miny
                and $P->[1] <= $maxy )
            {
                say "$id $id2: inside meeting area!" if $testing;
                $count++;

            } else {
                say "outside meeting area" if $testing;
            }

        } else {
            say "meeting in the past" if $testing;
        }

        $seen->{$id2}{$id}++;
    }
}
say $count;

### FINALIZE - tests and run time
is($count,11246, "Part 1: $count");
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub intersection2d {
    my ( $set1, $set2 ) = @_;

# point-slope equation is
# y = y_1 + k(x-x_1), k = dy/dx <=> y = kx+(y_1-k*x_1)
# https://en.wikipedia.org/wiki/Linear_equation#Point%E2%80%93slope_form_or_Point-gradient_form
# intercept between 2 lines y=ax + c and y=bx + d is:
# P = ( (d-c)/(a-b) , a*((d-c)/(a-b))+c )
# https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_line_equations
    
    my $k1 = $set1->{vel}[1] / $set1->{vel}[0];
    my ( $x1, $y1 ) = @{ $set1->{pos} }[ 0, 1 ];
    my $k2 = $set2->{vel}[1] / $set2->{vel}[0];
    my ( $x2, $y2 ) = @{ $set2->{pos} }[ 0, 1 ];

    my $a = $k1;
    my $b = $k2;
    my $c = $y1 - $k1 * $x1;
    my $d = $y2 - $k2 * $x2;
    if ( $a == $b ) {
        return [ undef, undef ];
    } else {
        return [
            ( $d - $c ) / ( $a - $b ),
            $a * ( ( $d - $c ) / ( $a - $b ) ) + $c
        ];
    }

}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 24: Never Tell Me The Odds

=encoding utf8

Part 1 for now, simple linear equations

TODO: Part 2

Score: 1

Leaderboard completion time: 1h02m10s

=cut
