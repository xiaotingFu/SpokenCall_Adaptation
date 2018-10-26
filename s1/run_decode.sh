#!/bin/bash

# This script is used to decode for the JJJ ASR system.
# Mengjie Qian, 2017-9-16

# The JJJ ASR system uses the fmllr features, so we first need to decode_fmllr,
# then make fmllr features, and finally we could decode use the DNN model.

. ./cmd.sh
. ./path.sh

##########################################################################################
echo ''                        Step 1 : prepare data                                    ''
##########################################################################################
# Prepare files for the test data, see details in http://kaldi-asr.org/doc/data_prep.html .
# For decoding, we need to create at least 3 files (wav.scp, utt2spk, spk2utt).
# If we have transcriptions and want to get the word error rate, we also need to creat text.
# wav.scp:
#        - format: <recording-id> <extended-filename>
#        - example: 3570 /home/mxq486/dataset/speechProcessing_test/3570.wav
# utt2spk:
#        - format: <utterance-id> <speaker-id>
# spk2utt:
#        - format: <speaker-id> <utterance-id1> <utterance-id2> ....
#        - how to create: utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
# text:
#        - format:  <utterance-id> <transcription of the sentence> 


##########################################################################################
echo ''                        Step 2 : extract features                                ''
##########################################################################################
test_dir=data/test # directory of the test data
steps/make_mfcc.sh --nj 1 --cmd "$train_cmd" $test_dir $test_dir/log $test_dir/data
steps/compute_cmvn_stats.sh $test_dir $test_dir/log $test_dir/data


##########################################################################################
echo ''                        Step 3 : decode fmllr                                    ''
##########################################################################################
# Decode fMLLR on tri4a model.
graph_dir=exp/tri4a/graph_st10.o3g.kn.pr1-7
acwt=0.05

# option 1: decode without transcription, we cannot get word error rate
steps/decode_fmllr.sh --nj 1 --cmd "$decode_cmd" --skip-scoring true --config conf/decode.conf \
    --acwt $acwt $graph_dir $test_dir exp/tri4a/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

## option 2: decode with transcription, we can get word error rate
#steps/decode_fmllr.sh --nj 1 --cmd "$decode_cmd" --skip-scoring true --config conf/decode.conf \
#    --acwt $acwt $graph_dir $test_dir exp/tri4a/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

##########################################################################################
echo ''                        Step 4 : extract fmllr features                          ''
##########################################################################################
gmm_dir=exp/tri4a
test_fmllr=exp/data-fmllr-tri4/test
steps/nnet/make_fmllr_feats.sh --nj 1 --cmd "$train_cmd" \
    --transform-dir ${gmm_dir}/decode_test_st10.o3g.kn.pr1-7_acwt$acwt \
     $test_fmllr $test_dir $gmm_dir ${test_fmllr}/log ${test_fmllr}/data


##########################################################################################
echo ''                        Step 5 : decode on dnn4 retrained model                  ''
##########################################################################################
dir_re=exp/dnn4_pretrain-dbn_dnn_6_1024_reST_max20
acwt=0.05

# You can decode with or without gpu, and decode with or without the true transcription
# option 1: decode with gpu, without the true transcription
steps/nnet/decode_notext.sh --nj 1 --use-gpu "yes" --cmd "$cuda_cmd" \
    --scoring-opts "--min-lmwt 25 --max-lmwt 25" --config conf/decode_dnn.conf \
    --acwt $acwt $graph_dir $test_fmllr ${dir_re}/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

## option 2: decode without gpu, without the true transcription
#steps/nnet/decode_notext.sh --nj 1 --use-gpu "no" --cmd "$decode_cmd" \
#    --scoring-opts "--min-lmwt 25 --max-lmwt 25" --config conf/decode_dnn.conf \
#    --acwt $acwt $graph_dir $test_fmllr ${dir_re}/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

## option 3: decode with gpu, with the true transcription
#steps/nnet/decode_text.sh --nj 1 --use-gpu "yes" --cmd "$cuda_cmd" \
#    --scoring-opts "--min-lmwt 15 --max-lmwt 50" --config conf/decode_dnn.conf \
#    --acwt $acwt $graph_dir $test_fmllr ${dir_re}/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

## option 4: decode without gpu, with the true transcription
#steps/nnet/decode_text.sh --nj 1 --use-gpu "no" --cmd "$decode_cmd" \
#    --scoring-opts "--min-lmwt 15 --max-lmwt 30" --config conf/decode_dnn.conf \
#    --acwt $acwt $graph_dir $test_fmllr ${dir_re}/decode_test_st10.o3g.kn.pr1-7_acwt$acwt

