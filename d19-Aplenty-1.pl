#! /usr/bin/env perl
# Advent of Code 2023 Day 19 - Aplenty - part 1
# https://adventofcode.com/2023/day/19
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
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

my %Rules;
my @parts;
### CODE
for my $line (@input) {
    if ( $line =~ m/^{(x.*)}$/ ) {
        my $part;
        for my $cmp ( split( /,/, $1 ) ) {
            my ( $id, $val ) = ( $cmp =~ m/([xmas])\=(\d+)/ );
            $part->{$id} = $val;
        }
        $part->{dst} = 'in';
        push @parts, $part;

    } elsif ( $line =~ m/^(\S+)\{(.*)\}$/ ) {
        my $rulename = $1;
        my $rules;
        for my $crit ( split( /,/, $2 ) ) {
            if ( $crit =~ m/([xmas])([<>])(\d+):(\S+)/ ) {
                push @$rules, { id => $1, cmp => $2, val => $3, dst => $4 };
            } else {
                push @$rules, { dst => $crit };
            }

        }
        $Rules{$rulename} = $rules;

    }
}

my @accepted;
my @rejected;

while (@parts) {
    my $part = shift @parts;
    dump $part if $testing;
    my $new_dst = sort_part( $part, $part->{dst} );
    say $new_dst if $testing;
    $part->{dst} = $new_dst;
    if ( $new_dst eq 'A' ) {
        push @accepted, $part;
    } elsif ( $new_dst eq 'R' ) {
        push @rejected, $part;
    } else {
        push @parts, $part;
    }
}
my $sum1;
for my $part (@accepted) {
    for my $id ( 'x', 'm', 'a', 's' ) {
        $sum1 += $part->{$id};
    }
}
say $sum1;
### FINALIZE - tests and run time
is( $sum1, 352052, "Part 1: $sum1" );
done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub sort_part {
    my ( $part, $dst ) = @_;
    for my $rule ( @{ $Rules{$dst} } ) {
        if ( $rule->{id} ) {
            my $pval = $part->{ $rule->{id} };
            if ( $rule->{cmp} eq '<' ) {
                if ( $pval < $rule->{val} ) {
                    return $rule->{dst};
                }
            } elsif ( $rule->{cmp} eq '>' ) {
                if ( $pval > $rule->{val} ) {
                    return $rule->{dst};
                }
            }
        } else {
            return $rule->{dst};
        }
    }
    die "no rule match for rule $dst and part " . dump $part;
}

sub sec_to_hms {
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 19: Aplenty

=encoding utf8

Part one only for now. 

TODO: Part 2

Score: 1

Leaderboard completion time: 29m12s

=cut
