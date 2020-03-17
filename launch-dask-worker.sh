#!/bin/bash
#PBS -N dask-worker
#PBS -l walltime=06:00:00
#PBS -j oe
#PBS -m abe

# prepare path
source "${conda_base}/etc/profile.d/conda.sh"

# launch environment
conda activate pbs
conda activate --stack "${env_name}"

# Setup dask worker
SCHEDULER=$HOME/scheduler.json

dask-worker \
    --nprocs ${nprocs} \
    --nthreads ${nthreads} \
    --memory-limit 16e9 \
    --local-directory /scratch/$USER \
    --scheduler-file $SCHEDULER
