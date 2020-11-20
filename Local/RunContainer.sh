#!/bin/bash

# docker build -t tlt-toolkit:dev .
docker run --gpus all --rm -it \
    -v $HOME/training-data/:/workspace/tlt-experiments/data \
    -v $HOME/models/NGC/segmentation/:/workspace/tlt-experiments/maskrcnn \
    -v $HOME/github/tl-toolkit/tl-toolkit/:/my-tlt \
    -v $HOME/github/tl-toolkit/tl-toolkit/specs:/workspace/examples/maskrcnn/specs \
    -e NGC_KEY=$NGC_KEY \
    -p 8888:8888 nvcr.io/nvidia/tlt-streamanalytics:v2.0_py3

# jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root
