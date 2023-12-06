#! /usr/bin/env perl
# Advent of Code 2023 Day 6 - Wait For It - complete solution
# https://adventofcode.com/2023/day/6
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
my ( @times, @distances );
for my $line (@input) {
    if ( $line =~ m/^Time/ ) {
        @times = ( $line =~ m/(\d+)/g );
    } else {
        @distances = ( $line =~ m/(\d+)/g );
    }
}

my @parts = (
    { times => \@times, distances => \@distances },
    {   times     => [ join( '', @times ) ],
        distances => [ join( '', @distances ) ]
    }
);

my @ans;
my $p = 1;
for my $part (@parts) {
    my @ways_to_win;
    say "Part$p times: " . join( ',', @{ $part->{times} } );
    say "Part$p dists: " . join( ',', @{ $part->{distances} } );
    for my $idx ( 0 .. scalar( @{ $part->{times} } ) - 1 ) {
        my $total = $part->{times}[$idx];
        for my $b ( 1 .. $total - 1 ) {
            my $travel_time = $total - $b;
            my $dist        = $b * $travel_time;
            if ( $dist > $part->{distances}[$idx] ) {
                $ways_to_win[$idx]++;
            }
        }
    }
    say "Part$p answer: " . product @ways_to_win;
    push @ans, product @ways_to_win;
    $p++;

}
### FINALIZE - tests and run time
is( $ans[0], 2065338,  "Part 1: " . $ans[0] );
is( $ans[1], 34934171, "Part 2: " . $ans[1] );
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

=head3 Day 6: Wait For It

=encoding utf8

Mood for this year sure is whiplash. This was easy. Even accounting for the brute-force nature of part 2, runtime is around 20s. 

I could sit down and try to dick around with solutions to the quadratic equation, but I'm pretty sure fencepost errors would creep in and I'd spend more time troubleshooting those. 

Score: 2

Leaderboard completion time: 5m02s

=cut
