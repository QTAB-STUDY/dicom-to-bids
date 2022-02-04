#!/bin/bash
#PBS -A UQ-QBI
#PBS -N pbsDeface
#PBS -l select=1:ncpus=1:mem=8GB
#PBS -l walltime=23:00:00

# Output from 1_deface_inv-2.sh copied to "$DERIVATIVES_dir"
# Apply the mask from the inv-2_MP2RAGE image to the other MP2RAGE images

CODE_dir=/home/"$USER"/bin/qtab/data_management/defacing
BIDS_dir=/RDS/Q1319/01_data/01_imaging/06_bids/
DERIVATIVES_dir=/RDS/Q1319/01_data/01_imaging/06_bids/derivatives/defaced
CONTAINER_dir=/scratch/user/"$USER"/containers
ses="ses-02"

module load singularity/2.5.2
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/ $CONTAINER_dir/debian_9.4_mrtrix3_fsl5_v1.simg"

mkdir "$TMPDIR"/defaced
while read subjID
do
	mv "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_T1w_defacemask.nii.gz "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz
	cp -r "$DERIVATIVES_dir"/sub-"$subjID" "$TMPDIR"/defaced
	cp "$BIDS_dir"/sub-"$subjID"/"$ses"/anat/*UNIT1*.nii.gz "$TMPDIR"/defaced/sub-"$subjID"/"$ses"/anat
	cp "$BIDS_dir"/sub-"$subjID"/"$ses"/anat/*MP2RAGE* "$TMPDIR"/defaced/sub-"$subjID"/"$ses"/anat
	$singularity fslmaths /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_UNIT1.nii.gz \
	-mul /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_UNIT1_defaced.nii.gz
	$singularity fslmaths /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-1_MP2RAGE.nii.gz \
	-mul /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-1_MP2RAGE_defaced.nii.gz
	$singularity fslmaths /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE.nii.gz \
	-mul /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defaced.nii.gz
	$singularity fslmaths /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_UNIT1_denoised.nii.gz \
	-mul /TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_inv-2_MP2RAGE_defacemask.nii.gz \
	/TMPDIR/defaced/sub-"$subjID"/"$ses"/anat/sub-"$subjID"_"$ses"_UNIT1_denoised_defaced.nii.gz
	cp "$TMPDIR"/defaced/sub-"$subjID"/"$ses"/anat/*defaced.nii.gz "$DERIVATIVES_dir"/sub-"$subjID"/"$ses"/anat
done < "$CODE_dir"/ses-02_participants.txt
