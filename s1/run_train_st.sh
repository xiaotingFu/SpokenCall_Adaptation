#!/bin/bash
# Scripts for ASR Training for 2nd edition of Spoken Call task
# Xiaoting Fu 2018-10-26
step=2

. ./cmd.sh
. ./path.sh

### parameters (part 1)
nj=15
nj_decode=15
set=10

numLeavesTri1=5000
numGaussTri1=80000
numLeavesTri3=5000
numGaussTri3=80000
numLeavesTri4=5000
numGaussTri4=80000
exp_dir=exp${set}                        # directory for saving models and results
# data_dir=data/sharedTask2nd/st_ihm_all/train${set}
# data_dir=data/sharedTask2nd/st_ihm_all
# data_dir_sub=data/sharedTask2nd/all

data_dir=data/sharedTask2nd/all
test=data/sharedTask2nd_test
lang=data/lang_v1
LM=st${set}.o3g.kn.pr1-7

# you might not want to do this for interactive shells.
set -e
echo "$step"
if [ $step -le 0 ]; then
    ####################################################################################################
    echo '''                        Step 0 : train language model                                    '''
    ####################################################################################################
    # Note: this is an example of training language model. If you want to train your own language model,
    # you can follow this (remember to replace the training text with your own).
    # We have provided our language model, so you can skip this if you want to use our language model.
    local/sharedTask_train_lms.sh $data_dir_sub/text $data_dir_sub/text \
        data/local/dict_v1/lexicon.txt data/local/lm_st${set}.o3g st${set}
    prune-lm --threshold=1e-7 data/local/lm_st${set}.o3g/st${set}.o3g.kn.gz /dev/stdout | gzip -c \
        > data/local/lm_st${set}.o3g/$LM.gz
    utils/format_lm.sh data/lang_v1 data/local/lm_st${set}.o3g/$LM.gz data/local/dict_v1/lexicon.txt data/lang_$LM
fi

if [ $step -le 1 ]; then
    ####################################################################################################
    echo '''                        Step 1 : prepare data and extract features                       '''
    ####################################################################################################
    ## Note: you can skip this if you use our provided features.
    # extract features for training data
    steps/make_mfcc.sh --nj 1 --cmd "$train_cmd" $data_dir $data_dir/log $data_dir/data
    steps/compute_cmvn_stats.sh $data_dir $data_dir/log $data_dir/data
    # extract features for test data
    steps/make_mfcc.sh --nj 1 --cmd "$train_cmd" $test $test/log $test/data
    steps/compute_cmvn_stats.sh $test $test/log $test/data
fi

if [ $step -le 2 ]; then
    ####################################################################################################
    echo '''                        Step 2 : train monophone model                                   '''
    ####################################################################################################
    # train
    steps/train_mono.sh --nj $nj --cmd "$train_cmd" $data_dir $lang ${exp_dir}/mono

    # alignment
    steps/align_si.sh --nj $nj --cmd "$train_cmd" $data_dir $lang ${exp_dir}/mono ${exp_dir}/mono_ali

    # decode, we can skip this if we do not want the decoding result for monophone model
    # graph_dir=${exp_dir}/mono/graph_${LM}
    # $highmem_cmd $graph_dir/mkgraph.log \
    #     utils/mkgraph.sh --mono data/lang_${LM} ${exp_dir}/mono $graph_dir
    # acwt=0.06
    # (steps/decode.sh --nj $nj_decode --cmd "$decode_cmd" --config conf/decode.conf --acwt $acwt\
    #     $graph_dir $test ${exp_dir}/mono/decode_st.test_${LM}_acwt$acwt )&
fi

if [ $step -le 3 ]; then
    ####################################################################################################
    echo '''                        Step 3 : tri1                                                    '''
    ####################################################################################################
    steps/train_deltas.sh --cmd "$train_cmd" $numLeavesTri1 $numGaussTri1 \
        $data_dir $lang ${exp_dir}/mono_ali ${exp_dir}/tri1
    steps/align_si.sh --nj $nj --cmd "$train_cmd" $data_dir $lang ${exp_dir}/tri1 ${exp_dir}/tri1_ali

    # decode, we can skip decoding
