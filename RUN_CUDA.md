

## Detect CUDA Version
[xfu7@c74 src]$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2016 NVIDIA Corporation
Built on Tue_Jan_10_13:22:03_CST_2017
Cuda compilation tools, release 8.0, V8.0.61

cd /pvfs2/xfu7@oss-storage-0-108/pvfs2


steps/decode_fmllr.sh --nj 15 --cmd run.pl --mem 28G --config conf/decode.conf --acwt 0.05 exp2/tri4a/graph_st2.o3g.kn.pr1-7 data/sharedTask2nd_test exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05


## Use CUDA in Kaldi

```
LOG ([5.4.105~1-4fda]:main():cuda-gpu-available.cc:61) ...
### The CUDA setup is wrong! ("invalid device function" == problem with 'compute capability' in compiled kaldi)
### Before posting the error to forum, please try following:
### 1) update kaldi & cuda-toolkit (& GPU driver),
### 2) re-run 'src/configure',
### 3) re-compile kaldi by 'make clean; make -j depend; make -j'
###
### If the problem persists, please send us your:
### - GPU model name, cuda-toolkit version, driver version (run nvidia-smi), variable $(CUDA_ARCH) from src/kaldi.mk
# Accounting: time=4 threads=1
# Ended (code 1) at Mon Nov 26 12:03:23 EST 2018, elapsed time 4 seconds
[xfu7@c95 s1]$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2016 NVIDIA Corporation
Built on Tue_Jan_10_13:22:03_CST_2017
Cuda compilation tools, release 8.0, V8.0.61
```
