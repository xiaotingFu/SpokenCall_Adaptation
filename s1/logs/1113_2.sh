step: 3
                        Step 3 : tri1                                                    
steps/train_deltas.sh --boost-silence 1.25 --cmd run.pl --mem 20G 5000 80000 data/sharedTask2nd/all data/lang_v1 exp6/mono_ali exp6/tri1
steps/train_deltas.sh: accumulating tree stats
steps/train_deltas.sh: getting questions for tree-building, via clustering
steps/train_deltas.sh: building the tree
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 1 with no stats; corresponding phone list: 6 7 8 9 10 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 2 with no stats; corresponding phone list: 11 12 13 14 15 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 42 with no stats; corresponding phone list: 173 174 175 176 
** The warnings above about 'no stats' generally mean you have phones **
** (or groups of phones) in your phone set that had no corresponding data. **
** You should probably figure out whether something went wrong, **
** or whether your data just doesn't happen to have examples of those **
** phones. **
steps/train_deltas.sh: converting alignments from exp6/mono_ali to use current tree
steps/train_deltas.sh: compiling graphs of transcripts
steps/train_deltas.sh: training pass 1
steps/train_deltas.sh: training pass 2
steps/train_deltas.sh: training pass 3
steps/train_deltas.sh: training pass 4
steps/train_deltas.sh: training pass 5
steps/train_deltas.sh: training pass 6
steps/train_deltas.sh: training pass 7
steps/train_deltas.sh: training pass 8
steps/train_deltas.sh: training pass 9
steps/train_deltas.sh: training pass 10
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 11
steps/train_deltas.sh: training pass 12
steps/train_deltas.sh: training pass 13
steps/train_deltas.sh: training pass 14
steps/train_deltas.sh: training pass 15
steps/train_deltas.sh: training pass 16
steps/train_deltas.sh: training pass 17
steps/train_deltas.sh: training pass 18
steps/train_deltas.sh: training pass 19
steps/train_deltas.sh: training pass 20
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 21
steps/train_deltas.sh: training pass 22
steps/train_deltas.sh: training pass 23
steps/train_deltas.sh: training pass 24
steps/train_deltas.sh: training pass 25
steps/train_deltas.sh: training pass 26
steps/train_deltas.sh: training pass 27
steps/train_deltas.sh: training pass 28
steps/train_deltas.sh: training pass 29
steps/train_deltas.sh: training pass 30
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 31
steps/train_deltas.sh: training pass 32
steps/train_deltas.sh: training pass 33
steps/train_deltas.sh: training pass 34
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri1
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri1/log/analyze_alignments.log
3 warnings in exp6/tri1/log/questions.log
62 warnings in exp6/tri1/log/init_model.log
3 warnings in exp6/tri1/log/build_tree.log
71556 warnings in exp6/tri1/log/acc.*.*.log
254 warnings in exp6/tri1/log/align.*.*.log
858 warnings in exp6/tri1/log/update.*.log
exp6/tri1: nj=30 align prob=-97.24 over 11.68h [retry=0.1%, fail=0.0%] states=1169 gauss=80181 tree-impr=3.20
steps/train_deltas.sh: Done training system with delta+delta-delta features in exp6/tri1

real	16m10.690s
user	149m53.069s
sys	6m1.456s
steps/align_si.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/all data/lang_v1 exp6/tri1 exp6/tri1_ali
steps/align_si.sh: feature type is delta
steps/align_si.sh: aligning data in data/sharedTask2nd/all using model from exp6/tri1, putting alignments in exp6/tri1_ali
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri1_ali
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri1_ali/log/analyze_alignments.log
steps/align_si.sh: done aligning data.
tree-info exp6/tri1/tree 
tree-info exp6/tri1/tree 
fstcomposecontext --context-size=3 --central-position=1 --read-disambig-syms=data/lang_st6.o3g.kn.pr1-7/phones/disambig.int --write-disambig-syms=data/lang_st6.o3g.kn.pr1-7/tmp/disambig_ilabels_3_1.int data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_3_1.26067 
fstisstochastic data/lang_st6.o3g.kn.pr1-7/tmp/CLG_3_1.fst 
0 -0.0654925
[info]: CLG not stochastic.
make-h-transducer --disambig-syms-out=exp6/tri1/graph_st6.o3g.kn.pr1-7/disambig_tid.int --transition-scale=1.0 data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_3_1 exp6/tri1/tree exp6/tri1/final.mdl 
fstrmsymbols exp6/tri1/graph_st6.o3g.kn.pr1-7/disambig_tid.int 
fstdeterminizestar --use-log=true 
fstminimizeencoded 
fsttablecompose exp6/tri1/graph_st6.o3g.kn.pr1-7/Ha.fst data/lang_st6.o3g.kn.pr1-7/tmp/CLG_3_1.fst 
fstrmepslocal 
fstisstochastic exp6/tri1/graph_st6.o3g.kn.pr1-7/HCLGa.fst 
0.000487826 -0.182015
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp6/tri1/final.mdl 
                        Step 4 : tri2                                                    
