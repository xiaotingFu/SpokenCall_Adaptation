

## Detect CUDA Version
[xfu7@c74 src]$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2016 NVIDIA Corporation
Built on Tue_Jan_10_13:22:03_CST_2017
Cuda compilation tools, release 8.0, V8.0.61

cd /pvfs2/xfu7@oss-storage-0-108/pvfs2


steps/decode_fmllr.sh --nj 15 --cmd run.pl --mem 28G --config conf/decode.conf --acwt 0.05 exp2/tri4a/graph_st2.o3g.kn.pr1-7 data/sharedTask2nd_test exp2/tri4a/decode_st.test_st2.o3g.kn.pr1-7_acwt0.05


cmake .. -DBUILD_PYTHON=TRUE -DWITH_ZMQ=FALSE -WITH_MKL=FALSE