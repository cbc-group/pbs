#!/bin/bash
#PBS -j oe
#PBS -m abe

# prepare path
source "${conda_base}/etc/profile.d/conda.sh"

# restrict gpu id if this is a gpu worker
if [[ $PBS_O_QUEUE == gpu* ]]; then
    export CUDA_VISIBLE_DEVICES=$(/opt/bin/get_gpuid)
    echo "Assigned GPU $CUDA_VISIBLE_DEVICES"
fi

# launch environment
conda activate pbs
conda activate --stack "${env_name}"

# setup dask scheduler 
SCHEDULER=$HOME/scheduler.json

# create worker space
SPACE=/scratch/$USER/dask-worker-space
mkdir -p ${SPACE}

dask-worker \
    --nprocs ${nprocs} \
    --nthreads ${nthreads} \
    --memory-limit 16e9 \
    --local-directory ${SPACE} \
    --scheduler-file $SCHEDULER
