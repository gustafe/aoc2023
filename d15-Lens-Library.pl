#! /usr/bin/env perl
# Advent of Code 2023 Day 15 - Lens Library - complete solution
# https://adventofcode.com/2023/day/15
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum/;
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
my @codes = split( /,/, $input[0] );
my $sum1;
for my $code (@codes) {
    $sum1 += myhash($code);
}

# part 2

# array of hashrefs, keys are lens labels, values are lens number and
# position
my $Boxes;
for my $code (@codes) {
    say $code if $testing;
    my $box;
    if ( $code =~ /^(.*)\=(\d+)$/ ) {
        my $label  = $1;
        my $number = $2;
        $box = myhash($label);
        say "add $number to box $box" if $testing;
        my $lenses = clone $Boxes->[$box];
        if ( exists $lenses->{$label} ) {
            $lenses->{$label}{num} = $number;
        } else {

            # add to the end of the set of lenses
            my $maxpos = 0;
            for my $id ( keys %$lenses ) {
                $maxpos = $lenses->{$id}{pos}
                    if $lenses->{$id}{pos} > $maxpos;
            }
            $lenses->{$label} = { num => $number, pos => $maxpos + 1 };
        }

        # replace box contents
        $Boxes->[$box] = $lenses;

    } elsif ( $code =~ /^(.*)\-$/ ) {
        my $label = $1;
        $box = myhash($label);
        say "remove a lens from box $box" if $testing;
        my $lenses = clone $Boxes->[$box];
        if ( exists $lenses->{$label} ) {
            delete $lenses->{$label};
            $Boxes->[$box] = $lenses;
        } else {

            # noop
        }

    } else {
        die "could not parse $code";

    }
}
dump $Boxes if $testing;

# add the focusing powers
my $sum2;
for my $idx ( 0 .. scalar @$Boxes - 1 ) {
    my $fac1 = $idx + 1;
    my $slot = 1;

    # sort by lens position, update slot number
    for my $lens (
        sort { $Boxes->[$idx]{$a}{pos} <=> $Boxes->[$idx]{$b}{pos} }
        keys %{ $Boxes->[$idx] } )
    {
        my $fac2 = $slot;
        my $fac3 = $Boxes->[$idx]{$lens}{num};
        $sum2 += $fac1 * $fac2 * $fac3;
        $slot++;
    }

}

### FINALIZE - tests and run time
if ( !$testing ) {
    is( $sum1, 507291, "Part 1: $sum1" );
    is( $sum2, 296921, "Part 2: $sum2" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub myhash {
    my ($str) = @_;
    my $curr = 0;
    for my $chr ( split( //, $str ) ) {
        $curr += ord($chr);
        $curr *= 17;
        $curr %= 256;
    }
    return $curr;
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 15: Lens Library

=encoding utf8

Not the most complex of puzzles, once I figured out the key text in
part 2: "The result of running the HASH algorithm on the label
indicates the correct box for that step".

I used a hashref internally for each box, for ease of lookup when
replacing lenses. This made adding lenses a bit more complex, but not
overly so. I had a lot of issues getting the hashref I<out> when
adding the focusing, so the code looks gnarly there.

Score: 2

Leaderboard completion time: 11m04s.

=cut
