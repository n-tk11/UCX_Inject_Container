#!/bin/bash
#SBATCH --nodes=16              # Number of nodes
#SBATCH --ntasks-per-node=52   # Number of MPI ranks per node
#SBATCH --cpus-per-task=1    # Number of OpenMP threads for each MPI process/rank
#SBATCH --job-name=test_hpcg_native_ucx_16n
#SBATCH --out=%x.%j.out


export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export BIND_ARG2="/usr/lib/ucx:/opt/ucx/lib/ucx,/usr/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/usr/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/usr/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/usr/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/usr/bin/ucx_info:/opt/ucx/bin/ucx_info,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/work/sorawit-m/hpcg-3.1/bin/container_run/hpcg.dat:/opt/hpcg-3.1/bin/hpcg.dat"

module load singularity

srun --mpi=pmi2 -n $SLURM_NTASKS ./xhpcg


srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/hpcg-3.1/bin/container_run/hpcg_mpich_ucx.sif  /opt/hpcg-3.1/bin/xhpcg
