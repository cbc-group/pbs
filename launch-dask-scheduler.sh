#!/bin/bash
#PBS -N dask-scheduler
#PBS -l walltime=06:00:00
#PBS -j oe
#PBS -m abe

# -N    job name
# -l    resource list
# -j    join standard output/error stream
# -m    define mail message condition, abort/begin/terminate

terminate_ssh() {
    echo "SIGTERM, terminating reverse tunnel"
    ssh -S $HOME/scheduler.socket -O exit warp
}

# prepare path
source "${conda_base}/etc/profile.d/conda.sh"

# establish reverse tunnel to the head node
# .. use control file in master mode for control
ssh -fN -M -S $HOME/scheduler.socket -R 8786:localhost:8786 warp # scheduler

# launch environment
conda activate pbs

SCHEDULER=$HOME/scheduler.json
rm -f $SCHEDULER

# scheulder on rank 0, workers/nannies on remaining ranks
# so we restrict to 1 rank for scheduler job
dask-scheduler \
    --local-directory /scratch/$USER \
    --scheduler-file $SCHEDULER
