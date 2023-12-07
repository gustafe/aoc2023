# How to extract the leaderboard stats from Advent of Code

Use these commands to download the daily leaderboard times for the individual days of Advent of Code.

```
rm stats.txt

for y in `seq 2015 2022`
do
  for d in `seq 1 25`
  do
    echo -n "${y} " >> stats.txt
    lynx -dump https://adventofcode.com/${y}/leaderboard/day/${d} | grep '100)' | head -1 >> stats.txt
  done
done

cut -d' ' -f1,7,8 stats.txt  > summary.txt
```
