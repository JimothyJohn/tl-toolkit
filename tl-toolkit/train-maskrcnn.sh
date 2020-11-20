#!/bin/bash

export KEY=$NGC_KEY
export USER_EXPERIMENT_DIR=/workspace/tlt-experiments/maskrcnn
export DATA_DOWNLOAD_DIR=/workspace/tlt-experiments/data
export SPECS_DIR=/workspace/examples/maskrcnn/specs/

tlt-train mask_rcnn -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
                    -d $USER_EXPERIMENT_DIR/experiment_dir_unpruned\
                    -k $KEY \
                    --gpus 1

echo "Model for each epoch:"
echo "---------------------"
ls -ltrh $USER_EXPERIMENT_DIR/experiment_dir_unpruned/
