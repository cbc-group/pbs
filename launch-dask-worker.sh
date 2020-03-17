#!/bin/bash
#PBS -N dask-worker
#PBS -l walltime=06:00:00
#PBS -j oe
#PBS -m abe

export PATH=$PATH:$PBS_O_PATH

# setup conda environment
conda activate pbs
conda activate --stack "$env_name"

# Setup dask worker
SCHEDULER=$HOME/scheduler.json

# each worker has a nanny
nprocs2=$(( 2*$nprocs )) 
mpirun -n $nprocs2 dask-mpi 
    --nthreads $nthreads \
    --memory-limit 16e9 \
    # network interface
#    --interface ib0 \
    # do not include a scheduler, in order to increase an existing cluster
    --no-scheduler \
    # local cache directory for the worker
    --local-directory /scratch/$USER \
    --scheduler-file=$SCHEDULER
