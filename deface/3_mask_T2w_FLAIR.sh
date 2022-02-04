#!/bin/bash
#PBS -A UQ-QBI
#PBS -N pbs_deface
#PBS -l select=1:ncpus=1:mem=8GB
#PBS -l walltime=23:00:00

# Output from 2_mask_mp2rage.sh copied to "$DERIVATIVES_dir"
# Apply the mask from the inv-2_MP2RAGE image to T2w & FLAIR scans (after registration to inv-2)

CODE_dir=/home/"$USER"/bin/qtab/data_management/defacing
BIDS_dir=/RDS/Q1319/01_data/01_imaging/06_bids
DERIVATIVES_dir=/RDS/Q1319/01_data/01_imaging/06_bids/derivatives/defaced
DATA_dir="$TMPDIR"/BIDS_dir
CONTAINER_dir=/scratch/user/"$USER"/containers

ses="ses-02"
module load singularity/2.5.2
singularity="singularity exec --bind $DATA_dir:/TMPDIR --pwd /TMPDIR/ "$CONTAINER_dir"/debian_9.4_mrtrix3_fsl5_v1.simg"

while read -r subjID; do
	echo sub-"$subjID"
	mkdir -p "$DATA_dir"/sub-"$subjID"/"$ses"/anat
	cp "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz "$DATA_dir"/sub-"$subjID"/"$ses"/anat
	cp "$BIDS_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w.nii.gz "$DATA_dir"/sub-"$subjID"/"$ses"/anat
	cp "$BIDS_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR.nii.gz "$DATA_dir"/sub-"$subjID"/"$ses"/anat
	cp "$BIDS_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE.nii.gz "$DATA_dir"/sub-"$subjID"/"$ses"/anat
	$singularity flirt -in /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w.nii.gz -ref /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE.nii.gz \
	-dof 6 -cost corratio -omat /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w_to_inv-2.mat -out /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w_to_inv-2.nii.gz
	$singularity flirt -in /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR.nii.gz -ref /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE.nii.gz \
	-dof 6 -cost corratio -omat /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR_to_inv-2.mat -out /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR_to_inv-2.nii.gz
	$singularity fslmaths /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w_to_inv-2.nii.gz \
	-mul /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w_defaced.nii.gz
	$singularity fslmaths /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR_to_inv-2.nii.gz \
	-mul /TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR_defaced.nii.gz
	cp "$DATA_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T2w_defaced.nii.gz "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat
	cp "$DATA_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_FLAIR_defaced.nii.gz "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat
	cp "$DATA_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_*.mat "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat
done < "$CODE_dir"/ses-02_participants.txt
