# QTAB BIDS 
Code pertaining to the conversion and management of QTAB imaging data

DICOM format MRI data was converted to a BIDS compatible dataset using HeuDiConv(v0.9.0; https://github.com/nipy/heudiconv).
Facial features were removed from structural scans using BIDSonym (v0.0.5; https://github.com/peerherholz/bidsonym) and the FSL (v5.0.1; https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/) tools flirt and fslmaths. 
