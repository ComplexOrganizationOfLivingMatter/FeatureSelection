#/bin/sh
ls | while read f; do wc -l $f >> "numNodes$1.csv"; done