steps/decode.sh --nj 30 --cmd run.pl --mem 20G --config conf/decode.conf --acwt 0.06 exp6/tri1/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/tri1/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/train_deltas.sh --boost-silence 1.25 --cmd run.pl --mem 20G 5000 80000 data/sharedTask2nd/all data/lang_v1 exp6/tri1_ali exp6/tri2a
decode.sh: feature type is delta
steps/train_deltas.sh: accumulating tree stats
steps/train_deltas.sh: getting questions for tree-building, via clustering
steps/train_deltas.sh: building the tree
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 1 with no stats; corresponding phone list: 6 7 8 9 10 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 2 with no stats; corresponding phone list: 11 12 13 14 15 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 42 with no stats; corresponding phone list: 173 174 175 176 
** The warnings above about 'no stats' generally mean you have phones **
** (or groups of phones) in your phone set that had no corresponding data. **
** You should probably figure out whether something went wrong, **
** or whether your data just doesn't happen to have examples of those **
** phones. **
steps/train_deltas.sh: converting alignments from exp6/tri1_ali to use current tree
steps/train_deltas.sh: compiling graphs of transcripts
steps/train_deltas.sh: training pass 1
steps/train_deltas.sh: training pass 2
steps/train_deltas.sh: training pass 3
steps/train_deltas.sh: training pass 4
steps/train_deltas.sh: training pass 5
steps/train_deltas.sh: training pass 6
steps/train_deltas.sh: training pass 7
steps/train_deltas.sh: training pass 8
steps/train_deltas.sh: training pass 9
steps/train_deltas.sh: training pass 10
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 11
steps/train_deltas.sh: training pass 12
steps/train_deltas.sh: training pass 13
steps/train_deltas.sh: training pass 14
steps/train_deltas.sh: training pass 15
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/tri1/graph_st6.o3g.kn.pr1-7 exp6/tri1/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri1/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_alignments.log
Overall, lattice depth (10,50,90-percentile)=(1,2,21) and mean=9.7
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri1/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_lattice_depth_stats.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/tri1/graph_st6.o3g.kn.pr1-7 exp6/tri1/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0
steps/train_deltas.sh: training pass 16
steps/train_deltas.sh: training pass 17
steps/train_deltas.sh: training pass 18
steps/train_deltas.sh: training pass 19
steps/train_deltas.sh: training pass 20
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 21
steps/train_deltas.sh: training pass 22
steps/train_deltas.sh: training pass 23
steps/train_deltas.sh: training pass 24
steps/train_deltas.sh: training pass 25
steps/train_deltas.sh: training pass 26
steps/train_deltas.sh: training pass 27
steps/train_deltas.sh: training pass 28
steps/train_deltas.sh: training pass 29
steps/train_deltas.sh: training pass 30
steps/train_deltas.sh: aligning data
steps/train_deltas.sh: training pass 31
steps/train_deltas.sh: training pass 32
steps/train_deltas.sh: training pass 33
steps/train_deltas.sh: training pass 34
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri2a
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 79.44091683444324% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri2a/log/analyze_alignments.log
149 warnings in exp6/tri2a/log/align.*.*.log
117 warnings in exp6/tri2a/log/init_model.log
3 warnings in exp6/tri2a/log/questions.log
1 warnings in exp6/tri2a/log/analyze_alignments.log
945 warnings in exp6/tri2a/log/update.*.log
18 warnings in exp6/tri2a/log/acc.*.*.log
3 warnings in exp6/tri2a/log/build_tree.log
exp6/tri2a: nj=30 align prob=-97.28 over 11.68h [retry=0.1%, fail=0.0%] states=2377 gauss=80210 tree-impr=3.30
steps/train_deltas.sh: Done training system with delta+delta-delta features in exp6/tri2a

