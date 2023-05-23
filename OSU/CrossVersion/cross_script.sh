#!/bin/bash
#SBATCH --job-name Test_with_osu_combi_wucx1_14
#SBATCH -N 2 # total number of nodes
#SBATCH --time=01:00:00 # Max execution time
#SBATCH --ntasks-per-node=1 
#SBATCH --out=%x.%j.out
#SBATCH --exclusive

export BIND_ARG="/lib/ucx:/opt/ucx/lib/ucx,/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0"

export BIND_ARG2="/work/sorawit-m/ucx_install2/lib/ucx:/opt/ucx/lib/ucx,/work/sorawit-m/ucx_install2/lib/libuct.so.0:/opt/ucx/lib/libuct.so.0,/work/sorawit-m/ucx_install2/lib/libucp.so.0:/opt/ucx/lib/libucp.so.0,/work/sorawit-m/ucx_install2/lib/libucs.so.0:/opt/ucx/lib/libucs.so.0,/work/sorawit-m/ucx_install2/lib/libucm.so.0:/opt/ucx/lib/libucm.so.0,/lib/x86_64-linux-gnu/libibverbs.so.1:/lib/x86_64-linux-gnu/libibverbs.so.1,/lib/x86_64-linux-gnu/libmlx5.so.1:/lib/x86_64-linux-gnu/libmlx5.so.1,/lib/x86_64-linux-gnu/libnl-route-3.so.200:/lib/x86_64-linux-gnu/libnl-route-3.so.200,/lib/x86_64-linux-gnu/libnl-3.so.200:/lib/x86_64-linux-gnu/libnl-3.so.200"

module load singularity

for i in {1..10}
do
	echo "%$i Begin Test"
	UCX_LOG_LEVEL=info srun --mpi=pmi2 -n 2 singularity exec --bind $BIND_ARG2 ucx_injection_containers_osucombi$i.sif /opt/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

done

echo "All Test Done"
