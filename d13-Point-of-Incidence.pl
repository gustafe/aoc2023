#! /usr/bin/env perl
# Advent of Code 2023 Day 13 - Point of Incidence - complete solution
# https://adventofcode.com/2023/day/13
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum min max all/;
use Data::Dump qw/dump/;
use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;
use Clone qw/clone/;
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
my %Data;
my $field = 1;
my $r     = 0;
for my $l (@input) {
    if ( length $l == 0 ) {
        $field++;
        $r = 0;
        next;

    }
    my $c = 0;
    for my $chr ( split( //, $l ) ) {
        $Data{$field}->[$r][$c] = $chr;
        $c++;
    }
    $r++;
}
say dump \%Data if $testing;
my $sum1;
my $sum2;
for my $k ( sort { $a <=> $b } keys %Data ) {
    say "==> area $k";
    my $area = $Data{$k};
    dump_map($area) if $testing;
    my $rot = rotate90($area);
    dump_map($rot) if $testing;
    my %p1;
    my $hval = find_reflection($area);

    # we can get multiple answers back, in part 1, the answer should
    # always be a single value (or zero)
    if ( @$hval and scalar @$hval == 1 ) {
        $p1{'h'} = $hval->[0];
        $sum1 += 100 * $p1{h};
    }
    my $vval = find_reflection($rot);
    if ( @$vval and scalar @$vval == 1 ) {
        $p1{'v'} = $vval->[0];
        $sum1 += $p1{v};
    }

    my %p2;

    # for every cell in the current area, flip it to the opposite,
    # then check reflections in horizontal and vertical directions
    for my $r ( 0 .. scalar @$area - 1 ) {
        for my $c ( 0 .. scalar @{ $area->[0] } - 1 ) {
            my $new = clone $area;
            if ( $area->[$r][$c] eq '#' ) {
                $new->[$r][$c] = '.';
            } else {
                $new->[$r][$c] = '#';
            }

            my $newr = rotate90($new);
            my $h    = find_reflection($new);
            my $v    = find_reflection($newr);

            # store the answers (can be multiple for each iteration)
            # in a hash for later comparison
            if (@$h) {
                for my $el (@$h) {
                    $p2{h}->{$el}++;
                }
            }
            if (@$v) {
                for my $el (@$v) {
                    $p2{v}->{$el}++;
                }
            }

        }

    }

    # after checking every position for smudges, do we have any new
    # reflections?
    for my $scan (qw/ h v /) {

        if ( $p1{$scan} and $p2{$scan} ) {    # new reflection to replace old
            delete $p2{$scan}->{ $p1{$scan} };
        }

        my $val = ( keys %{ $p2{$scan} } )[0];
        $sum2 += ( $scan eq 'h' ? 100 : 1 ) * $val;
    }
}
### FINALIZE - tests and run time
is( $sum1, 30487, "Part 1: $sum1" );
is( $sum2, 31954, "Part 2: $sum2" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub transpose {
    my ($M) = @_;
    my $T;
    for my $r ( 0 .. scalar @$M - 1 ) {
        for my $c ( 0 .. scalar @{ $M->[$r] } - 1 ) {
            $T->[$c][$r] = $M->[$r][$c];
        }
    }
    return $T;
}

sub rotate90 {
    my ($M) = @_;
    my $T = transpose($M);
    my $R;
    for my $r ( 0 .. scalar @$T - 1 ) {
        push @$R, [ reverse @{ $T->[$r] } ];
    }
    return $R;
}

sub find_reflection {
    my ($map)  = @_;
    my $cols   = scalar @$map;
    my $maxval = [];
    for my $line ( 1 .. scalar @$map - 1 ) {
        my $up    = $line - 1;
        my $down  = $line;
        my $match = 0;
        say "$line --" if $testing;
    WIDEN: while ( $up >= 0 and $down <= scalar @$map - 1 ) {
            if ($testing) {

                say "u $up: " . join( '', @{ $map->[$up] } );
                say "d $down: " . join( '', @{ $map->[$down] } );
            }
            $match = join( '', @{ $map->[$up] } ) eq
                join( '', @{ $map->[$down] } );
            last WIDEN unless $match;
            --$up;
            ++$down;
        }
        push @$maxval, $line if $match;

    }
    return $maxval;
}

sub dump_map {
    my ($map) = @_;
    my %pat;
    my $idx = 0;
    for my $el (@$map) {
        my $line = join( '', @$el );
        printf( "%s %2d\n", $line, $idx );
        push @{ $pat{$line} }, $idx;
        $idx++;
    }

    say '';
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 13: Point of Incidence

=encoding utf8

This wasn't my favorite puzzle of the year, but I managed a solution
with a little help from the functions in 2020D20.

Score: 2

Leaderboard completion time: 13m46s

=cut
