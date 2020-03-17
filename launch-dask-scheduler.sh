#!/bin/bash
#PBS -N dask-scheduler
#PBS -l walltime=06:00:00
#PBS -j oe
#PBS -m abe

# -N    job name
# -l    resource list
# -j    join standard output/error stream
# -m    define mail message condition, abort/begin/terminate

# setup conda environment
echo "conda @ $conda"

$conda activate pbs

SCHEDULER=$HOME/scheduler.json
rm -f $SCHEDULER

# scheulder on rank 0, workers/nannies on remaining ranks
# so we restrict to 1 rank for scheduler job
mpirun -n 1 dask-mpi 
    --nthreads 4 \
    --memory-limit 16e9 \
    # network interface
#    --interface ib0 \
    # local cache directory for the worker
    --local-directory /scratch/$USER \
    --scheduler-file=$SCHEDULER
