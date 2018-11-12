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

```bash
cd data/sharedTask2nd/st_ihm_all
cat ../../ihm/all/text >> text
cat ../../ihm/all/utt2spk >> utt2spk
cat ../../ihm/all/spk2utt >> spk2utt
cat ../../ihm/all/wav.scp >> wav.scp
[xfu7@c47 st_ihm_all]$ cat ../all/text >> text
[xfu7@c47 st_ihm_all]$ cat ../all/wav.scp >> wav.scp
[xfu7@c47 st_ihm_all]$ cat ../all/utt2spk >> utt2spk
[xfu7@c47 st_ihm_all]$ cat ../all/spk2utt >> spk2utt

[xfu7@c47 s1]$ utils/fix_data_dir.sh data/sharedTask2nd/st_ihm_all
fix_data_dir.sh: kept 12914 utterances out of 147157
fix_data_dir.sh: old files are kept in data/sharedTask2nd/st_ihm_all/.backup

! awk '{print $1}' $1 | sort | uniq | cmp -s - <(awk '{print $1}' $1)

$1=data/sharedTask2nd/st_ihm_all/utt2spk
function check_sorted_and_uniq {
  ! awk '{print $1}' $1 | sort | uniq | cmp -s - <(awk '{print $1}' $1) && \
    echo "$0: file $1 is not in sorted order or has duplicates" && exit 1;
}

function partial_diff {
  diff $1 $2 | head -n 6
  echo "..."
  diff $1 $2 | tail -n 6
  n1=`cat $1 | wc -l`
  n2=`cat $2 | wc -l`
  echo "[Lengths are $1=$n1 versus $2=$n2]"
}

check_sorted_and_uniq $data/utt2spk

if ! $no_spk_sort; then
  ! cat $data/utt2spk | sort -k2 | cmp -s - $data/utt2spk && \
     echo "$0: utt2spk is not in sorted order when sorted first on speaker-id " && \
     echo "(fix this by making speaker-ids prefixes of utt-ids)" && exit 1;
fi
! awk '{print $1}' $1 | sort | uniq | cmp -s - <(awk '{print $1}' $1)

cat data/sharedTask2nd/st_ihm_all/utt2spk | sort | cmp - data/sharedTask2nd/st_ihm_all/utt2spk

utils/validate_data_dir.sh data/sharedTask2nd/st_ihm_all
```


utils/utt2spk_to_spk2utt.pl data/sharedTask2nd/st_ihm_all/utt2spk > data/sharedTask2nd/st_ihm_all/spk2utt

[xfu7@c47 s1]$ time ./run_train_st.sh >> 1029.log
/run_train_st.sh: line 72: exp10/mono/graph_st10.o3g.kn.pr1-7/mkgraph.log: No such file or directory

real    49m6.402s
user    441m37.960s
sys     3m7.969s


[xfu7@c47 s1]$ time ./run_train_st.sh > log_train_st
./run_train_st.sh: line 242: syntax error: unexpected end of file

real    34m3.523s
user    435m42.747s
sys     2m59.304s


Triphone training takes 1300 hours