#     graph_dir=${exp_dir}/tri1/graph_${LM}
#     $highmem_cmd $graph_dir/mkgraph.log \
#         utils/mkgraph.sh data/lang_${LM} ${exp_dir}/tri1 $graph_dir
#     acwt=0.06
#     (steps/decode.sh --nj $nj_decode --cmd "$decode_cmd" --config conf/decode.conf --acwt $acwt\
#         $graph_dir $test ${exp_dir}/tri1/decode_st.test_${LM}_acwt$acwt )&
# fi

if [ $step -le 4 ]; then
    ####################################################################################################
    echo '''                        Step 4 : tri2                                                    '''
    ####################################################################################################
    steps/train_deltas.sh --cmd "$train_cmd" $numLeavesTri1 $numGaussTri1 \
        $data_dir $lang ${exp_dir}/tri1_ali ${exp_dir}/tri2a
    steps/align_si.sh --nj $nj --cmd "$train_cmd" $data_dir $lang ${exp_dir}/tri2a ${exp_dir}/tri2a_ali

    # decode, we can skip this
    # graph_dir=${exp_dir}/tri2a/graph_${LM}
    # $highmem_cmd $graph_dir/mkgraph.log \
    #     utils/mkgraph.sh data/lang_${LM} ${exp_dir}/tri2a $graph_dir
    # acwt=0.06
    # ( steps/decode.sh --nj $nj_decode --cmd "$decode_cmd" --config conf/decode.conf --acwt $acwt\
    #     $graph_dir $test ${exp_dir}/tri2a/decode_st.test_${LM}_acwt$acwt )&
fi

if [ $step -le 5 ]; then
    ####################################################################################################
    echo '''                        Step 5 : tri3, MLLT+LDA                                          '''
    ####################################################################################################
    steps/train_lda_mllt.sh --cmd "$train_cmd" \
        --splice-opts "--left-context=3 --right-context=3" \
        $numLeavesTri3 $numGaussTri3 $data_dir $lang ${exp_dir}/tri2a_ali ${exp_dir}/tri3a
    # align with SAT
    steps/align_fmllr.sh --nj $nj --cmd "$train_cmd" \
        $data_dir $lang ${exp_dir}/tri3a ${exp_dir}/tri3a_ali

    # decode, we can skip this
    # graph_dir=${exp_dir}/tri3a/graph_${LM}
    # $highmem_cmd $graph_dir/mkgraph.log \
    #     utils/mkgraph.sh data/lang_${LM} ${exp_dir}/tri3a $graph_dir
    # acwt=0.06
    # ( steps/decode.sh --nj $nj_decode --cmd "$decode_cmd" --config conf/decode.conf --acwt $acwt\
    #     $graph_dir $test ${exp_dir}/tri3a/decode_st.test_${LM}_acwt$acwt )&
fi

if [ $step -le 6 ]; then
    ####################################################################################################
    echo '''                        Step 6 : tri4, MLLT+LDA+SAT                                      '''
    ####################################################################################################
    steps/train_sat.sh  --cmd "$train_cmd" \
        $numLeavesTri4 $numGaussTri4 $data_dir $lang ${exp_dir}/tri3a_ali ${exp_dir}/tri4a
    steps/align_fmllr.sh --nj $nj --cmd "$train_cmd" \
        $data_dir $lang ${exp_dir}/tri4a ${exp_dir}/tri4a_ali

    # decode, do not skip making graph  
    graph_dir=${exp_dir}/tri4a/graph_${LM}
    $highmem_cmd $graph_dir/mkgraph.log \
        utils/mkgraph.sh data/lang_${LM} ${exp_dir}/tri4a $graph_dir
    acwt=0.05
    steps/decode_fmllr.sh --nj $nj_decode --cmd "$decode_cmd" --config conf/decode.conf --acwt $acwt\
        $graph_dir $test ${exp_dir}/tri4a/decode_st.test_${LM}_acwt$acwt
fi



