# Kaldi DNN Structure and Experinment


## In kaldi/egs/wsj/s5/run.sh A couple of nnet3 recipes:
``` bash
local/nnet3/run_tdnn_baseline.sh  # designed for exact comparison with nnet2 recipe
local/nnet3/run_tdnn.sh  # better absolute results
local/nnet3/run_lstm.sh  # lstm recipe
bidirectional lstm recipe
local/nnet3/run_lstm.sh --affix bidirectional \
                        --lstm-delay " [-1,1] [-2,2] [-3,3] " \
                        --label-delay 0 \
                        --cell-dim 640 \
                        --recurrent-projection-dim 128 \
                        --non-recurrent-projection-dim 128 \
                        --chunk-left-context 40 \
                        --chunk-right-context 40
```