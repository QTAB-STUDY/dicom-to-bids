#!/bin/bash
# LT Strike
# Requires ANTS, FSL
# Produce brain extracted MP2RAGE (based on inv-2 - bet fails on UNIT1 due to excessive background noise)

# Local (Neurodesktop)
ml ants/2.3.5
ml fsl/6.0.4
data_dir=/neurodesktop-storage/qtab_bids
output_dir="$data_dir"/derivatives/MP2RAGE_preprocessing

# Cluster
# export FSLDIR=/usr/local/fsl
# data_dir=/qtab_data
# output_dir=/qtab_output 
# code_dir=/code

participantID="$@"
ses=ses-02

# Organise the data
echo Now running "$participantID"
cd "$data_dir"
mkdir -p "$data_dir"/derivatives/MP2RAGE_preprocessing/"$participantID"
cp "$data_dir"/"$participantID"/"$ses"/anat/"$participantID"_"$ses"_inv-2_MP2RAGE.nii.gz "$output_dir"/"$participantID"
cp "$data_dir"/"$participantID"/"$ses"/anat/"$participantID"_"$ses"_UNIT1.nii.gz "$output_dir"/"$participantID"

cd "$output_dir"/"$participantID" || exit

# Bias correct the inv-2 image (ANTS)
N4BiasFieldCorrection -i "$participantID"_"$ses"_inv-2_MP2RAGE.nii.gz -o "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz

# Use fsl standard_space_roi to create a brain mask (based on the inv-2 image) and use this mask to obtain the UNIT1 brain
standard_space_roi "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz ssroi_"$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz -b
bet ssroi_"$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain.nii.gz -f 0.2 -m
fslmaths "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain_mask.nii.gz -ero "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain_mask_ero.nii.gz
fslmaths "$participantID"_"$ses"_UNIT1.nii.gz -mul "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain_mask_ero.nii.gz "$participantID"_"$ses"_UNIT1_brain.nii.gz

# Cleanup
rm -f ssroi_"$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz
rm -f "$participantID"_"$ses"_UNIT1.nii.gz
rm -f "$participantID"_"$ses"_inv-2_MP2RAGE.nii.gz
rm -f "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected.nii.gz
rm -f "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain.nii.gz
rm -f "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain_mask.nii.gz
rm -f "$participantID"_"$ses"_inv-2_MP2RAGE_N4corrected_brain_mask_ero.nii.gz 
