#!/bin/bash -x

set -o allexport
source .env
set +o allexport

CONFIG_PATH=$1
EXPERIMENT_NAME=$2

if [ -z "$CONFIG_PATH" ] || [ -z "$EXPERIMENT_NAME" ]; then
  echo "Usage: $0 <config_path> <experiment_name>"
  exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Error: Config file $CONFIG_PATH does not exist."
  exit 1
fi

if [ -z "$MINIO_ENDPOINT" ] || [ -z "$MINIO_ROOT_USER" ] || [ -z "$MINIO_ROOT_PASSWORD" ]; then
  echo "Error: S3 environment variables are not set."
  exit 1
fi

param_combinations=$(python3 -c "
import json
import itertools
with open('$CONFIG_PATH') as f:
    config = json.load(f)
    param_combinations = list(itertools.product(*config.values()))
    for params in param_combinations:
        print('$EXPERIMENT_NAME_' + '_'.join(map(str, params)))
")

for experiment_name_unique in $param_combinations; do
  echo "Running experiment: $experiment_name_unique"

  docker run --rm \
    --network ml_hw_my_network \
    --env WANDB_API_KEY=$WANDB_API_KEY \
    -v "$(pwd)/ml_hw_4:/app/ml_hw_4" \
    -v "$(pwd)/models:/app/models" \
    -v "$(pwd)/data:/app/data" \
    -v "$(pwd)/output:/app/output" \
    trainer:latest \
    python ml_hw_4/modeling/train.py \
    --config "/app/$CONFIG_PATH" \
    --dataset "/app/data/processed/weather_forecast_data_processed.csv" \
    --experiment "$experiment_name_unique"
done