real	15m50.853s
user	161m39.765s
sys	6m24.474s
steps/align_si.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/all data/lang_v1 exp6/tri2a exp6/tri2a_ali
steps/align_si.sh: feature type is delta
steps/align_si.sh: aligning data in data/sharedTask2nd/all using model from exp6/tri2a, putting alignments in exp6/tri2a_ali
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri2a_ali
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 79.38671209540034% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri2a_ali/log/analyze_alignments.log
steps/align_si.sh: done aligning data.
tree-info exp6/tri2a/tree 
tree-info exp6/tri2a/tree 
make-h-transducer --disambig-syms-out=exp6/tri2a/graph_st6.o3g.kn.pr1-7/disambig_tid.int --transition-scale=1.0 data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_3_1 exp6/tri2a/tree exp6/tri2a/final.mdl 
fstdeterminizestar --use-log=true 
fstminimizeencoded 
fstrmepslocal 
fsttablecompose exp6/tri2a/graph_st6.o3g.kn.pr1-7/Ha.fst data/lang_st6.o3g.kn.pr1-7/tmp/CLG_3_1.fst 
fstrmsymbols exp6/tri2a/graph_st6.o3g.kn.pr1-7/disambig_tid.int 
fstisstochastic exp6/tri2a/graph_st6.o3g.kn.pr1-7/HCLGa.fst 
0.000487633 -0.182052
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp6/tri2a/final.mdl 
                        Step 5 : tri3, MLLT+LDA                                          
steps/decode.sh --nj 30 --cmd run.pl --mem 20G --config conf/decode.conf --acwt 0.06 exp6/tri2a/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/tri2a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/train_lda_mllt.sh --boost-silence 1.25 --cmd run.pl --mem 20G --splice-opts --left-context=3 --right-context=3 5000 80000 data/sharedTask2nd/all data/lang_v1 exp6/tri2a_ali exp6/tri3a
decode.sh: feature type is delta
steps/train_lda_mllt.sh: Accumulating LDA statistics.
steps/train_lda_mllt.sh: Accumulating tree stats
steps/train_lda_mllt.sh: Getting questions for tree clustering.
steps/train_lda_mllt.sh: Building the tree
steps/train_lda_mllt.sh: Initializing the model
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 1 with no stats; corresponding phone list: 6 7 8 9 10 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 2 with no stats; corresponding phone list: 11 12 13 14 15 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 42 with no stats; corresponding phone list: 173 174 175 176 
This is a bad warning.
steps/train_lda_mllt.sh: Converting alignments from exp6/tri2a_ali to use current tree
steps/train_lda_mllt.sh: Compiling graphs of transcripts
Training pass 1
Training pass 2
steps/train_lda_mllt.sh: Estimating MLLT
Training pass 3
Training pass 4
steps/train_lda_mllt.sh: Estimating MLLT
Training pass 5
Training pass 6
steps/train_lda_mllt.sh: Estimating MLLT
Training pass 7
Training pass 8
Training pass 9
Training pass 10
Aligning data
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/tri2a/graph_st6.o3g.kn.pr1-7 exp6/tri2a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri2a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_alignments.log
Overall, lattice depth (10,50,90-percentile)=(1,2,20) and mean=8.9
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri2a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_lattice_depth_stats.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/tri2a/graph_st6.o3g.kn.pr1-7 exp6/tri2a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0
Training pass 11
Training pass 12
steps/train_lda_mllt.sh: Estimating MLLT
Training pass 13
Training pass 14
Training pass 15
Training pass 16
Training pass 17
Training pass 18
Training pass 19
Training pass 20
Aligning data
Training pass 21
Training pass 22
Training pass 23
Training pass 24
Training pass 25
Training pass 26
Training pass 27
Training pass 28
Training pass 29
Training pass 30
Aligning data
Training pass 31
Training pass 32
Training pass 33
Training pass 34
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri3a
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 78.2793867120954% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri3a/log/analyze_alignments.log
1 warnings in exp6/tri3a/log/analyze_alignments.log
235 warnings in exp6/tri3a/log/init_model.log
1102 warnings in exp6/tri3a/log/update.*.log
3 warnings in exp6/tri3a/log/questions.log
165 warnings in exp6/tri3a/log/align.*.*.log
3 warnings in exp6/tri3a/log/build_tree.log
exp6/tri3a: nj=30 align prob=-46.72 over 11.68h [retry=0.1%, fail=0.0%] states=2865 gauss=80223 tree-impr=3.24 lda-sum=10.59 mllt:impr,logdet=0.95,1.93
steps/train_lda_mllt.sh: Done training system with LDA+MLLT features in exp6/tri3a

