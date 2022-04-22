#!/bin/bash
#PBS -A UQ-QBI
#PBS -l select=1:ncpus=2:mem=10GB
#PBS -l walltime=12:00:00
#PBS -N pbsBIDS

module load singularity/2.5.2

code_dir=/home/uqlstri1/bin/qtab/data_management
data_dir=/scratch/user/uqlstri1/data_management/raw/wave1
BIDS_dir=/scratch/user/uqlstri1/data_management/BIDS_sorted
container_dir=/scratch/user/uqlstri1/containers

cd ${data_dir} || exit
 for subjID in *; do
     echo "$subjID"	
     cd "$data_dir" || exit
     singularity exec -B "${data_dir}":/dicoms:ro -B "$code_dir":/code -B "$BIDS_dir":/output "$container_dir"/heudiconv_v0.90.simg heudiconv -d /dicoms/{subject}/*/* -s "$subjID" -o /output -f /code/heurfile_qtab_W1.py -ss 01 --minmeta -b --overwrite
done
