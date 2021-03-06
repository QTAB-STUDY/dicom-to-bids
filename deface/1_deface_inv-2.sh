#!/bin/bash
#PBS -A UQ-QBI
#PBS -N pbsDeface
#PBS -l select=1:ncpus=6:mem=36GB
#PBS -l walltime=23:00:00

# Deface the inv-2 mp2rage image (rename to T1w for BIDSonym), T2w image, and FLAIR image (renamed to T2w)
module load singularity/2.5.2
BIDS_dir=/scratch/user/"$USER"/data_management/BIDS_deface

singularity run --cleanenv --bind ${BIDS_dir}:/BIDSdir /scratch/user/"$USER"/containers/bidsonym_v0.0.5.simg /BIDSdir group --deid mridefacer --brainextraction nobrainer --skip_bids_validation --deface_t2w
