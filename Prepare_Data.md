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

