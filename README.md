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
# wav file
[xfu7@c74 sharedTask2nd]$ wc -l all/wav.scp
12914 all/wav.scp

# text file
[xfu7@c74 sharedTask2nd]$ wc -l all/text
12914 all/text
```
