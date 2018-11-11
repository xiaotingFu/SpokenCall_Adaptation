# Experinment Notes Till Nov 11, 2018


For now I have finished training mono, tri1/2/3/4 and chain/nnet models using Kaldi toolkits with the prepared data.

However, the result is somehow very weird.

The WER tested in tri4a is listed below
```bash
# lattice_depth_stats
cat exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/log/analyze_lattice_depth_stats.log

# Result
[xfu7@c74 s1]$ cat exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/log/analyze_lattice_depth_stats.log
# gunzip -c exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/depth_stats_tmp.*.gz | steps/diagnostic/analyze_lattice_depth_stats.py exp2/tri4a/graph_st2.o3g.kn.pr1-7
# Started at Sat Nov 10 22:27:01 EST 2018
#
The total amount of data analyzed assuming 100 frames per second is 0.9 hours
Overall, lattice depth (10,50,90-percentile)=(1,2,114) and mean=43.0
Phone sil accounts for 82.8% of frames, with lattice depth (10,50,90-percentile)=(1,2,71) and mean=32.0
Nonsilence phones as a group account for 12.7% of frames, with lattice depth (10,50,90-percentile)=(3,51,290) and mean=128.0
Phone oov_S accounts for 4.5% of frames, with lattice depth (10,50,90-percentile)=(2,2,2) and mean=4.1
Phone AY_S accounts for 1.4% of frames, with lattice depth (10,50,90-percentile)=(2,2,64) and mean=26.0
Phone IY_E accounts for 0.5% of frames, with lattice depth (10,50,90-percentile)=(5,41,274) and mean=107.7
Phone AE_I accounts for 0.5% of frames, with lattice depth (10,50,90-percentile)=(5,64,289) and mean=132.0
# Accounting: time=0 threads=1
# Ended (code 0) at Sat Nov 10 22:27:01 EST 2018, elapsed time 0 seconds
```
As we can see, most of the phone are sil phone, which is very weird since in the raw audio there are a lot of speech.

