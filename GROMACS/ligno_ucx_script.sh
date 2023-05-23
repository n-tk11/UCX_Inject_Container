#!/bin/bash

#SBATCH --job-name=ligno_test_UCXRepl_4n
#SBATCH --nodes=4
#SBATCH --tasks-per-node=13
#SBATCH --cpus-per-task=4
#SBATCH --exclusive

#SBATCH --distribution=block:block
#SBATCH --hint=multithread
#SBATCH --mail-user=tulkung123@gmail.com
#SBATCH --mail-type=END
#SBATCH --out=%x.%j.out

module load singularity
module load compiler/intel
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export BIND_ARG2="/usr/lib/ucx:/opt/ucx/lib/ucx,/usr/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/usr/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/usr/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/usr/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/usr/bin/ucx_info:/opt/ucx/bin/ucx_info,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/work/sorawit-m/gromacs_bench/ligno/lignocellulose.tpr:/opt/lignocellulose.tpr"


GMX_MAXBACKUP=-1 srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/gromacs_bench/gromacs_mpich_ucx.sif gmx_mpi mdrun -ntomp $SLURM_CPUS_PER_TASK -s /opt/lignocellulose.tpr -nsteps 50000
