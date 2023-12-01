#! /usr/bin/env perl
# Advent of Code 2023 Day 1 - Trebuchet?! - complete solution
# https://adventofcode.com/2023/day/1
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
my $file = $testing ? 'test2.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %translate = (
    one   => 1,
    two   => 2,
    three => 3,
    four  => 4,
    five  => 5,
    six   => 6,
    seven => 7,
    eight => 8,
    nine  => 9,
);

for my $n ( 1 .. 9 ) {
    $translate{$n} = $n;
}


my $sum  = 0;
my $sum2 = 0;
for my $line (@input) {
    say $line if $testing;

    # part 1
    my @digits = grep {/\d{1}/} ( split( //, $line ) );
    my $val    = $digits[0] . $digits[-1];
    $sum += $val;

    # part 2

    # this is my first attempt, which works for my input and solved
    # part 2. It required me to manually search for overlaps (like
    # twone, eightwo etc). My input did not contain some combinations
    # like sevenine. A better regex is:

    # m/(?=(\d{1}|one|two|three|four|five|six|seven|eight|nine))/g

    my @spelled
        = ( $line
            =~ m/(\d{1}|oneight|one|twone|two|three|four|five|six|seven|eightwo|eight|nine)/g
        );

    say join( '|', @spelled ) if $testing;

    # special cases as per above

    if ( $spelled[0] eq 'twone' )    { $spelled[0]  = 2 }
    if ( $spelled[-1] eq 'twone' )   { $spelled[-1] = 1 }
    if ( $spelled[0] eq 'oneight' )  { $spelled[0]  = 1 }
    if ( $spelled[-1] eq 'oneight' ) { $spelled[-1] = 8 }
    if ( $spelled[0] eq 'eightwo' )  { $spelled[0]  = 8 }
    if ( $spelled[-1] eq 'eightwo' ) { $spelled[-1] = 2 }

    my $val2 = $translate{ $spelled[0] } . $translate{ $spelled[-1] };

    say $val2 if $testing;

    $sum2 += $val2;

}
say $sum2;

### FINALIZE - tests and run time
is( $sum,  54573, "Part 1: $sum" );
is( $sum2, 54591, "Part 2: $sum2" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS
sub sec_to_hms {
    my ($s) = @_;
    return sprintf(
        "Duration: %02dh%02dm%02ds (%.3f ms)",
        int( $s / (3600) ),
        ( $s / 60 ) % 60,
        $s % 60, $s * 1000
    );
}

###########################################################

=pod

=head3 Day 1: Trebuchet?!

=encoding utf8

Well this was a tough one for day 1! I started out ok enough with splitting on a regex, but quickly was stymied by overlaps like twone and oneight. After searching through my input for these I added special cases which found the correct result.

I then peeked in the subreddit for the specific weird-ass syntax required for overlapping matches, and included that as a comment. 

Score: 2

Leaderboard completion time: 7m03s

=cut
