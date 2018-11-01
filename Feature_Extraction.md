
## AMI result 
```

It seems not all of the feature files were successfully processed (108221 != 108502);
consider using utils/fix_data_dir.sh data/ihm/train
Succeeded creating MFCC features for train
steps/compute_cmvn_stats.sh data/ihm/train
Succeeded creating CMVN stats for train
fix_data_dir.sh: kept 108221 utterances out of 108502

```

Move from AMI dir to SpokenCALL dir
```
cp -rf /home/xfu7/kaldi/egs/ami/s5b/data/ihm/train ihm_8kHz/train/
```

[xfu7@c76 data]$ rm sharedTask2nd/st_ihm_all/data/*
[xfu7@c76 data]$ rm sharedTask2nd/st_ihm_all/log/*
[xfu7@c76 data]$ > sharedTask2nd/st_ihm_all/feats.scp
[xfu7@c76 data]$ > sharedTask2nd/st_ihm_all/cmvm.scp

[xfu7@c76 data]$ wc -l sharedTask2nd/all/feats.scp
12914 sharedTask2nd/all/feats.scp
[xfu7@c76 data]$ wc -l sharedTask2nd/all/cmvn.scp
12914 sharedTask2nd/all/cmvn.scp

## Preparing for combine training
```
cd data
>  sharedTask2nd/st_ihm_all/text &
>  sharedTask2nd/st_ihm_all/wap.scp & 
>  sharedTask2nd/st_ihm_all/utt2spk & 
>  sharedTask2nd/st_ihm_all/spk2utt 

cat sharedTask2nd/all/text >> sharedTask2nd/st_ihm_all/text & \
cat sharedTask2nd/all/wav.scp >> sharedTask2nd/st_ihm_all/wav.scp & \
cat sharedTask2nd/all/utt2spk >> sharedTask2nd/st_ihm_all/utt2spk & \
cat sharedTask2nd/all/spk2utt >> sharedTask2nd/st_ihm_all/spk2utt 
cat sharedTask2nd/all/feats.scp >> sharedTask2nd/st_ihm_all/feats.scp
cat sharedTask2nd/all/cmvn.scp >> sharedTask2nd/st_ihm_all/cmvn.scp

cat ihm_8kHz/train/text >> sharedTask2nd/st_ihm_all/text & \
cat ihm_8kHz/train/wav.scp >> sharedTask2nd/st_ihm_all/wav.scp & \
cat ihm_8kHz/train/utt2spk >> sharedTask2nd/st_ihm_all/utt2spk & \
cat ihm_8kHz/train/spk2utt >> sharedTask2nd/st_ihm_all/spk2utt 
cat ihm_8kHz/train/feats.scp >> sharedTask2nd/st_ihm_all/feats.scp
cat ihm_8kHz/train/cmvn.scp >> sharedTask2nd/st_ihm_all/cmvn.scp

cp sharedTask2nd/all/data/* sharedTask2nd/st_ihm_all/data
cp ihm_8kHz/train/data/* sharedTask2nd/st_ihm_all/data

```