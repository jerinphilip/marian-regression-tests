#!/bin/bash

# Exit on error
set -e

# Test code goes here
rm -rf sqlite sqlite.log
mkdir -p sqlite

$MRT_MARIAN/build/marian \
    --seed 1111 --no-shuffle --maxi-batch 1 --maxi-batch-sort none --max-length 100 \
    -m sqlite/model.npz -t train.1k.{de,en} -v vocab.{de,en}.yml \
    --log sqlite.log --disp-freq 1 --after-batches 100 --mini-batch 1 \
    --data-weighting train.1k.weights.txt --data-weighting-type sentence --sqlite sqlite/corpus.sqlite3

test -e sqlite/model.npz
test -e sqlite/corpus.sqlite3
test -e sqlite.log

cat sqlite.log | $MRT_TOOLS/extract-costs.sh > sqlite.out

$MRT_TOOLS/diff-floats.py sqlite.out sqlite.expected -p 0.3 > sqlite.diff

# Exit with success code
exit 0