real	16m4.095s
user	154m12.937s
sys	8m15.232s
steps/align_fmllr.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/all data/lang_v1 exp6/tri3a exp6/tri3a_ali
steps/align_fmllr.sh: feature type is lda
steps/align_fmllr.sh: compiling training graphs
steps/align_fmllr.sh: aligning data in data/sharedTask2nd/all using exp6/tri3a/final.mdl and speaker-independent features.
steps/align_fmllr.sh: computing fMLLR transforms
steps/align_fmllr.sh: doing final alignment.
steps/align_fmllr.sh: done aligning data.
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri3a_ali
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 78.26389964379743% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri3a_ali/log/analyze_alignments.log
41 warnings in exp6/tri3a_ali/log/align_pass2.*.log
41 warnings in exp6/tri3a_ali/log/align_pass1.*.log
1 warnings in exp6/tri3a_ali/log/analyze_alignments.log
12879 warnings in exp6/tri3a_ali/log/fmllr.*.log
tree-info exp6/tri3a/tree 
tree-info exp6/tri3a/tree 
make-h-transducer --disambig-syms-out=exp6/tri3a/graph_st6.o3g.kn.pr1-7/disambig_tid.int --transition-scale=1.0 data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_3_1 exp6/tri3a/tree exp6/tri3a/final.mdl 
fstrmsymbols exp6/tri3a/graph_st6.o3g.kn.pr1-7/disambig_tid.int 
fstrmepslocal 
fstdeterminizestar --use-log=true 
fsttablecompose exp6/tri3a/graph_st6.o3g.kn.pr1-7/Ha.fst data/lang_st6.o3g.kn.pr1-7/tmp/CLG_3_1.fst 
fstminimizeencoded 
fstisstochastic exp6/tri3a/graph_st6.o3g.kn.pr1-7/HCLGa.fst 
0.000486198 -0.181593
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp6/tri3a/final.mdl 
                        Step 6 : tri4, MLLT+LDA+SAT                                      
