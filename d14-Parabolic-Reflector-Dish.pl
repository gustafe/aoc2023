#! /usr/bin/env perl
# Advent of Code 2023 Day 14 - Parabolic Reflector Dish - complete solution
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

my $Map;
my $r = 1;
my ( $maxr, $maxc ) = ( 0, 0 );
for my $line (@input) {
    my $c = 1;
    for my $chr ( split( //, $line ) ) {
        $Map->{$r}{$c} = $chr unless $chr eq '.';
        ++$c;
        $maxc = $c if $c > $maxc;
    }
    ++$r;
    $maxr = $r if $r > $maxr;
}
$maxr--;
$maxc--;
die "($maxr x $maxc) is not square!" unless $maxr == $maxc;

my %seen;
my %loads;
my $cycle = 1;
my $part1;
my $cycle_start;
my $cycle_length;
CYCLE: while (1) {
    say "==> $cycle" if $cycle % 10 == 0;
    my $T       = transpose($Map);
    my $shifted = shift_rocks($T);
    my $N       = transpose($shifted);
    if ( $cycle == 1 ) {
        my $sig1 = signature($N);
        $part1 = $sig1->{load};
    }

    my $W    = shift_rocks($N);
    my $WtoS = flipV( transpose($W) );
    $shifted = shift_rocks($WtoS);
    my $S    = transpose( flipV($shifted) );
    my $StoE = flipV($S);
    $shifted = shift_rocks($StoE);
    $Map     = flipV($shifted);

    my $summary = signature($Map);
    my $sig     = join( ',', @{ $summary->{sig} } );

    if ( $seen{$sig} ) {    # we have a repetition
        say "pattern in cycle $cycle seen in " . $seen{$sig};
        $cycle_start  = $seen{$sig};
        $cycle_length = $cycle - $cycle_start;
        say "cycle length is $cycle_length";

        last CYCLE;

    } else {
        $seen{$sig}    = $cycle;
        $loads{$cycle} = $summary->{load};
    }
    if ($testing) {
        say "cycle: $cycle has load: " . $loads{$cycle};
    }
    $cycle++;
}
my $total = 1_000_000_000;
my $rest  = ( $total - $cycle_start ) % $cycle_length;
my $end   = $cycle_start + $rest;
my $part2 = $loads{$end};

### FINALIZE - tests and run time

if ( !$testing ) {
    is( $part1, 112773, "Part 1: $part1" );
    is( $part2, 98894,  "Part 2: $part2" );
} else {
    is( $part1, 136, "Part 1 TEST: $part1" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub signature {
    my ($map) = @_;
    my $sig;
    my $load;
    for my $r ( 1 .. $maxr ) {
        for my $c ( 1 .. $maxc ) {
            if ( $map->{$r}{$c} and $map->{$r}{$c} eq 'O' ) {

                push @$sig, ( $r, $c );
                $load += ( $maxr + 1 - $r );
            }
        }
    }
    return { sig => $sig, load => $load };
}

sub shift_rocks {
    my ($map) = @_;
    my $newMap;
    for my $col ( sort { $a <=> $b } keys %$map ) {
        my $row    = clone $map->{$col};
        my $newrow = clone $row;
        my $lowest = 0;
        for my $p ( sort { $a <=> $b } keys %{$row} ) {
            next unless defined $row->{$p};
            if ( $p <= $lowest ) {
                $lowest = $p;
            } else {
                if ( $row->{$p} ne '#' ) {
                    delete $newrow->{$p};
                    $newrow->{ $lowest + 1 } = $row->{$p};
                    $lowest = $lowest + 1;
                } else {
                    $newrow->{$p} = '#';
                    $lowest = $p;
                }

            }
        }
        $newMap->{$col} = $newrow;
    }
    return $newMap;
}

sub transpose {    # https://perlmaven.com/transpose-a-matrix
    my ($M) = @_;
    my $T;
    for my $r ( 1 .. $maxr ) {
        for my $c ( 1 .. $maxc ) {
            $T->{$c}{$r} = $M->{$r}{$c};
        }
    }
    return $T;
}

sub rotate90 {     # https://stackoverflow.com/a/8664879
    my ($M) = @_;
    my $T = transpose($M);
    my $R;
    for my $r ( 1 .. $maxr ) {
        for my $c ( 1 .. $maxc ) {
            $R->{$r}{ $maxc + 1 - $c } = $T->{$r}{$c} if $T->{$r}{$c};
        }
    }
    return $R;
}

sub flipV {        # flip around horisontal axis, left <-> right
    my ($M) = @_;
    my $F;
    for my $r ( 1 .. $maxr ) {
        for my $c ( 1 .. $maxc ) {
            $F->{$r}{ $maxc + 1 - $c } = $M->{$r}{$c} if $M->{$r}{$c};
        }
    }
    return $F;
}

sub dump_map {
    my ($map) = @_;
    for my $row ( 1 .. $maxr ) {
        for my $col ( 1 .. $maxc ) {
            print $map->{$row}{$col} ? $map->{$row}{$col} : '.';
        }
        print "\n";
    }
    print "\n";
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 14: Parabolic Reflector Dish

=encoding utf8

Scruffy solution but at least I know what's going on. 

Dealing with matrices yesterday helped a bit with this one.

Score: 2

Leaderboard completion time: 17m15s.

=cut
