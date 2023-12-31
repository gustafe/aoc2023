# Advent of Code 2023

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the same
directory as the file.

### A note on scoring

I award myself one point per star, but only if I manage to solve it myself without help. 

## TODO

- Day 12
- Day 17
- Day 19, part 2
- Day 20 
- Day 21
- Day 22
- Day 23
- Day 24, part 2
- Day 25

## Solution comments in reverse order

Running score: 34 / 50

### Day 25: Snowverload

TODO

Score: 0

Leaderboard completion time: 14m01s

### Day 24: Never Tell Me The Odds

Part 1 for now, simple linear equations

TODO: Part 2

Score: 1

Leaderboard completion time: 1h02m10s

### Day 23: A Long Walk

TODO

Score: 0

Leaderboard completion time: 38m20s

### Day 22: Sand Slabs

TODO

Score: 0

Leaderboard completion time: 29m38s

### Day 21: Step Counter

Hardest problem of the year so far, gonna look at it later maybe. TODO.

Score: 0

Leaderboard completion time: 1h19m03s

### Day 20: Pulse Propagation

TODO

Score: 0

Leaderboard completion time: 48m46s

### Day 19: Aplenty

Part one only for now. 

TODO: Part 2

Score: 1

Leaderboard completion time: 29m12s

### Day 18: Lavaduct Lagoon

This was a fun one. Part 1 was basically interior point finding like
in Day 10, but I struggled to get it to work with the "shapes"
involved. Finally got an answer... and realized part 2 was gonna be a
whole different ballgame.

But I'd head about the Shoelace formula when studying Day 10, and when
I saw people referencing it I used that, along with parts of Pick's
theorem to get the correct values.

Score: 2

Leaderboard completion time: 20m55s

### Day 17: Clumsy Crucible

I have to give this a pass for now because of prior commitments. 

TODO

Score: 0

Leaderboard completion time: 20m00s

### Day 16: The Floor Will Be Lava

My first solution to part one used a counter to detect loops, which gave each entry point a runtime of about 30s. I quickly realized it would take 2hrs to bruteforce this, but I had a Christmas tree to deal with so I just set it to run. After about 50% I noticed the number of energized cells wasn't changing, so I just put that in as the part 2 answer and it was accepted! 

Obviously this wasn't general enough so I coded up a better loop detection. Now the entire brute force runs in 30s...

Incidentally for my input part 2 was for the very next row, but from the opposite direction... 

Score: 2

Leaderboard completion time: 15m30s

### Day 15: Lens Library

Not the most complex of puzzles, once I figured out the key text in
part 2: "The result of running the HASH algorithm on the label
indicates the correct box for that step".

I used a hashref internally for each box, for ease of lookup when
replacing lenses. This made adding lenses a bit more complex, but not
overly so. I had a lot of issues getting the hashref _out_ when
adding the focusing, so the code looks gnarly there.

Score: 2

Leaderboard completion time: 11m04s.

### Day 14: Parabolic Reflector Dish

Scruffy solution but at least I know what's going on. 

Dealing with matrices yesterday helped a bit with this one.

Score: 2

Leaderboard completion time: 17m15s.

### Day 13: Point of Incidence

This wasn't my favorite puzzle of the year, but I managed a solution
with a little help from the functions in 2020D20.

Score: 2

Leaderboard completion time: 13m46s

### Day 12: TODO Hot Springs

Punting on this puzzle for now. 

Score: 0

Leaderboard completion time: 22m57s

### Day 11: Cosmic Expansion

I'm proud that my part 1 solution was easily expanded to handle part
2: instead of "physically" expanding the map, I just added an offset
to each galaxy which were stored in a hash. This made changing the
offset from double to 1M trivial.

Score: 2

Leaderboard completion time: 9m18s

### Day 10: Pipe Maze

Toughest puzzle so far this year.

On Sun, I found an ugly brute force but had to put off solving part 2.

On Mon I read up a bit on the theory of how to determine interior
points and implemented that. I also cleaned up my part 1, using a
modified flood-fill algo to "paint" the loop.

Regarding counting crossings, many commentators in the subreddit
pointed out that moving diagonally simplified the logic of when the
loop was crossed.

Score: 2

Leaderboard completion time: 36m31s

