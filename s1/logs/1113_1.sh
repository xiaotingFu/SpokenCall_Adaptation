step: 1
                        Step 1 : prepare data and extract features                       
Extract feature for training data
steps/make_mfcc.sh --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/all data/sharedTask2nd/all/log data/sharedTask2nd/all/data
steps/make_mfcc.sh: moving data/sharedTask2nd/all/feats.scp to data/sharedTask2nd/all/.backup
steps/make_mfcc.sh: [info]: no segments file exists: assuming wav.scp indexed by utterance.
Succeeded creating MFCC features for all
steps/compute_cmvn_stats.sh data/sharedTask2nd/all data/sharedTask2nd/all/log data/sharedTask2nd/all/data
Succeeded creating CMVN stats for all
Extract feature for testing data
steps/make_mfcc.sh --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd_test data/sharedTask2nd_test/log data/sharedTask2nd_test/data
steps/make_mfcc.sh: moving data/sharedTask2nd_test/feats.scp to data/sharedTask2nd_test/.backup
steps/make_mfcc.sh: [info]: no segments file exists: assuming wav.scp indexed by utterance.
Succeeded creating MFCC features for sharedTask2nd_test
steps/compute_cmvn_stats.sh data/sharedTask2nd_test data/sharedTask2nd_test/log data/sharedTask2nd_test/data
Succeeded creating CMVN stats for sharedTask2nd_test
Finished Feature extraction
                        Step 2 : train monophone model                                   
utils/subset_data_dir.sh: reducing #utt from 12914 to 5000
steps/train_mono.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/train_5k data/lang_v1 exp6/mono
steps/train_mono.sh: Initializing monophone system.
steps/train_mono.sh: Compiling training graphs
steps/train_mono.sh: Aligning data equally (pass 0)
steps/train_mono.sh: Pass 1
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 2
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 3
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 4
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 5
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 6
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 7
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 8
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 9
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 10
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 11
steps/train_mono.sh: Pass 12
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 13
steps/train_mono.sh: Pass 14
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 15
steps/train_mono.sh: Pass 16
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 17
steps/train_mono.sh: Pass 18
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 19
steps/train_mono.sh: Pass 20
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 21
steps/train_mono.sh: Pass 22
steps/train_mono.sh: Pass 23
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 24
steps/train_mono.sh: Pass 25
steps/train_mono.sh: Pass 26
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 27
steps/train_mono.sh: Pass 28
steps/train_mono.sh: Pass 29
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 30
steps/train_mono.sh: Pass 31
steps/train_mono.sh: Pass 32
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 33
steps/train_mono.sh: Pass 34
steps/train_mono.sh: Pass 35
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 36
steps/train_mono.sh: Pass 37
steps/train_mono.sh: Pass 38
steps/train_mono.sh: Aligning data
steps/train_mono.sh: Pass 39
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/mono
steps/diagnostic/analyze_alignments.sh: see stats in exp6/mono/log/analyze_alignments.log
2943 warnings in exp6/mono/log/align.*.*.log
523 warnings in exp6/mono/log/update.*.log
8 warnings in exp6/mono/log/acc.*.*.log
exp6/mono: nj=30 align prob=-101.55 over 4.53h [retry=0.4%, fail=0.0%] states=137 gauss=981
steps/train_mono.sh: Done training monophone system in exp6/mono

real	6m30.347s
user	80m30.487s
sys	2m9.993s
steps/align_si.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/train_5k data/lang_v1 exp6/mono exp6/mono_ali
steps/align_si.sh: feature type is delta
steps/align_si.sh: aligning data in data/sharedTask2nd/train_5k using model from exp6/mono, putting alignments in exp6/mono_ali
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/mono_ali
steps/diagnostic/analyze_alignments.sh: see stats in exp6/mono_ali/log/analyze_alignments.log
steps/align_si.sh: done aligning data.

real	0m18.432s
user	4m5.598s
sys	0m5.379s
Decode MonoPhone Model
tree-info exp6/mono/tree 
tree-info exp6/mono/tree 
fstpushspecial 
fstminimizeencoded 
fsttablecompose data/lang_st6.o3g.kn.pr1-7/L_disambig.fst data/lang_st6.o3g.kn.pr1-7/G.fst 
fstdeterminizestar --use-log=true 
fstisstochastic data/lang_st6.o3g.kn.pr1-7/tmp/LG.fst 
-0.0646043 -0.0654925
[info]: LG not stochastic.
fstcomposecontext --context-size=1 --central-position=0 --read-disambig-syms=data/lang_st6.o3g.kn.pr1-7/phones/disambig.int --write-disambig-syms=data/lang_st6.o3g.kn.pr1-7/tmp/disambig_ilabels_1_0.int data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_1_0.21897 
fstisstochastic data/lang_st6.o3g.kn.pr1-7/tmp/CLG_1_0.fst 
-0.0646043 -0.0654925
[info]: CLG not stochastic.
make-h-transducer --disambig-syms-out=exp6/mono/graph_st6.o3g.kn.pr1-7/disambig_tid.int --transition-scale=1.0 data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_1_0 exp6/mono/tree exp6/mono/final.mdl 
fsttablecompose exp6/mono/graph_st6.o3g.kn.pr1-7/Ha.fst data/lang_st6.o3g.kn.pr1-7/tmp/CLG_1_0.fst 
fstdeterminizestar --use-log=true 
fstminimizeencoded 
fstrmsymbols exp6/mono/graph_st6.o3g.kn.pr1-7/disambig_tid.int 
fstrmepslocal 
fstisstochastic exp6/mono/graph_st6.o3g.kn.pr1-7/HCLGa.fst 
0.000203312 -0.124458
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp6/mono/final.mdl 

real	0m30.103s
user	0m30.634s
sys	0m0.878s
steps/decode.sh --nj 30 --cmd run.pl --mem 20G --skip-scoring false --config conf/decode.conf --acwt 0.06 exp6/mono/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/mono/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
decode.sh: feature type is delta
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/mono/graph_st6.o3g.kn.pr1-7 exp6/mono/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/diagnostic/analyze_lats.sh: see stats in exp6/mono/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_alignments.log
Overall, lattice depth (10,50,90-percentile)=(1,4,52) and mean=22.7
steps/diagnostic/analyze_lats.sh: see stats in exp6/mono/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_lattice_depth_stats.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/mono/graph_st6.o3g.kn.pr1-7 exp6/mono/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0

real	4m38.227s
user	46m23.131s
sys	0m21.076s
