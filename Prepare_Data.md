# Prepare data process

```bash
========================Process CSV=====================
csvpath: /home/xfu7/data/sharedTask2nd/test/scst2_testDataSpeech.csv
audiopath: /home/xfu7/data/sharedTask2nd/test/audio
destination: /home/xfu7/kaldi/egs/SpokenCall_Adaptation/s1/data/sharedTask2nd_test
Traceback (most recent call last):
  File "prepare_data.py", line 83, in <module>
    main()
  File "prepare_data.py", line 81, in main
    prepareKaldiData('sc2',test_label_2nd, test_audio_2nd,destination_test)
  File "prepare_data.py", line 46, in prepareKaldiData
    utterance = str(row[3])
IndexError: list index out of range
```


## Install srilm for language model training
follow instruction in kaldi/tools/install_srilm.sh


## Step 1 : prepare data and extract features
steps/make_mfcc.sh --nj 1 --cmd queue.pl /log /data
mkdir: cannot create directory '/log': Permission denied

## Step 2: prepare external data corpus
All videos from AMI Corpus are 16000HZ, need to downsample to 8000HZ
```bash
ffmpeg -i $video -acodec pcm_s16le -ac 1 -ar 8000 ~/Desktop/Transcriptions/splits_8k/$video_path

count=0
for dir in */; do
    # mkdir /home/xfu7/data/amicorpus_8kHz/$dir
    # mkdir /home/xfu7/data/amicorpus_8kHz/$dir/audio
    for wavfile in $dir/audio/*.wav; do
        ls -lah $wavfile
        ((count=count+1))
        # b=$(basename $wavfile)
        # echo $b
        # ffmpeg $wavfile -ar 8000 mkdir /home/xfu7/data/amicorpus_8kHz/$dir/audio/$wavefile
    done  
done
echo "$count"
# 1374 videos intotal

for dir in */; do
    for wavfile in $dir/audio/*.wav; do
        # ls -lah $wavfile
        # ((count=count+1))
        b=$(basename $wavfile)
        echo $b
        ffmpeg -i $wavfile -ar 8000  -acodec pcm_s16le /home/xfu7/data/amicorpus_8kHz/$dir/audio/$b
    done  
done

```


Failed to open file /home/mxq486/kaldi-trunk/egs/ami/s5/data/sharedTask/all/data/raw_mfcc_all.1.ark

## Prepare AMI Corpus by Running Kaldi/egs/ami/s5b

To prepare the AMI Corpus for training in the setup we need to prepare data.
Here we use the data preparation scripts provided by Kaldi to prepare the AMI corpus.

This corpus require Fisher Transcript which is not avaliable in public, therefore I skip this part as described in the [README_AMI_s5b](/README_AMI_s5b) file.

I later run the following command to generate the data files for training and stop before mfcc feature extraction step in this setting.

```
# I only want to prepare ihm for my setup
./run.sh --mic ihm
```

The result of this script generate data in /s5b/data/ihm directory:
```
[xfu7@c44 ihm]$ ls
dev  dev_orig  eval  eval_orig  train  train_orig

[xfu7@c44 data]$ wc -l  ihm/train/text
108502 ihm/train/text

for dir in */; do wc -l $dir/text; done
```

Results are shown as follws:
```
[xfu7@c44 ihm]$ for dir in */; do wc -l $dir/utt2spk; done
13098 dev//text
13098 dev_orig//text
12643 eval//text
12643 eval_orig//text
108502 train//text
108502 train_orig//text
```

Now I need to copy this file into the SpokenCALL_Adaptation directory:
```
cp -rf ihm/ /home/xfu7/kaldi/egs/SpokenCall_Adaptation/s1/data/ihm
```


## Create Data Augumentation Corpus
```bash
# Final AMI-IHM Utterance number
[xfu7@c47 ihm]$ wc -l all/text
134243 all/text

# grab 20% of the utterance and build ihm20
#!/bin/bash
array=("text" "wav.scp" "segments" "utt2spk" "spk2utt")
for item in ${array[*]}; do
    touch sharedTask2nd/ihm20/$item
    
    cat ihm/all/$item | head -26848 > sharedTask2nd/ihm20/$item
    wc -l sharedTask2nd/ihm20/$item
done

for item in $array; do  wc -l sharedTask2nd/ihm20/$item; done
# grab 50% of the utterance and build ihm50
```