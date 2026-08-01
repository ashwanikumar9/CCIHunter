#!/bin/bash

# Server Execution Pipeline with Checkpoints for CCIHunter
# Usage: ./run_pipeline.sh

# Hardcoded defaults for a server environment
DATA_PATH="../dataset"
GPU_FLAG="True"  # Use True by default for server execution

PRETRAIN_MODEL="model.pth"
MUTATE_MODEL="model_mutate2.pth"

echo "========================================="
echo "Starting Pipeline with checkpoints"
echo "DATA_PATH: $DATA_PATH"
echo "GPU_FLAG: $GPU_FLAG"
echo "========================================="

# Stage 1: Contrastive Training
if [ ! -f ".checkpoint_stage1" ]; then
    echo "[$(date)] Starting Stage 1: train_contrastive.py"
    
    python train_contrastive.py --data_path "$DATA_PATH" --gpu "$GPU_FLAG"
    
    # Check if the command succeeded
    if [ $? -eq 0 ]; then
        touch .checkpoint_stage1
        echo "Stage 1 completed successfully. Checkpoint saved."
    else
        echo "Error: Stage 1 failed. Exiting pipeline."
        exit 1
    fi
else
    echo "Skipping Stage 1 (found .checkpoint_stage1)."
fi

echo "-----------------------------------------"

# Stage 2: Mutation Training
if [ ! -f ".checkpoint_stage2" ]; then
    echo "[$(date)] Starting Stage 2: train_mutate.py"
    
    python train_mutate.py --data_path "$DATA_PATH" --pretrain_path "$PRETRAIN_MODEL" --gpu "$GPU_FLAG"
    
    if [ $? -eq 0 ]; then
        touch .checkpoint_stage2
        echo "Stage 2 completed successfully. Checkpoint saved."
    else
        echo "Error: Stage 2 failed. Exiting pipeline."
        exit 1
    fi
else
    echo "Skipping Stage 2 (found .checkpoint_stage2)."
fi

echo "-----------------------------------------"

# Stage 3: Classifier Training
if [ ! -f ".checkpoint_stage3" ]; then
    echo "[$(date)] Starting Stage 3: train_classifier.py"
    
    python train_classifier.py --data_path "$DATA_PATH" --pretrain_path "$MUTATE_MODEL" --gpu "$GPU_FLAG"
    
    if [ $? -eq 0 ]; then
        touch .checkpoint_stage3
        echo "Stage 3 completed successfully. Checkpoint saved."
    else
        echo "Error: Stage 3 failed. Exiting pipeline."
        exit 1
    fi
else
    echo "Skipping Stage 3 (found .checkpoint_stage3)."
fi

echo "-----------------------------------------"
echo "Pipeline execution finished successfully."
echo "Note: test.py was skipped because it requires a saved random forest model (--rf_path)."
