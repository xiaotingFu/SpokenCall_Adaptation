# Spoken-CALL SharedTask Development Log

## Task 1: Running Baseline Algorithm for SharedTask2nd

### MetaData
SharedTask1st
```bash
[xfu7@c74 sharedTask1st]$ ls -l audio/ | wc -l
6219
```

SharedTask2nd
```bash
# Test data: 1001
[xfu7@c74 sharedTask2nd]$ ls -l test/test_data/ | wc -l
1001

# Train data: 6699
[xfu7@c74 sharedTask2nd]$ ls -l train/TrainingDataWavfiles/ | wc -l
6699

# Total: 7700

# Total for SharedTask1st and SharedTask2nd: 13919
# New dataset:
# Train: 6699 + 6219 = 12918
# Test: 1001
```

## Data preparation
```bash
# Preparing data for training use data from sharedTask2nd 
# Trainning file location:
/home/xfu7/kaldi/egs/st/s1/data/sharedTask2nd/all/
# Trainning data location:
/home/xfu7/data/sharedTask1st/

# Test file location:
/home/xfu7/kaldi/egs/st/s1/data/sharedTask2nd_test/
# Test data location:
/home/xfu7/data/sharedTask2nd/

```

Result
```bash
# Train Set
[xfu7@c44 sharedTask2nd]$ ls all
spk2utt  text  utt2spk  wav.scp

# wav file
[xfu7@c74 sharedTask2nd]$ wc -l all/wav.scp
12914 all/wav.scp

# tail
[xfu7@c44 sharedTask2nd_test]$ tail wav.scp
sc2-41322 /home/xfu7/data/sharedTask2nd/test/audio/41322.wav
sc2-41323 /home/xfu7/data/sharedTask2nd/test/audio/41323.wav
sc2-41327 /home/xfu7/data/sharedTask2nd/test/audio/41327.wav
sc2-41328 /home/xfu7/data/sharedTask2nd/test/audio/41328.wav
sc2-41329 /home/xfu7/data/sharedTask2nd/test/audio/41329.wav
sc2-41330 /home/xfu7/data/sharedTask2nd/test/audio/41330.wav
sc2-41331 /home/xfu7/data/sharedTask2nd/test/audio/41331.wav
sc2-41334 /home/xfu7/data/sharedTask2nd/test/audio/41334.wav
sc2-41337 /home/xfu7/data/sharedTask2nd/test/audio/41337.wav
sc2-41338 /home/xfu7/data/sharedTask2nd/test/audio/41338.wav

# Test set
[xfu7@c44 sharedTask2nd_test]$ wc -l wav.scp
1001 wav.scp

```

```bash
# data_dir_sub
[xfu7@c44 sharedTask]$ wc -l all/wav.scp
5222 all/wav.scp

# data_dir
[xfu7@c44 sharedTask]$ wc -l st_ihm20_psgAll/train10/wav.scp
5531 st_ihm20_psgAll/train10/wav.scp
```

