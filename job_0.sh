#!/usr/bin/env bash
#SBATCH --job-name=mijieux0
#SBATCH --output=out.0
#SBATCH --error=err.0
#SBATCH -p mistral
#SBATCH --time=02:00:00
#SBATCH --exclusive
#SBATCH --nodes=4
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task 10

# 4 noeud / 1 proc mpi par noeud

WORKDIR=${WORKDIR:-${HOME}/matprodmpi}

cd ${WORKDIR}
. ./.module.load

mpd & 

do_job() {
    size=$1
    file=mat0_$size.txt
    ./genmat/genmat -b -s $size > $file
    mpirun -n 4 ./matprod -b -p $file $file
    rm $file
}

for i in $(seq 100 100 1000); do
    do_job $i
done

do_job 2500

for i in $(seq 5000 5000 20000); do
    do_job $i
done

