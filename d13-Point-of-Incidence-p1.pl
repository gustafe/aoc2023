#! /usr/bin/env perl
# Advent of Code 2023 Day 13 - Point of Incidence - part 1 
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
my $r = 0;
for my $l (@input) {
    if (length $l ==0) {
	$field++;
	$r=0;
	next;
	
    }
    my $c=0;
    for my $chr (split(//,$l)) {
	$Data{$field}->{h}->[$r][$c] = $chr;
	$Data{$field}->{v}->[$c][$r] = $chr;
	$c++;
    }
    $r++;
}
say dump \%Data if $testing;
# say scalar keys %Data;
my $sum1;
for my $k (sort {$a<=>$b} keys %Data) {
 #   say "==> $k";
    for my $scan ('h','v') {
	my @area = @{$Data{$k}->{$scan}};
#	dump_map(\@area);

	my $cols = scalar @area;
	my $maxval =0;
	for my $line (1..$#area ) {
	    my $up = $line-1;
	    my $down=$line;
	    my $match=0;
	    WIDEN: while ($up>=0 and $down<=$#area) {
		$match = join('',@{$area[$up]}) eq join('',@{$area[$down]});
		last WIDEN unless $match;
		--$up;
		++$down;
	    }
	    $maxval = $line if $match;
	}
	if ($maxval) {
#	    say "$scan: found reflection on $maxval" if $maxval;
	    $sum1 += ( $scan eq 'h' ? 100 : 1 ) * $maxval ;
	}
    }

}
say $sum1;
### FINALIZE - tests and run time
is($sum1,30487 ,"Part 1: $sum1");

done_testing();
say sec_to_hms(tv_interval($start_time));

### SUBS
sub dump_map {
    my ($map) =@_;
    my %pat;
    my $idx=0;
    for my $el (@$map) {
	my $line = join('',@$el);
	printf("%2d %s\n", $idx, $line);
	push @{$pat{$line}}, $idx;
	$idx++
    }
    say "---";
    for my $p (sort keys %pat) {
	say "$p ". join(',',@{$pat{$p}});
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

Scruffy part 1 for now, part 2 is eluding me for now.

TODO: part 2

Score: 1

Leaderboard completion time: 13m46s

=cut
