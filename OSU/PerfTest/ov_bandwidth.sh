#!/bin/bash
#SBATCH --job-name overhead_osu_bw_nin
#SBATCH -N 2 # total number of nodes
#SBATCH --time=01:00:00 # Max execution time
#SBATCH --ntasks-per-node=1 
#SBATCH --out=%x.%j.out
#SBATCH --exclusive

export WORKDIR=/work/sorawit-m
export OSU_BW=libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

export LIBIB_BIND="/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200"



export BIND_ARG2="/usr/lib/ucx:/opt/ucx/lib/ucx,/usr/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/usr/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/usr/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/usr/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/usr/bin/ucx_info:/opt/ucx/bin/ucx_info,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200"

export MPI_REPL="/work/sorawit-m/mpich_intel:/opt/mpich,/usr/local/intel/oneapi/compiler/2022.0.2/linux/compiler/lib/intel64_lin:/opt/intel_compiler/lib,/lib/x86_64-linux-gnu/libfabric.so.1:/lib/x86_64-linux-gnu/libfabric.so.1,/lib/libucp.so.0:/lib/libucp.so.0,/lib/libuct.so.0:/lib/libuct.so.0,/lib/libucm.so.0:/lib/libucm.so.0,/lib/libucs.so.0:/lib/libucs.so.0,/lib/x86_64-linux-gnu/librdmacm.so.1:/lib/x86_64-linux-gnu/librdmacm.so.1,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/lib/x86_64-linux-gnu/libpsm_infinipath.so.1:/lib/x86_64-linux-gnu/libpsm_infinipath.so.1,/lib/libosmcomp.so.3:/lib/libosmcomp.so.3,/lib/x86_64-linux-gnu/libpsm2.so.2:/lib/x86_64-linux-gnu/libpsm2.so.2,/etc/libibverbs.d:/etc/libibverbs.d,/lib/x86_64-linux-gnu/libinfinipath.so.4:/lib/x86_64-linux-gnu/libinfinipath.so.4,/usr/lib/x86_64-linux-gnu/libibverbs/libmlx5-rdmav34.so:/lib/x86_64-linux-gnu/libmlx5-rdmav34.so,/usr/bin/ucx_info:/usr/bin/ucx_info,/usr/lib/ucx:/usr/lib/ucx,/lib/x86_64-linux-gnu/libhwloc.so.15:/lib/x86_64-linux-gnu/libhwloc.so.15,/lib/x86_64-linux-gnu/libltdl.so.7:/lib/x86_64-linux-gnu/libltdl.so.7"

module load singularity

echo "%1 OV1_latency"
srun --mpi=pmi2 -n 2 $WORKDIR/osu_mpich/$OSU_BW
echo "%2 OV2_latency"
srun --mpi=pmi2 -n 2 singularity exec --bind $BIND_ARG2 $WORKDIR/osu_container/osu_noib_ubuntu22.sif /opt/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

echo "%3 OV3_latency"
srun --mpi=pmi2 -n 2 singularity exec --bind $LIBIB_BIND $WORKDIR/osu_container/osu_noib_ubuntu22.sif /opt/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

echo "%4 OV4_latency"
srun --mpi=pmi2 -n 2 singularity exec $WORKDIR/osu_container/osu_noucx_mpich.sif /opt/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

echo "%5 OV5_latency"
srun --mpi=pmi2 -n 2 singularity exec --bind $MPI_REPL $WORKDIR/osu_container/osu_noucx_mpich.sif /opt/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw

echo "#END TEST WITH OSU_LATENCY"
