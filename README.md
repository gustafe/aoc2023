# Advent of Code 2023

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the same
directory as the file.

### A note on scoring

I award myself one point per star, but only if I manage to solve it myself without help. 

## TODO

## Solution comments in reverse order

Running score: 6 / 6

### Day 3: Gear Ratios

Ah, the map, a AoC classic. I usually use a hashref for these, and check for existence of cells. In this case we throw away all cells that contain a period anyway, so using an arrayref would be wasteful anyway. So we go through the input line by line, adding characters to the map if it's not a period. 

The main loop is to go through the map. If we find a symbol (non-digit), we look in all 8 directions around it to find something else. My code assumes this will be a digit, and that's the case with my input. 

Once we find a digit, we look left and right around it to find other digits. Once we've found a run of consecutive digits, they're concatenated to a numeral. 

My first issue was that I'd get duplicates. Say we have input like this 

    .......
    ..123..
    ...+...
    456.789
    .......

The numeral 123 will be registered three times. At first I tried to disallow that by only allowing one match per symbol and row, but that made me miss the situation with the 456 and 789 being legal connections but not consecutive. 

So what I finally settled on was adding a second hashref recording the position of every symbol and all numerals connected to it. Then for the summary I looped over that hashref and did the sum for part 1.

This construction made part 2 very easy, I just had to check for asterisk symbols with more than one value attached.

Score: 2

Leaderboard completion time: 11m37s

### Day 2: Cube Conundrum

Not a very hard problem, but I overthought how to parse the input and store it in a datastructure, which caused me a lot of problems in the beginning.

Score: 2

Leaderboard completion time: 6m15s

### Day 1: Trebuchet?!

Well this was a tough one for day 1! I started out ok enough with splitting on a regex, but quickly was stymied by overlaps like twone and oneight. After searching through my input for these I added special cases which found the correct result.

I then peeked in the subreddit for the specific weird-ass syntax required for overlapping matches, and included that as a comment. 

Score: 2

Leaderboard completion time: 7m03s

### Puzzles by difficulty  (leaderboard completion times)

1. Day 03 - Gear Ratios: 11m37s
1. Day 01 - Trebuchet: 7m03s
1. Day 02 - Cube Conundrum: 6m15s

