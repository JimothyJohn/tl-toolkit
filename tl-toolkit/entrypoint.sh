#!/bin/bash

python3 maskrcnn-train.py --key=$NGC_KEY \
    --model /models/segmentation/tlt_instance_segmentation_vresnet50 \
    --data /training-data/ \
    --specs /workspace/examples/maskrcnn/specs/

PARAMS=""
while (( "$#" )); do
    case "$1" in
        -m|--model)
            if [ $2 -eq 0 ]; then
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            else
                MODEL=$2
                shift 2
            fi
            ;;
        -d|--data)
            if [ $2 -eq 0 ]; then
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            else
                DATA=$2
                shift 2
            fi
            ;;
        -s|--specs)
            if [ $2 -eq 0 ]; then
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            else
                SPECS=$2
                shift 2
            fi
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"
echo $KEY
echo $MODEL
echo $DATA
echo $SPECS

