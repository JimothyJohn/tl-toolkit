#!/bin/bash

#!/bin/bash

export KEY=$NGC_KEY
export MODEL_DIR=/models
export DATA_DOWNLOAD_DIR=/data
export SPECS_DIR=/specs
export PROGRAM_DIR=/TLT

INSTANCE_ID=i-0f732024c665202d5
PUBLIC_IP=54.205.166.128
USER=ubuntu

PARAMS=""
case "$1" in
    -t|--train)
        mkdir -p $MODEL_DIR/experiment_dir_unpruned
        tlt-train mask_rcnn -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
                            -d $MODEL_DIR/experiment_dir_unpruned \
                            -k $KEY \
                            --gpus 1
        ls -ltrh $MODEL_DIR/experiment_dir_unpruned/
        ;;
    --eval)
        tlt-evaluate mask_rcnn -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
            -m $MODEL_DIR/experiment_dir_unpruned/model.step-25000.tlt \
            -k $KEY
        ;;
    -v|--vis)
        mkdir -p $MODEL_DIR/askrcnn_annotated_images
        tlt-infer mask_rcnn -i $DATA_DOWNLOAD_DIR/raw-data/test2017 \
            -o $MODEL_DIR/maskrcnn_annotated_images \
            -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
            -m $MODEL_DIR/experiment_dir_unpruned/model.step-25000.tlt \
            -l $SPECS_DIR/coco_labels.txt \
            -t 0.5 \
            -b 2 \
            -k $KEY \
            --include_mask
        python $PROGRAM_DIR/visualize.py
        ;;
    --vistrt)
        tlt-infer mask_rcnn --trt \
            -i $DATA_DOWNLOAD_DIR/raw-data/test2017/000000000001.jpg \
            -o $MODEL_DIR/maskrcnn_annotated_images/000000000001.jpg \
            -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
            -m $MODEL_DIR/export/model.step-25000.engine \
            -l $MODEL_DIR/maskrcnn_annotated_images/000000000001.json \
            -c $SPECS_DIR/coco_labels.txt \
            -t 0.5 \
            --include_mask
        ls -l $MODEL_DIR/maskrcnn_annotated_images
        ;;     
    --export)
        mkdir -p $MODEL_DIR/export 
        case '$2' in
            32)
                tlt-export mask_rcnn -m $MODEL_DIR/experiment_dir_unpruned/model.step-25000.tlt \
                    -k $KEY \
                    -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
                    --batch_size 1 \
                    --data_type fp32 \
                    --engine_file $MODEL_DIR/export/model.step-25000.engine                ;;
            8)
                tlt-export mask_rcnn -m $MODEL_DIR/experiment_dir_unpruned/model.step-25000.tlt \
                    -k $KEY \
                    -e $SPECS_DIR/maskrcnn_train_resnet50.txt \
                    --batch_size 1 \
                    --data_type int8 \
                    --cal_image_dir $DATA_DOWNLOAD_DIR/raw-data/val2017 \
                    --batches 10 \
                    --cal_cache_file $MODEL_DIR/export/maskrcnn.cal \
                    --cal_data_file $MODEL_DIR/export/maskrcnn.tensorfile                ;;
        esac
        # Check if etlt model is correctly saved.
        ls -l $MODEL_DIR/experiment_dir_unpruned/
        ;;
    --trt)
        case '$2' in
            16)
                tlt-converter -k $KEY  \
                -d 3,832,1344 \
                -o generate_detections,mask_head/mask_fcn_logits/BiasAdd \
                -e $MODEL_DIR/export/trt.fp16.engine \
                -t fp16 \
                -i nchw \
                -m 1 \
                $MODEL_DIR/experiment_dir_unpruned/model.step-25000.etlt
                ;;
            8)
                tlt-converter -k $KEY  \
                -d 3,832,1344 \
                -o generate_detections,mask_head/mask_fcn_logits/BiasAdd \
                -c $MODEL_DIR/export/maskrcnn.cal \
                -e $MODEL_DIR/export/trt.int8.engine \
                -b 8 \
                -m 1 \
                -t int8 \
                -i nchw \
                $MODEL_DIR/experiment_dir_unpruned/model.step-25000.etlt
        esac
        ;;
    -*|--*=) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        ;;
    *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        ;;
esac

# set positional arguments in their proper place
eval set -- "$PARAMS"
