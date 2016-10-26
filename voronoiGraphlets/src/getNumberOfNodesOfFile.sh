#/bin/sh
ls | while read f; do cat "$f, " >> "numNodes$1.csv;" wc -l "$f" >> "numNodes$1.csv"; cat "\n" >> "numNodes$1.csv"; done