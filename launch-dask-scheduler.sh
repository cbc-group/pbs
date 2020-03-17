#!/bin/bash
#PBS -N dask-scheduler
#PBS -l walltime=06:00:00
#PBS -j oe
#PBS -m abe

# -N    job name
# -l    resource list
# -j    join standard output/error stream
# -m    define mail message condition, abort/begin/terminate

# prepare path
source "${conda_base}/etc/profile.d/conda.sh"

# launch environment
conda activate pbs

SCHEDULER=$HOME/scheduler.json
rm -f $SCHEDULER

# scheulder on rank 0, workers/nannies on remaining ranks
# so we restrict to 1 rank for scheduler job
dask-scheduler \
    # network interface
#    --interface ib0 \
    # local cache directory for the worker
    --local-directory /scratch/$USER \
    --scheduler-file=$SCHEDULER