steps/train_sat.sh --boost-silence 1.25 --cmd run.pl --mem 20G 5000 80000 data/sharedTask2nd/all data/lang_v1 exp6/tri3a_ali exp6/tri4a
steps/decode.sh --nj 30 --cmd run.pl --mem 20G --config conf/decode.conf --acwt 0.06 exp6/tri3a/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/tri3a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
decode.sh: feature type is lda
steps/train_sat.sh: feature type is lda
steps/train_sat.sh: Using transforms from exp6/tri3a_ali
steps/train_sat.sh: Accumulating tree stats
steps/train_sat.sh: Getting questions for tree clustering.
steps/train_sat.sh: Building the tree
steps/train_sat.sh: Initializing the model
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 1 with no stats; corresponding phone list: 6 7 8 9 10 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 2 with no stats; corresponding phone list: 11 12 13 14 15 
WARNING (gmm-init-model[5.4.105~1-4fda]:InitAmGmm():gmm-init-model.cc:55) Tree has pdf-id 42 with no stats; corresponding phone list: 173 174 175 176 
This is a bad warning.
steps/train_sat.sh: Converting alignments from exp6/tri3a_ali to use current tree
steps/train_sat.sh: Compiling graphs of transcripts
Pass 1
Pass 2
Estimating fMLLR transforms
Pass 3
Pass 4
Estimating fMLLR transforms
Pass 5
Pass 6
Estimating fMLLR transforms
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/tri3a/graph_st6.o3g.kn.pr1-7 exp6/tri3a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri3a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_alignments.log
Overall, lattice depth (10,50,90-percentile)=(1,2,16) and mean=6.8
steps/diagnostic/analyze_lats.sh: see stats in exp6/tri3a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06/log/analyze_lattice_depth_stats.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/tri3a/graph_st6.o3g.kn.pr1-7 exp6/tri3a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.06
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0
Pass 7
Pass 8
Pass 9
Pass 10
Aligning data
Pass 11
Pass 12
Estimating fMLLR transforms
Pass 13
Pass 14
Pass 15
Pass 16
Pass 17
Pass 18
Pass 19
Pass 20
Aligning data
Pass 21
Pass 22
Pass 23
Pass 24
Pass 25
Pass 26
Pass 27
Pass 28
Pass 29
Pass 30
Aligning data
Pass 31
Pass 32
Pass 33
Pass 34
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri4a
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 77.80703112900729% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri4a/log/analyze_alignments.log
391 warnings in exp6/tri4a/log/init_model.log
1306 warnings in exp6/tri4a/log/update.*.log
51515 warnings in exp6/tri4a/log/fmllr.*.*.log
1 warnings in exp6/tri4a/log/analyze_alignments.log
158 warnings in exp6/tri4a/log/align.*.*.log
3 warnings in exp6/tri4a/log/build_tree.log
35 warnings in exp6/tri4a/log/est_alimdl.log
3 warnings in exp6/tri4a/log/questions.log
steps/train_sat.sh: Likelihood evolution:
-53.1277 -53.162 -53.1493 -52.9014 -51.9289 -51.2235 -50.7402 -50.332 -49.9886 -49.5126 -49.193 -48.9659 -48.7659 -48.575 -48.3981 -48.2294 -48.069 -47.9148 -47.7649 -47.5556 -47.3625 -47.2224 -47.0901 -46.9625 -46.8389 -46.716 -46.5955 -46.4783 -46.3624 -46.2278 -46.1248 -46.08 -46.0465 -46.0195 
exp6/tri4a: nj=30 align prob=-46.82 over 11.68h [retry=0.1%, fail=0.0%] states=3569 gauss=80239 fmllr-impr=0.06 over 6.96h tree-impr=4.42
steps/train_sat.sh: done training SAT system in exp6/tri4a

real	16m59.762s
user	151m25.262s
sys	9m30.446s
steps/align_fmllr.sh --boost-silence 1.25 --nj 30 --cmd run.pl --mem 20G data/sharedTask2nd/all data/lang_v1 exp6/tri4a exp6/tri4a_ali
steps/align_fmllr.sh: feature type is lda
steps/align_fmllr.sh: compiling training graphs
steps/align_fmllr.sh: aligning data in data/sharedTask2nd/all using exp6/tri4a/final.alimdl and speaker-independent features.
steps/align_fmllr.sh: computing fMLLR transforms
steps/align_fmllr.sh: doing final alignment.
steps/align_fmllr.sh: done aligning data.
steps/diagnostic/analyze_alignments.sh --cmd run.pl --mem 20G data/lang_v1 exp6/tri4a_ali
analyze_phone_length_stats.py: WARNING: optional-silence sil is seen only 77.73733932166641% of the time at utterance begin.  This may not be optimal.
steps/diagnostic/analyze_alignments.sh: see stats in exp6/tri4a_ali/log/analyze_alignments.log
42 warnings in exp6/tri4a_ali/log/align_pass1.*.log
38 warnings in exp6/tri4a_ali/log/align_pass2.*.log
1 warnings in exp6/tri4a_ali/log/analyze_alignments.log
12875 warnings in exp6/tri4a_ali/log/fmllr.*.log

