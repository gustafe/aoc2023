#! /usr/bin/env perl
# Advent of Code 2023 Day 3 - Gear Ratios - complete solution
# https://adventofcode.com/2023/day/3
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################

use Modern::Perl '2015';

# useful modules
use List::Util qw/sum product/;
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
my $row = 1;
for my $line (@input) {
    my @row = split( //, $line );
    my $col = 1;
    for my $c (@row) {
        if ( $c ne '.' ) {
            $Map->{$row}{$col} = $c;
        }
        $col++;
    }
    $row++;
}
my $symbols;

# go through the map, find symbols, and search around them
for my $row ( sort { $a <=> $b } keys %$Map ) {
    for my $col ( sort { $a <=> $b } keys %{ $Map->{$row} } ) {
        if ( $Map->{$row}{$col} !~ m/\d/ ) {

            for my $dr ( -1, 0, 1 ) {
                for my $dc ( -1, 0, 1 ) {
                    next if ( $row + $dr == $row and $col + $dc == $col );
                    if ( exists $Map->{ $row + $dr }{ $col + $dc } ) {
			# check to right and left to find all other digits
                        my $_r     = $row + $dr;
                        my $_c     = $col + $dc;
                        my @digits = $Map->{$_r}{$_c};

                        # search left
                        my $c_left = $_c - 1;
                        while ( defined $Map->{$_r}{$c_left}
                            and $Map->{$_r}{$c_left} =~ /\d/ )
                        {
                            unshift @digits, $Map->{$_r}{$c_left};
                            $c_left--;
                        }
                        my $c_right = $_c + 1;
                        while ( defined $Map->{$_r}{$c_right}
                            and $Map->{$_r}{$c_right} =~ /\d/ )
                        {
                            push @digits, $Map->{$_r}{$c_right};
                            $c_right++;
                        }
                        my $pnum = join( '', @digits );
                        say
                            "$pnum found on row $_r, between $c_left and $c_right, adjacent to $Map->{$row}{$col} on [$row,$col]"
                            if $testing;
                        $symbols->{$row}{$col}{$pnum}++;
                    }
                }
            }
        }
    }
}
my $sum1;
my $sum2;

for my $r ( keys %$symbols ) {
    for my $c ( keys %{ $symbols->{$r} } ) {
        $sum1 += sum keys %{ $symbols->{$r}{$c} };

        # find gears
        if ( $Map->{$r}{$c} eq '*'
            and scalar keys %{ $symbols->{$r}{$c} } > 1 )
        {
            $sum2 += product keys %{ $symbols->{$r}{$c} };
        }
    }
}

### FINALIZE - tests and run time
is( $sum1, 539433,   "Part 1: $sum1" );
is( $sum2, 75847567, "Part 2: $sum2" );
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

=head3 Day 3: Gear Ratios

=encoding utf8

Ah, the map, a AoC classic. I usually use a hashref for these, and
check for existence of cells. In this case we throw away all cells
that contain a period anyway, so using an arrayref would be
wasteful. So we go through the input line by line, adding characters
to the map if it's not a period.

The main loop for part 1 is to go through the completed map. If we
find a symbol (non-digit), we look in all 8 directions around it to
find something else. My code assumes this will be a digit, and that's
the case with my input.

Once we find a digit, we look left and right around it to find other
digits. Once we've found a run of consecutive digits, they're
concatenated to a numeral.

My first issue was that I'd get duplicates. Say we have input like this 

    .......
    ..123..
    ...+...
    456.789
    .......

The numeral 123 will be registered three times. At first I tried to
disallow that by only allowing one match per symbol and row, but that
made me miss the situation with the 456 and 789 being legal
connections but not consecutive.

So what I finally settled on was adding a second hashref recording the
position of every symbol and all numerals connected to it. Using the
numeral as a key ensured there was only going to be one unique numeral
in that position. Then for the summary I looped over that hashref and
did the sum for part 1.

This construction made part 2 very easy, I just had to check for
asterisk symbols with more than one value attached, and sum their
products.

Score: 2

Leaderboard completion time: 11m37s

=cut

