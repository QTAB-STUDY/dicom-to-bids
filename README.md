# QTAB BIDS 

## DICOM-to-BIDS
DICOM format MRI data was converted to a BIDS compatible dataset using HeuDiConv (v0.9.0; https://github.com/nipy/heudiconv).

## Defacing
Facial features were removed from structural scans using BIDSonym (v0.0.5; https://github.com/peerherholz/bidsonym) and the FSL (v5.0.1; https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/) tools flirt and fslmaths. Due to the amplified background noise present in the MP2RAGE uniform image (*UNIT1*), the defacing algorithm was applied to the second inversion image (*inv-2_MP2RAGE*). The mask created through this process was then applied to the other MP2RAGE images (*inv-1_MP2RAGE, UNIT1, UNIT1_denoised*), as well as the T2-weighted and FLAIR images (after registration of the T2-weighted and FLAIR images to the MP2RAGE second inversion image).
