#! /usr/bin/env perl
# Advent of Code 2023 Day 9 - Mirage Maintenance - complete solution
# https://adventofcode.com/2023/day/9
# https://gerikson.com/files/AoC2023/UNLICENSE
###########################################################
use Modern::Perl '2015';

# useful modules
use List::Util qw/sum all/;
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
my $Seqs;
for my $line (@input) {
    my @seq = split( /\s+/, $line );
    push @$Seqs, \@seq;
}
my $sum1;
my $sum2;
for my $el (@$Seqs) {
    my @differences = ($el);
    my $exit        = 0;
DIFF: while ( !$exit ) {
        my @curr = @{ $differences[-1] };
        my @next;
        for ( my $i = 0; $i < $#curr; $i++ ) {
            $next[$i] = $curr[ $i + 1 ] - $curr[$i];
        }
        if ( all { $_ == 0 } @next ) {
            $exit++;
        }
        push @differences, \@next;
        last DIFF if $exit;
    }
    my $pnt = $#differences;
    while ( $pnt > 0 ) {
        my $next_last = $differences[ $pnt - 1 ][-1] + $differences[$pnt][-1];
        my $next_first = $differences[ $pnt - 1 ][0] - $differences[$pnt][0];
        push @{ $differences[ $pnt - 1 ] }, $next_last;
        unshift @{ $differences[ $pnt - 1 ] }, $next_first;
        $pnt--;
    }
    say join( ' ', @{ $differences[0] } ) if $testing;
    $sum1 += $differences[0][-1];
    $sum2 += $differences[0][0];
}

### FINALIZE - tests and run time
is( $sum1, 1995001648, "Part 1: $sum1" );
is( $sum2, 988,        "Part 2: $sum2" );
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

=head3 Day 9: Mirage Maintenance

=encoding utf8

Remarkably easy, especially considering it's a weekend problem. I
suspect we'll see more of this tomorrow.

Score: 2

Leaderboard completion time: 5m36s

=cut