if [ $step == 7 ]; then
## parameters (part 2)
parameter for extract fmllr features
gmmdir=${exp_dir}/tri4a
data_fmllr=${exp_dir}/data-fmllr-tri4
graph_dir=$gmmdir/graph_${LM}
# parameter for DNN training
nn_depth=6
hid_dim=1024
train_fmllr=${data_fmllr}/train${set}
train_fmllr_sub=${data_fmllr}/sharedTask/train${set}
#test_fmllr=${data_fmllr}/sharedTask/test${set}
test_fmllr=${data_fmllr}/sharedTask_Test
dbn_dir=${exp_dir}/dnn4_pretrain-dbn_${nn_depth}_${hid_dim}
# parameter for finetuning
dir=${exp_dir}/dnn4_pretrain-dbn_dnn_${nn_depth}_${hid_dim}
ali=${gmmdir}_ali
feature_transform=${dbn_dir}/final.feature_transform
dbn=${dbn_dir}/6.dbn
# parameter for re-train DNN with ST
dbn_re=$dir/final.dbn
dir_re=${dir}_reST
ali_re=${dir}_ali
####################################################################################################
echo '''                        Step 7 : extract fmllr features                                  '''
####################################################################################################
# test set
steps/nnet/make_fmllr_feats.sh --nj $nj_decode --cmd "$train_cmd" \
     --transform-dir $gmmdir/decode_st.test_${LM}_acwt0.05 \
     ${test_fmllr} $test $gmmdir ${test_fmllr}/log ${test_fmllr}/data
# gmm training set
steps/nnet/make_fmllr_feats.sh --nj $nj --cmd "$train_cmd" --transform-dir ${gmmdir}_ali \
     ${train_fmllr} $data_dir $gmmdir ${train_fmllr}/log ${train_fmllr}/data
cp ${data_dir}/text ${train_fmllr}/

# split the data : 90% train 10% cross-validation (held-out)
utils/subset_data_dir_tr_cv.sh $train_fmllr ${train_fmllr}_tr90 ${train_fmllr}_cv10
fi

if [ $step == 8 ]; then
    ####################################################################################################
    echo '''                        Step 8 : train dnn model with tri4a gmm model                    '''
    ####################################################################################################
    # pretrain dbn
    $cuda_cmd ${dbn_dir}/log/pretrain_dbn.log \
        steps/nnet/pretrain_dbn.sh --rbm-iter 1 --nn_depth $nn_depth --hid_dim $hid_dim $train_fmllr ${dbn_dir}
    # train the DNN optimizing per-frame cross-entropy
    $cuda_cmd $dir/log/train_nnet.log \
        steps/nnet/train.sh --feature-transform $feature_transform --dbn $dbn --hid-layers 0 \
        --learn-rate 0.008 ${train_fmllr}_tr90 ${train_fmllr}_cv10 $lang $ali $ali $dir
    # decode
    acwt=0.05
    ( steps/nnet/decode.sh --nj $nj_decode  --use-gpu "yes" --cmd "$cuda_cmd" --config conf/decode_dnn.conf \
    --acwt $acwt $graph_dir $test_fmllr ${dir}/decode_st.test_${LM}_acwt$acwt )&
fi


if [ $step == 9 ]; then
    ####################################################################################################
    echo '''                        Step 9 : align dnn model and prepare for retraining model        '''
    ####################################################################################################
    # align
    steps/nnet/align.sh  --nj $nj --use-gpu "yes" --cmd "$cuda_cmd" ${train_fmllr}_tr90 $lang $dir ${dir}_ali

    # creat a new dbn model from the original dnn model 
    nnet-copy --binary=false $dir/final.nnet $dir/final_txt.nnet
    python dnn2dbn.py $dir/final_txt.nnet $dir/final_txt.dbn
    nnet-copy $dir/final_txt.dbn $dir/final.dbn

    # use only st data to finetune DNN, so split fmllr features to a st subset
    # we can also make fmllr features directly using $data_dir_sub
    utils/subset_data_dir.sh --utt-list data/sharedTask/utt_ids/utt${set}_train $train_fmllr $train_fmllr_sub
fi

if [ $step == 10 ]; then
    ####################################################################################################
    echo '''                        Step 10 : finetune dnn4 with only st data                        '''
    ####################################################################################################
    $cuda_cmd ${dir_re}/log/train_nnet.log \
        steps/nnet/train.sh --feature-transform $feature_transform --dbn $dbn_re --hid-layers 0 \
        --hid-dim ${hid_dim} --learn-rate 0.008 $train_fmllr_sub $train_fmllr_sub $lang $ali_re $ali_re $dir_re
    # decode
    acwt=0.05
    ( steps/nnet/decode.sh --nj $nj_decode  --use-gpu "yes" --cmd "$cuda_cmd" --config conf/decode_dnn.conf \
    --acwt $acwt $graph_dir $test_fmllr ${dir_re}/decode_st.test_${LM}_acwt$acwt )&
fi



