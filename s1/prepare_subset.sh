#!/bin/bash

#Usage: combine_data.sh [--extra-files 'file1 file2'] <dest-data-dir> <src-data-dir1> <src-data-dir2> ...


rm -rf data/ihm_s5/train_5k data/sharedTask2nd/train_5k data/ihm_8kHz/train_5k

# get a subset of 5k from ihm dataset
utils/subset_data_dir.sh data/ihm_s5/train 10000 data/ihm_s5/train_10k
utils/subset_data_dir.sh data/ihm_s5/train 12000 data/ihm_s5/train_12k
utils/subset_data_dir.sh data/ihm_s5/train 20000 data/ihm_s5/train_20k
utils/subset_data_dir.sh data/ihm_s5/train 50000 data/ihm_s5/train_50k

# get a subset of 5K from ST12 dataset
utils/subset_data_dir.sh data/sharedTask2nd/all 5000 data/sharedTask2nd/train_5k

# combine these two subsets
utils/combine_data.sh data/st_ihm_all/train_5S10I data/sharedTask2nd/train_5k data/ihm_s5/train_10k 
utils/combine_data.sh data/st_ihm_all/train_5S20I data/sharedTask2nd/train_5k data/ihm_s5/train_20k 
utils/combine_data.sh data/st_ihm_all/train_12S12I data/sharedTask2nd/all data/ihm_s5/train_12k 
utils/combine_data.sh data/st_ihm_all/train_12S50I data/sharedTask2nd/all data/ihm_s5/train_50k 
utils/combine_data.sh data/st_ihm_all/train_all data/sharedTask2nd/all data/ihm_s5/train


