#!/bin/bash -x

#####################################################################
# SUMMARY: Test unnormalized tokens corresponding to normalized tokens are as expected
# AUTHOR: jerinphilip
# TAGS: sentencepiece
#####################################################################


# Exit on error
set -e

VOCAB_FILE=$MRT_MODELS/student-eten/vocab.spm
test -f $VOCAB_FILE
LC_ALL=C $MRT_MARIAN/test_sentencepiece_norm -v $VOCAB_FILE \
    < encodePreservingSource.in \
    > encodePreservingSource.out

diff -bsq encodePreservingSource.out encodePreservingSource.expected
exit $?
        

