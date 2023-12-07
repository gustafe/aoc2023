#! /usr/bin/env perl
# Advent of Code 2023 Day 7 - Camel Cards - complete solution
# https://adventofcode.com/2023/day/7
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

my $part2 = shift @ARGV // 0;
if ($part2) {
    say "solving part 2...";
} else {
    say "solving part 1, pass a true value to choose part 2...";

}

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %Hands;

for my $line (@input) {
    my ( $hand, $bid ) = split( /\s+/, $line );

    $Hands{$hand}{bid} = $bid;
    if ( $part2 and $hand =~ /J/ ) {
	
        # special case
        if ( $hand eq 'JJJJJ' ) {
            $Hands{$hand}{type} = '1_five_of_a_kind';
            next;
        }
	# we want to replace every other possible card with a joker, get the type, and choose the highest ranking type
	my %replacements;
        for my $card ( split( //, '23456789TQKA' ) ) {
            next unless $hand =~ /$card/;
	    # /r does not overwrite the original value 
            my $newhand = $hand =~ s/J/$card/gr;

            $replacements{$newhand} = get_type($newhand);
        }
	# choose the first element
        my $replacement_type = ( sort values %replacements )[0];

        $Hands{$hand}{type} = $replacement_type;
    } else {
        $Hands{$hand}{type} = get_type($hand);
    }
}

# Our algo will only work correctly if each hand is unique! They are
# in my input

die "WARNING duplicate hand in input!"
    unless scalar( keys %Hands ) == scalar @input;

my $rank = 1;
my $sum;

# sort by type, then by values in the hand
for my $hand (
    reverse sort {
        $Hands{$a}->{type} cmp $Hands{$b}->{type} || compare_hand( $a, $b )
    } keys %Hands
    )
{
    $sum += $rank * $Hands{$hand}->{bid};
    $rank++;
}

### FINALIZE - tests and run time
if ( !$part2 ) {
    is( $sum, 250347426, "Part 1: $sum" );

} else {
    is( $sum, 251224870, "Part 2: $sum" );
}

done_testing();
say sec_to_hms( tv_interval($start_time) );

### SUBS

sub get_type {
    # given a hand, determine its type. Return the type as an
    # alphanumeric value with a numeral in the first position,
    # followed by a plaintext tag.

    # 1_five_of_a_kind
    # 2_four_of_a_kind
    # 3_full_house
    # 4_three_of_a_kind
    # 5_two_pair
    # 6_one_pair
    # 7_high_card
    
    my ($hand) = @_;
    my %labels;

    for my $f ( split( //, $hand ) ) {
        $labels{$f}++;
    }

    if ( keys %labels == 5 ) {    # all different values, high card
        return '7_high_card';
    }
    if ( keys %labels == 1 ) {    # just one value, five of a kind
        return '1_five_of_a_kind';
    }
    if ( keys %labels == 4 ) {    # two of the same value, 1 pair
        return '6_one_pair';
    }
    if ( keys %labels == 2 ) { # either four of a kind, or full house
	# how are the labels distributed?
        my @num = sort { $b <=> $a } map { $labels{$_} } keys %labels;
        if ( $num[0] == 4 and $num[1] == 1 ) {
            return '2_four_of_a_kind';
        } elsif ( $num[0] == 3 and $num[1] == 2 ) {
            return '3_full_house';
        }
    }
    if ( keys %labels == 3 ) { # either tree of a kind, or two pair
        my @num = sort { $b <=> $a } map { $labels{$_} } keys %labels;
        if ( $num[0] == 3 ) {
            return '4_three_of_a_kind';
        }
        if ( $num[0] == 2 and $num[0] == 2 ) {
            return '5_two_pair';
        }
    }
    return undef;
}

sub compare_hand {
    # given 2 strings, compare them to each other according to the
    # Camel Card rules. Used as a custom sort function

    my $values = '23456789TJQKA';
    $values = 'J23456789TQKA' if $part2;
    my %card_order;
    my $o = 1;
    for my $c ( reverse split( //, $values ) ) {
        $card_order{$c} = $o;
        $o++;
    }
    my @a = split( //, $a );
    my @b = split( //, $b );
    for my $idx ( 0 .. $#a ) {
        next if $a[$idx] eq $b[$idx];
        if ( $card_order{ $a[$idx] } < $card_order{ $b[$idx] } ) {
            return -1;
        } elsif ( $card_order{ $a[$idx] } > $card_order{ $b[$idx] } ) {
            return 1;
        }
    }
    return 0;
}

sub sec_to_hms {  
    my ($s) = @_;
    return sprintf("Duration: %02dh%02dm%02ds (%.3f ms)",
    int( $s/(3600) ), ($s/60) % 60, $s % 60, $s * 1000 );
}

###########################################################

=pod

=head3 Day 7: Camel Cards

=encoding utf8

This was a fun problem, which played to Perl's strengths.

My first attempt was to get a nice sorting pipeline where I could just
add the list of hands and it would first sort by type, and then by
value. But I couldn't really get that to work with input from an array
of hashes, so I switched over to determining the type first and having
that as subkey in the hashref. This made it easier to sort.

Part 2 presented some problems, but bruteforcing all possible
combinations of joker replacements was not hard at all. I had to deal
with the special case C<JJJJJ> separately.

Score: 2

Leaderboard completion time: 16m00s

=cut
