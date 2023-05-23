#!/bin/bash
#SBATCH --nodes=32              # Number of nodes
#SBATCH --ntasks-per-node=32   # Number of MPI ranks per node
#SBATCH --cpus-per-task=1    # Number of OpenMP threads for each MPI process/rank
#SBATCH --job-name=nas_test_32n
#SBATCH --out=%x.%j.out
#SBATCH --mail-user=tulkung123@gmail.com
#SBATCH --mail-type=END
#SBATCH --exclusive 
module load singularity
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export UCX_WARN_UNUSED_ENV_VARS=n

export BIND_ARG2="/usr/lib/ucx:/opt/ucx/lib/ucx,/usr/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/usr/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/usr/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/usr/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/usr/bin/ucx_info:/opt/ucx/bin/ucx_info,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/work/sorawit-m/hpcg-3.1/bin/container_run/hpcg.dat:/opt/hpcg-3.1/bin/hpcg.dat"

echo "CG Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/cg.C.x

echo "CG Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/cg.C.x

echo "MG Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/mg.C.x

echo "MG Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/mg.C.x

echo "FT Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/ft.C.x

echo "FT Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/ft.C.x

echo "BT Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/bt.C.x

echo "BT Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/bt.C.x

echo "SP Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/sp.C.x

echo "SP Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2 /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/sp.C.x

echo "LU Native"
srun --mpi=pmi2 -n $SLURM_NTASKS /work/sorawit-m/NPB3.4.2/NPB3.4-MPI/bin/lu.C.x

echo "LU Cont"
srun --mpi=pmi2 -n $SLURM_NTASKS singularity exec --bind $BIND_ARG2  /work/sorawit-m/NAS_bench/nas_mpich_ucx3.sif /opt/NPB3.4.2/NPB3.4-MPI/bin/lu.C.x
