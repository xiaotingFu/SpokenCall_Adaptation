#!/bin/bash

. ./cmd.sh
. ./path.sh

nj=15
nj_decode=15
set=10

numLeavesTri1=5000
numGaussTri1=80000
numLeavesTri3=5000
numGaussTri3=80000
numLeavesTri4=5000
numGaussTri4=80000
exp_dir=exp${set}

data_dir=data/sharedTask2nd/all
test=data/sharedTask2nd_test
lang=data/lang_v1
LM=st${set}.o3g.kn.pr1-7

steps/train_deltas.sh --cmd "$train_cmd" $numLeavesTri1 $numGaussTri1 \
        $data_dir $lang ${exp_dir}/mono_ali ${exp_dir}/tri1
    steps/align_si.sh --nj $nj --cmd "$train_cmd" $data_dir $lang ${exp_dir}/tri1 ${exp_dir}/tri1_ali