```bash
# decode log
cat exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/log/decode.10.log

# Result 
[xfu7@c74 s1]$ cat exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/log/decode.10.log
# gmm-latgen-faster --max-active=7000 --beam=11.0 --lattice-beam=6.0 --acoustic-scale=0.05 --determinize-lattice=false --allow-partial=true --word-symbol-table=exp2/tri4a/graph_st2.o3g.kn.pr1-7/words.txt exp2/tri4a/final.mdl exp2/tri4a/graph_st2.o3g.kn.pr1-7/HCLG.fst "ark,s,cs:apply-cmvn  --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk scp:data/sharedTask2nd_test/split15/10/cmvn.scp scp:data/sharedTask2nd_test/split15/10/feats.scp ark:- | splice-feats --left-context=3 --right-context=3 ark:- ark:- | transform-feats exp2/tri4a/final.mat ark:- ark:- | transform-feats --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk ark:exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/pre_trans.10 ark:- ark:- |" "ark:|gzip -c > exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/lat.tmp.10.gz"
# Started at Sat Nov 10 22:15:10 EST 2018
#
gmm-latgen-faster --max-active=7000 --beam=11.0 --lattice-beam=6.0 --acoustic-scale=0.05 --determinize-lattice=false --allow-partial=true --word-symbol-table=exp2/tri4a/graph_st2.o3g.kn.pr1-7/words.txt exp2/tri4a/final.mdl exp2/tri4a/graph_st2.o3g.kn.pr1-7/HCLG.fst 'ark,s,cs:apply-cmvn  --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk scp:data/sharedTask2nd_test/split15/10/cmvn.scp scp:data/sharedTask2nd_test/split15/10/feats.scp ark:- | splice-feats --left-context=3 --right-context=3 ark:- ark:- | transform-feats exp2/tri4a/final.mat ark:- ark:- | transform-feats --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk ark:exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/pre_trans.10 ark:- ark:- |' 'ark:|gzip -c > exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/lat.tmp.10.gz'
apply-cmvn --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk scp:data/sharedTask2nd_test/split15/10/cmvn.scp scp:data/sharedTask2nd_test/split15/10/feats.scp ark:-
splice-feats --left-context=3 --right-context=3 ark:- ark:-
transform-feats exp2/tri4a/final.mat ark:- ark:-
transform-feats --utt2spk=ark:data/sharedTask2nd_test/split15/10/utt2spk ark:exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05/pre_trans.10 ark:- ark:-
sc2_40657
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40657 is -3.00649 over 274 frames.
sc2_40658 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40658 is -3.16624 over 294 frames.
sc2_40659 IMPLANTED
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40659 is -3.08781 over 186 frames.
sc2_40662 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40662 is -3.02471 over 306 frames.
sc2_40664
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40664 is -3.00153 over 322 frames.
sc2_40665
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40665 is -2.97598 over 234 frames.
sc2_40666
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40666 is -3.06493 over 266 frames.
sc2_40667
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40667 is -3.16523 over 442 frames.
sc2_40669
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40669 is -3.01818 over 270 frames.
sc2_40670
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40670 is -2.91465 over 438 frames.
sc2_40673
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40673 is -2.91936 over 234 frames.
sc2_40674 CARP
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40674 is -3.27543 over 346 frames.
sc2_40675
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40675 is -3.2565 over 266 frames.
sc2_40676
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40676 is -3.1769 over 238 frames.
sc2_40679
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40679 is -3.26671 over 462 frames.
sc2_40682
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40682 is -3.20867 over 246 frames.
sc2_40687
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40687 is -3.13724 over 354 frames.
sc2_40690
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40690 is -2.99325 over 254 frames.
sc2_40692
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40692 is -3.25636 over 386 frames.
sc2_40697 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40697 is -3.28329 over 442 frames.
sc2_40698
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40698 is -3.12021 over 118 frames.
sc2_40699
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40699 is -3.17409 over 222 frames.
sc2_40700
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40700 is -3.09133 over 394 frames.
sc2_40703
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40703 is -3.08375 over 558 frames.
sc2_40706
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40706 is -3.06497 over 262 frames.
sc2_40707 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40707 is -3.20551 over 414 frames.
sc2_40710 BATH
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40710 is -3.05555 over 222 frames.
sc2_40711 HOOP
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40711 is -3.13086 over 302 frames.
sc2_40714
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40714 is -3.10652 over 510 frames.
sc2_40718
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40718 is -3.17449 over 258 frames.
sc2_40719
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40719 is -3.25415 over 282 frames.
sc2_40721
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40721 is -3.18848 over 282 frames.
sc2_40726
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40726 is -3.1572 over 254 frames.
sc2_40727
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40727 is -3.01169 over 262 frames.
sc2_40728
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40728 is -3.04002 over 378 frames.
sc2_40730
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40730 is -3.24885 over 350 frames.
sc2_40731
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40731 is -3.18143 over 230 frames.
sc2_40734
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40734 is -3.23884 over 202 frames.
sc2_40736 UNIT
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40736 is -3.03836 over 290 frames.
sc2_40737
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40737 is -3.07989 over 314 frames.
sc2_40738
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40738 is -3.12165 over 386 frames.
sc2_40739
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40739 is -3.09633 over 338 frames.
sc2_40740
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40740 is -3.20374 over 246 frames.
sc2_40741 <unk>
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40741 is -3.06221 over 354 frames.
sc2_40742 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40742 is -3.1465 over 382 frames.
sc2_40744
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40744 is -3.10775 over 550 frames.
sc2_40745
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40745 is -3.20131 over 282 frames.
sc2_40746
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40746 is -3.03602 over 346 frames.
sc2_40747
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40747 is -3.03517 over 450 frames.
sc2_40748
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40748 is -3.1586 over 234 frames.
sc2_40749 I
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40749 is -3.05335 over 266 frames.
sc2_40750
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40750 is -3.05552 over 222 frames.
sc2_40752
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40752 is -3.09268 over 294 frames.
sc2_40753
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40753 is -3.16778 over 426 frames.
sc2_40755
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40755 is -3.11574 over 486 frames.
sc2_40756
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40756 is -3.39187 over 282 frames.
sc2_40758
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40758 is -3.26454 over 382 frames.
LOG (apply-cmvn[5.4.105~1-4fda]:main():apply-cmvn.cc:162) Applied cepstral mean normalization to 67 utterances, errors on 0
sc2_40759
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40759 is -3.22665 over 370 frames.
sc2_40760
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40760 is -3.41243 over 358 frames.
sc2_40761
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40761 is -3.37908 over 350 frames.
sc2_40763
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40763 is -3.22521 over 354 frames.
sc2_40765
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40765 is -3.3876 over 406 frames.
sc2_40766
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40766 is -3.54133 over 374 frames.
sc2_40767
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40767 is -3.28473 over 346 frames.
LOG (transform-feats[5.4.105~1-4fda]:main():transform-feats.cc:158) Overall average [pseudo-]logdet is -92.7184 over 21830 frames.
LOG (transform-feats[5.4.105~1-4fda]:main():transform-feats.cc:161) Applied transform to 67 utterances; 0 had errors.
sc2_40768
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40768 is -3.26795 over 462 frames.
LOG (transform-feats[5.4.105~1-4fda]:main():transform-feats.cc:158) Overall average logdet is 0 over 21830 frames.
LOG (transform-feats[5.4.105~1-4fda]:main():transform-feats.cc:161) Applied transform to 67 utterances; 0 had errors.
sc2_40769
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40769 is -3.14422 over 270 frames.
sc2_40770
LOG (gmm-latgen-faster[5.4.105~1-4fda]:DecodeUtteranceLatticeFaster():decoder-wrappers.cc:286) Log-like per frame for utterance sc2_40770 is -3.19197 over 250 frames.
LOG (gmm-latgen-faster[5.4.105~1-4fda]:main():gmm-latgen-faster.cc:176) Time taken 320.143s: real-time factor assuming 100 frames/sec is 1.46653
LOG (gmm-latgen-faster[5.4.105~1-4fda]:main():gmm-latgen-faster.cc:179) Done 67 utterances, failed for 0
LOG (gmm-latgen-faster[5.4.105~1-4fda]:main():gmm-latgen-faster.cc:181) Overall log-likelihood per frame is -3.15757 over 21830 frames.
# Accounting: time=321 threads=1
# Ended (code 0) at Sat Nov 10 22:20:31 EST 2018, elapsed time 321 seconds
```
