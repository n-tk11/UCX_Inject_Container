#!/bin/bash

#SBATCH --job-name=GMX_ligno_native_4node
#SBATCH --out=%x.%j.out
#SBATCH --nodes=4
#SBATCH --tasks-per-node=13
#SBATCH --cpus-per-task=4

#SBATCH --distribution=block:block
#SBATCH --hint=multithread
#SBATCH --mail-user=tulkung123@gmail.com
#SBATCH --mail-type=END

export PATH=/work/sorawit-m/gromacs_mpich_nin/bin:$PATH

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

GMX_MAXBACKUP=-1 srun --mpi=pmi2 -n $SLURM_NTASKS  gmx_mpi mdrun -ntomp $SLURM_CPUS_PER_TASK -s /work/sorawit-m/gromacs_bench/ligno/lignocellulose.tpr -nsteps 50000
