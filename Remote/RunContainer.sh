#!/bin/bash

# Configure environment
EFS=/mnt/efs/fs1
docker run --gpus all --rm -it \
	-v $EFS/data:/data \
	-v $EFS/models:/models \
	-v $HOME/tl-toolkit/Remote:/TLT \
	-v $HOME/tl-toolkit/Remote/specs:/specs \
	-e NGC_KEY=$NGC_KEY \
	nvcr.io/nvidia/tlt-streamanalytics:v2.0_py3