real	2m11.682s
user	29m55.239s
sys	0m42.357s
tree-info exp6/tri4a/tree 
tree-info exp6/tri4a/tree 
make-h-transducer --disambig-syms-out=exp6/tri4a/graph_st6.o3g.kn.pr1-7/disambig_tid.int --transition-scale=1.0 data/lang_st6.o3g.kn.pr1-7/tmp/ilabels_3_1 exp6/tri4a/tree exp6/tri4a/final.mdl 
fsttablecompose exp6/tri4a/graph_st6.o3g.kn.pr1-7/Ha.fst data/lang_st6.o3g.kn.pr1-7/tmp/CLG_3_1.fst 
fstdeterminizestar --use-log=true 
fstrmepslocal 
fstrmsymbols exp6/tri4a/graph_st6.o3g.kn.pr1-7/disambig_tid.int 
fstminimizeencoded 
fstisstochastic exp6/tri4a/graph_st6.o3g.kn.pr1-7/HCLGa.fst 
0.000487633 -0.181916
HCLGa is not stochastic
add-self-loops --self-loop-scale=0.1 --reorder=true exp6/tri4a/final.mdl 

real	0m38.129s
user	0m38.693s
sys	0m0.969s
steps/decode_fmllr.sh --nj 30 --cmd run.pl --mem 20G --config conf/decode.conf --acwt 0.05 exp6/tri4a/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
steps/decode.sh --scoring-opts  --num-threads 1 --skip-scoring false --acwt 0.05 --nj 30 --cmd run.pl --mem 20G --beam 8.0 --model exp6/tri4a/final.alimdl --max-active 2000 exp6/tri4a/graph_st6.o3g.kn.pr1-7 data/sharedTask2nd_test exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05.si
decode.sh: feature type is lda
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05.si
run.pl: job failed, log is in exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05.si/log/analyze_alignments.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05.si
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0
steps/decode_fmllr.sh: feature type is lda
steps/decode_fmllr.sh: getting first-pass fMLLR transforms.
steps/decode_fmllr.sh: doing main lattice generation phase
steps/decode_fmllr.sh: estimating fMLLR transforms a second time.
steps/decode_fmllr.sh: doing a final pass of acoustic rescoring.
steps/diagnostic/analyze_lats.sh --cmd run.pl --mem 20G exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
run.pl: job failed, log is in exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05/log/analyze_alignments.log
local/score.sh --cmd run.pl --mem 20G data/sharedTask2nd_test exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
local/score.sh: scoring with word insertion penalty=0.0,0.5,1.0

real	5m46.356s
user	69m13.253s
sys	0m52.416s
                        Step 7 : extract fmllr features                                  
steps/nnet/make_fmllr_feats.sh --nj 30 --cmd run.pl --mem 20G --transform-dir exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05 exp6/data-fmllr-tri4/sharedTask2nd_Test data/sharedTask2nd_test exp6/tri4a exp6/data-fmllr-tri4/sharedTask2nd_Test/log exp6/data-fmllr-tri4/sharedTask2nd_Test/data
steps/nnet/make_fmllr_feats.sh: feature type is lda_fmllr
utils/copy_data_dir.sh: copied data from data/sharedTask2nd_test to exp6/data-fmllr-tri4/sharedTask2nd_Test
utils/validate_data_dir.sh: Successfully validated data-directory exp6/data-fmllr-tri4/sharedTask2nd_Test
steps/nnet/make_fmllr_feats.sh: Done!, type lda_fmllr, data/sharedTask2nd_test --> exp6/data-fmllr-tri4/sharedTask2nd_Test, using : raw-trans None, gmm exp6/tri4a, trans exp6/tri4a/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
steps/nnet/make_fmllr_feats.sh --nj 30 --cmd run.pl --mem 20G --transform-dir exp6/tri4a_ali exp6/data-fmllr-tri4/train6 data/sharedTask2nd/all exp6/tri4a exp6/data-fmllr-tri4/train6/log exp6/data-fmllr-tri4/train6/data
steps/nnet/make_fmllr_feats.sh: feature type is lda_fmllr
utils/copy_data_dir.sh: copied data from data/sharedTask2nd/all to exp6/data-fmllr-tri4/train6
utils/validate_data_dir.sh: Successfully validated data-directory exp6/data-fmllr-tri4/train6
steps/nnet/make_fmllr_feats.sh: Done!, type lda_fmllr, data/sharedTask2nd/all --> exp6/data-fmllr-tri4/train6, using : raw-trans None, gmm exp6/tri4a, trans exp6/tri4a_ali
Speakers, src=12914, trn=11623, cv=1291 /tmp/xfu7_QIQXf/speakers_cv
utils/data/subset_data_dir.sh: reducing #utt from 12914 to 11623
utils/data/subset_data_dir.sh: reducing #utt from 12914 to 1291
                        Step 8 : train dnn model with tri4a gmm model                    
