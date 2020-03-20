#!/bin/bash
#PBS -N dask-scheduler
#PBS -l nodes=1:ppn=4
#PBS -j oe
#PBS -m abe

# -N    job name
# -l    resource list
# -j    join standard output/error stream
# -m    define mail message condition, abort/begin/terminate

terminate_ssh() {
    echo "SIGTERM, terminating the reverse tunnel"
    ssh -S $HOME/scheduler.socket -O exit warp
    rm -f $HOME/scheduler.socket
}

trap terminate_ssh SIGTERM

# prepare path
source "${conda_base}/etc/profile.d/conda.sh"

# establish reverse tunnel to the head node
#   - use control file to close the socket
#   - since bokeh use websocket later on, ssh tunneling failed somehow 
ssh -fN \
    -M -S $HOME/scheduler.socket \
    -R 8786:localhost:8786 \
    warp

# launch environment
conda activate pbs

SCHEDULER=$HOME/scheduler.json
rm -f $SCHEDULER

# create worker space
SPACE=/scratch/$USER/dask-worker-space
mkdir -p ${SPACE}

dask-scheduler \
    --no-dashboard \
    --local-directory ${SPACE} \
    --scheduler-file $SCHEDULER
