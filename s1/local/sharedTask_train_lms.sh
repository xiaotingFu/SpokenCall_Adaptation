#!/bin/bash

# Copyright 2013  Arnab Ghoshal, Pawel Swietojanski

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
# WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
# MERCHANTABLITY OR NON-INFRINGEMENT.
# See the Apache 2 License for the specific language governing permissions and
# limitations under the License.

# To be run from one directory above this script.

# Begin configuration section.
fisher=
order=3
swbd=
google=
web_sw=
web_fsh=
web_mtg=
# end configuration sections

help_message="Usage: "`basename $0`" [options] <train-txt> <dev-txt> <dict> <out-dir>
Train language models for AMI and optionally for Switchboard, Fisher and web-data from University of Washington.\n
options: 
  --help          # print this message and exit
  --fisher DIR    # directory for Fisher transcripts
  --order N       # N-gram order (default: '$order')
  --swbd DIR      # Directory for Switchboard transcripts 
  --web-sw FILE   # University of Washington (191M) Switchboard web data
  --web-fsh FILE  # University of Washington (525M) Fisher web data
  --web-mtg FILE  # University of Washington (150M) CMU+ICSI+NIST meeting data
";

. utils/parse_options.sh

if [ $# -ne 5 ]; then
  printf "$help_message\n";
  exit 1;
fi

train=$1    # eg. data/sharedTask/test_not0/text
dev=$2      # eg. data/sharedTask/test0/text
lexicon=$3  # eg. data/local/dict/lexicon.txt
dir=$4      # eg. data/local_st/lm_no0
mix_tag=$5  # eg. st0

for f in "$text" "$lexicon"; do
  [ ! -f $x ] && echo "$0: No such file $f" && exit 1;
done

set -o errexit
mkdir -p $dir
export LC_ALL=C 

mix_ppl="$dir/ppl2"
#mix_tag="st0"
mix_lms=( "$dir/${mix_tag}.o${order}g.kn.gz" )
num_lms=1

cut -d' ' -f2- $train | gzip -c > $dir/train.gz
cut -d' ' -f2- $dev | gzip -c > $dir/dev.gz

awk '{print $1}' $lexicon | sort -u > $dir/wordlist.lex
gunzip -c $dir/train.gz | tr ' ' '\n' | grep -v ^$ | sort -u > $dir/wordlist.train
sort -u $dir/wordlist.lex $dir/wordlist.train > $dir/wordlist

ngram-count -text $dir/train.gz -order $order -limit-vocab -vocab $dir/wordlist \
  -unk -map-unk "<UNK>" -kndiscount -interpolate -lm $dir/${mix_tag}.o${order}g.kn.gz
echo "PPL for SharedTask LM:"
ngram -unk -lm $dir/${mix_tag}.o${order}g.kn.gz -ppl $dir/dev.gz
ngram -unk -lm $dir/${mix_tag}.o${order}g.kn.gz -ppl $dir/dev.gz -debug 2 >& $dir/ppl2

if [ $num_lms -gt 1  ]; then
  echo "Computing interpolation weights from: $mix_ppl"
  compute-best-mix $mix_ppl >& $dir/mix.log
  grep 'best lambda' $dir/mix.log \
    | perl -e '$_=<>; s/.*\(//; s/\).*//; @A = split; for $i (@A) {print "$i\n";}' \
    > $dir/mix.weights
  weights=( `cat $dir/mix.weights` )
  cmd="ngram -lm ${mix_lms[0]} -lambda 0.715759 -mix-lm ${mix_lms[1]}"
  for i in `seq 2 $((num_lms-1))`; do
    cmd="$cmd -mix-lm${i} ${mix_lms[$i]} -mix-lambda${i} ${weights[$i]}"
  done
  cmd="$cmd -unk -write-lm $dir/${mix_tag}.o${order}g.kn.gz"
  echo "Interpolating LMs with command: \"$cmd\""
  $cmd
  echo "PPL for the interolated LM:"
  ngram -unk -lm $dir/${mix_tag}.o${order}g.kn.gz -ppl $dir/dev.gz
fi

#save the lm name for furher use
echo "${mix_tag}.o${order}g.kn" > $dir/final_lm

