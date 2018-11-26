#!/bin/bash

#Usage: combine_data.sh [--extra-files 'file1 file2'] <dest-data-dir> <src-data-dir1> <src-data-dir2> ...

st_dir=data/sharedTask2nd
ihm_dir=data/ihm
dest_dir=data/st_ihm_all

# Clear the destination directory
rm -rf $dest_dir/*
rm -rf data/ihm_s5/train_5k $st_dir/train_5k 
# get a list of subset of ihm dataset 
utils/subset_data_dir.sh $ihm_dir/train 10000 $ihm_dir/train_10k
utils/subset_data_dir.sh $ihm_dir/train 12000 $ihm_dir/train_12k
utils/subset_data_dir.sh $ihm_dir/train 20000 $ihm_dir/train_20k
utils/subset_data_dir.sh $ihm_dir/train 50000 $ihm_dir/train_50k

# get a subset of 5K from ST12 dataset
utils/subset_data_dir.sh $st_dir/all 5000 $st_dir/train_5k

# combine these two subsets
utils/combine_data.sh $dest_dir/train_5S10I $st_dir/train_5k $ihm_dir/train_10k 
utils/combine_data.sh $dest_dir/train_5S20I $st_dir/train_5k $ihm_dir/train_20k 
utils/combine_data.sh $dest_dir/train_12S12I $st_dir/all $ihm_dir/train_12k 
utils/combine_data.sh $dest_dir/train_12S50I $st_dir/all $ihm_dir/train_50k 
utils/combine_data.sh $dest_dir/train_all $st_dir/all $ihm_dir/train