run.pl: job failed, log is in exp6/dnn4_pretrain-dbn_6_1024/log/pretrain_dbn.log
run.pl: job failed, log is in exp6/dnn4_pretrain-dbn_dnn_6_1024/log/train_nnet.log
                        Step 9 : align dnn model and prepare for retraining model        
steps/nnet/decode.sh --nj 30 --use-gpu yes --cmd run.pl --gpu 1 --mem 20G --config conf/decode_dnn.conf --acwt 0.05 exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/data-fmllr-tri4/sharedTask2nd_Test exp6/dnn4_pretrain-dbn_dnn_6_1024/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
steps/nnet/align.sh --nj 30 --use-gpu yes --cmd run.pl --gpu 1 --mem 20G exp6/data-fmllr-tri4/train6_tr90 data/lang_v1 exp6/dnn4_pretrain-dbn_dnn_6_1024 exp6/dnn4_pretrain-dbn_dnn_6_1024_ali
steps/nnet/decode.sh: missing file exp6/dnn4_pretrain-dbn_dnn_6_1024/final.nnet
cp: cannot stat 'exp6/dnn4_pretrain-dbn_dnn_6_1024/tree': No such file or directory
cp: cannot stat 'exp6/dnn4_pretrain-dbn_dnn_6_1024/final.mdl': No such file or directory
nnet-copy --binary=false exp6/dnn4_pretrain-dbn_dnn_6_1024/final.nnet exp6/dnn4_pretrain-dbn_dnn_6_1024/final_txt.nnet 
ERROR (nnet-copy[5.4.105~1-4fda]:Input():kaldi-io.cc:756) Error opening input stream exp6/dnn4_pretrain-dbn_dnn_6_1024/final.nnet

[ Stack-Trace: ]
nnet-copy() [0x66dcaa]
kaldi::MessageLogger::HandleMessage(kaldi::LogMessageEnvelope const&, char const*)
kaldi::MessageLogger::~MessageLogger()
kaldi::Input::Input(std::string const&, bool*)
main
__libc_start_main
nnet-copy() [0x4e1419]

Traceback (most recent call last):
  File "dnn2dbn.py", line 3, in <module>
    with open(sys.argv[1], 'r') as theFile:
FileNotFoundError: [Errno 2] No such file or directory: 'exp6/dnn4_pretrain-dbn_dnn_6_1024/final_txt.nnet'
nnet-copy exp6/dnn4_pretrain-dbn_dnn_6_1024/final_txt.dbn exp6/dnn4_pretrain-dbn_dnn_6_1024/final.dbn 
ERROR (nnet-copy[5.4.105~1-4fda]:Input():kaldi-io.cc:756) Error opening input stream exp6/dnn4_pretrain-dbn_dnn_6_1024/final_txt.dbn

[ Stack-Trace: ]
nnet-copy() [0x66dcaa]
kaldi::MessageLogger::HandleMessage(kaldi::LogMessageEnvelope const&, char const*)
kaldi::MessageLogger::~MessageLogger()
kaldi::Input::Input(std::string const&, bool*)
main
__libc_start_main
nnet-copy() [0x4e1419]

utils/subset_data_dir.sh: reducing #utt from 12914 to 0
                        Step 10 : finetune dnn4 with only st data                        
run.pl: job failed, log is in exp6/dnn4_pretrain-dbn_dnn_6_1024_reST/log/train_nnet.log

real	0m0.090s
user	0m0.046s
sys	0m0.054s
steps/nnet/decode.sh --nj 30 --use-gpu yes --cmd run.pl --gpu 1 --mem 20G --config conf/decode_dnn.conf --acwt 0.05 exp6/tri4a/graph_st6.o3g.kn.pr1-7 exp6/data-fmllr-tri4/sharedTask2nd_Test exp6/dnn4_pretrain-dbn_dnn_6_1024_reST/decode_st.test_st6.o3g.kn.pr1-7_acwt0.05
steps/nnet/decode.sh: missing file exp6/dnn4_pretrain-dbn_dnn_6_1024_reST/final.nnet

real	0m0.037s
user	0m0.015s
sys	0m0.031s