### Day 9: Mirage Maintenance

Remarkably easy, especially considering it's a weekend problem. I
suspect we'll see more of this tomorrow.

Score: 2

Leaderboard completion time: 5m36s

### Day 8: Haunted Wasteland

Not the most difficult of puzzles. I realized after letting my first
naive stab at part 2 run for 10 minutes that There Had To Be A Better
Way. The obvious next step was to find the least common multiple of
each different "A to Z" path. I was a bit worried that the path
lengths would not be the same with each repetition, but either the
puzzle input assured that, or there's some math reason they're always
the same.

The LCD calculation is from the most excellent `ntheory` module.

Score: 2

Leaderboard completion time: 10m16s

### Day 7: Camel Cards

This was a fun problem, which played to Perl's strengths.

My first attempt was to get a nice sorting pipeline where I could just
add the list of hands and it would first sort by type, and then by
value. But I couldn't really get that to work with input from an array
of hashes, so I switched over to determining the type first and having
that as subkey in the hashref. This made it easier to sort.

Part 2 presented some problems, but bruteforcing all possible
combinations of joker replacements was not hard at all. I had to deal
with the special case `JJJJJ` separately.

Score: 2

Leaderboard completion time: 16m00s

### Day 6: Wait For It

Mood for this year sure is whiplash. This was easy. Even accounting for the brute-force nature of part 2, runtime is around 20s. 

I could sit down and try to dick around with solutions to the quadratic equation, but I'm pretty sure fencepost errors would creep in and I'd spend more time troubleshooting those. 

Score: 2

Leaderboard completion time: 5m02s

### Day 5: If You Give A Seed A Fertilizer

I solved both parts after thinking about it for a while.

I had the right idea from the start for part 2, which was handling
ranges of integers instead of arrays. But I got lost in the weeds
trying to get my iterations to to work. Studying some other solutions
put me on the right track.

This solution supersedes my earlier part 1, which can be dredged from
the repo is one wishes to see it.

Score: 2

Leaderboard completion time: 26m37s

### Day 4: Scratchcards

The first attempt at part 2 was literally just implement the instructions in code: I had an array of cards, I picked the first, and depending on that card's wins and its position in the list, I prepended the cloned cards to the front of the array. 

This _worked_ in the sense that I got the correct answer, but it took 5s and a huge array. 

After thinking for a bit I realized it was more efficient to simply store the number of cloned cards in an array whose indices were the card ID. Much faster.

Previous solution: [commit 39daebc](https://github.com/gustafe/aoc2023/blob/39daebc7a744b33b355da831f7f16b21605ccb75/d04-Scratchcards.pl)

Score: 2

Leaderboard completion time: 7m08s

### Day 3: Gear Ratios

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

1. Day 21 - TODO Step Counter: 1h19m03s
1. Day 24 - Never Tell Me The Odds 1: 1h02m10s
1. Day 20 - TODO Pulse Propagation: 48m46s
1. Day 23 - TODO A Long Walk: 38m20s
1. Day 10 - Pipe Maze: 36m31s
1. Day 22 - TODO Sand Slabs: 29m38s
1. Day 19 - Aplenty 1: 29m12s
1. Day 05 - If You Give A Seed A Fertilizer: 26m37s
1. Day 12 - TODO Hot Springs: 22m57s
1. Day 18 - Lavaduct Lagoon: 20m55s
1. Day 17 - TODO Clumsy Crucible: 20m00s
1. Day 14 - Parabolic Reflector Dish: 17m15s.
1. Day 07 - Camel Cards: 16m00s
1. Day 16 - The Floor Will Be Lava: 15m30s
1. Day 25 - TODO Snowverload: 14m01s
1. Day 13 - Point of Incidence: 13m46s
1. Day 03 - Gear Ratios: 11m37s
1. Day 15 - Lens Library: 11m04s.
1. Day 08 - Haunted Wasteland: 10m16s
1. Day 11 - Cosmic Expansion: 9m18s
1. Day 04 - Scratchcards: 7m08s
1. Day 01 - Trebuchet: 7m03s
1. Day 02 - Cube Conundrum: 6m15s
1. Day 09 - Mirage Maintenance: 5m36s
1. Day 06 - Wait For It: 5m02s

