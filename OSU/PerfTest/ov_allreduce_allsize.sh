#!/bin/bash
#SBATCH --job-name osu_allreduce_8n_allsize_nointel
#SBATCH -N 8 # total number of nodes
#SBATCH --time=01:00:00 # Max execution time
#SBATCH --ntasks-per-node=1 
#SBATCH --out=%x.%j.out
#SBATCH --exclusive

export NNODE=8
export WORKDIR=/work/sorawit-m
export OSU_LATENCY=libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
export OSU_ALLREDUCE=libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce

export LIBIB_BIND="/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200"


export BIND_ARG2="/usr/lib/ucx:/opt/ucx/lib/ucx,/usr/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/usr/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/usr/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/usr/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/usr/bin/ucx_info:/opt/ucx/bin/ucx_info,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/lib/x86_64-linux-gnu/librdmacm.so.1:/lib/x86_64-linux-gnu/librdmacm.so.1"


export MPI_REPL="/work/sorawit-m/mpich_install_4.1.1:/opt/mpich,/lib/libucp.so.0:/lib/libucp.so.0,/lib/libuct.so.0:/lib/libuct.so.0,/lib/libucm.so.0:/lib/libucm.so.0,/lib/libucs.so.0:/lib/libucs.so.0,/lib/x86_64-linux-gnu/librdmacm.so.1:/lib/x86_64-linux-gnu/librdmacm.so.1,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/lib/x86_64-linux-gnu/libpsm_infinipath.so.1:/lib/x86_64-linux-gnu/libpsm_infinipath.so.1,/lib/libosmcomp.so.3:/lib/libosmcomp.so.3,/lib/x86_64-linux-gnu/libpsm2.so.2:/lib/x86_64-linux-gnu/libpsm2.so.2,/etc/libibverbs.d:/etc/libibverbs.d,/lib/x86_64-linux-gnu/libinfinipath.so.4:/lib/x86_64-linux-gnu/libinfinipath.so.4,/usr/lib/x86_64-linux-gnu/libibverbs/libmlx5-rdmav34.so:/lib/x86_64-linux-gnu/libmlx5-rdmav34.so,/usr/bin/ucx_info:/usr/bin/ucx_info,/usr/lib/ucx:/usr/lib/ucx,/lib/x86_64-linux-gnu/libhwloc.so.15:/lib/x86_64-linux-gnu/libhwloc.so.15,/lib/x86_64-linux-gnu/libltdl.so.7:/lib/x86_64-linux-gnu/libltdl.so.7"

module load singularity

	echo "%1 Native "
	srun --mpi=pmi2 -n $NNODE $WORKDIR/osu_mpich/$OSU_ALLREDUCE
	echo "%2 UCX replace"
	srun --mpi=pmi2 -n $NNODE singularity exec --bind $BIND_ARG2 $WORKDIR/osu_container/osu_noib_ubuntu22.sif /opt/$OSU_ALLREDUCE


echo "#END TEST WITH OSU_ALLREDUCE"
