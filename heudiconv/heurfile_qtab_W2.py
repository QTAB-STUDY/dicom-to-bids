# Heuristic file for Heudiconv dicom conversion - QTAB W2
# Author Lachlan Strike (w/ help from Liza van Eijk, Steffen Bollmann, Thomas Shaw)

import os
def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes
def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where
    allowed template fields - follow python string module:
    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """
    t1w_uniden = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_UNIT1_denoised')   
    t1w_uni = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_UNIT1')   
    t1w_inv1 = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_inv-1_MP2RAGE')   
    t1w_inv2 = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_inv-2_MP2RAGE')   
    t2w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T2w')
    flair = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_FLAIR')
    t2w_TSE = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-tse_run-{item:02d}_T2w')
    swi = create_key('sub-{subject}/{session}/swi/sub-{subject}_{session}_swi')
    swi_mag = create_key('sub-{subject}/{session}/swi/sub-{subject}_{session}_part-mag_GRE')
    swi_pha = create_key('sub-{subject}/{session}/swi/sub-{subject}_{session}_part-phase_GRE')
    swi_mIP = create_key('sub-{subject}/{session}/swi/sub-{subject}_{session}_minIP')
    dwi_AP_1 = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_dir-AP_run-01_dwi')
    dwi_AP_2 = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_dir-AP_run-02_dwi')
    dwi_PA_1 = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_dir-PA_run-01_dwi')
    dwi_PA_2 = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_dir-PA_run-02_dwi')
    rest_AP = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_dir-AP_bold')
    rest_PA = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_dir-PA_bold')
    partly_cloudy = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-partlycloudy_bold')
    emot_task = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-emotionalconflict_bold')
    fmap_AP = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_dir-AP_epi')
    fmap_PA = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_dir-PA_epi')
    asl_M0 = create_key('sub-{subject}/{session}/perf/sub-{subject}_{session}_m0scan')
    asl = create_key('sub-{subject}/{session}/perf/sub-{subject}_{session}_asl')
    
    info = {t1w_uniden: [], t1w_uni: [], t1w_inv1: [], t1w_inv2: [], partly_cloudy: [], emot_task: [], t2w: [], flair: [], t2w_TSE: [], swi: [], swi_mag: [], 
    swi_pha: [], swi_mIP: [], dwi_AP_1: [], dwi_AP_2: [], dwi_PA_1: [], dwi_PA_2: [], rest_AP: [], rest_PA: [], asl_M0: [], asl: [], fmap_AP: [], fmap_PA: []}
    
    for idx, s in enumerate(seqinfo):
        if ('MP2RAGE_wip900D_VE11C_INV2' in s.series_description):
            info[t1w_inv2] = [s.series_id]
        elif ('MP2RAGE_wip900D_VE11C_INV1' in s.series_description):
            info[t1w_inv1] = [s.series_id]
        elif('MP2RAGE_wip900D_VE11C_UNI_Images' in s.series_description):
            info[t1w_uni] = [s.series_id]
        elif('MP2RAGE_wip900D_VE11C_UNI-DEN' in s.series_description):
            info[t1w_uniden] = [s.series_id]
        elif ('MP2RAGE_wip925B_VE11C-0p8mm_INV2' in s.series_description):
            info[t1w_inv2] = [s.series_id]
        elif ('MP2RAGE_wip925B_VE11C-0p8mm_INV1' in s.series_description):
            info[t1w_inv1] = [s.series_id]
        elif('MP2RAGE_wip925B_VE11C-0p8mm_UNI_Images' in s.series_description):
            info[t1w_uni] = [s.series_id]
        elif('MP2RAGE_wip925B_VE11C-0p8mm_UNI-DEN' in s.series_description):
            info[t1w_uniden] = [s.series_id]
        elif ('PARTLY_CLOUDY_mb6_2.4' in s.series_description):
            info[partly_cloudy] = [s.series_id]         
        elif ('EMOT_TASK_mb6_2.4' in s.series_description):
            info[emot_task] = [s.series_id]                         
        elif ('t2_spc_sag_p2_iso' in s.series_description):
            info[t2w] = [s.series_id]
        elif ('t2_spc_da-fl_sag' in s.series_description):
            info[flair] = [s.series_id]     
        elif ('t2_tse_cor_0.5X0.5X1mm' in s.series_description):
            info[t2w_TSE].append([s.series_id]) 
        elif ('SWI_Images' in s.series_description):
            info[swi] = [s.series_id]  
        elif ('Mag_Images' in s.series_description):
            info[swi_mag] = [s.series_id]          
        elif ('Pha_Images' in s.series_description):
            info[swi_pha] = [s.series_id]   
        elif ('mIP_Images(SW)' in s.series_description):
            info[swi_mIP] = [s.series_id]
        elif ('AP_MULTIBAND_BLOCK_1_DIFFUSION_AP_22DIR_new_mono' in s.series_description):
            info[dwi_AP_1] = [s.series_id]
        elif ('AP_MULTIBAND_BLOCK_2_DIFFUSION_AP_22DIR_new_mono' in s.series_description):
            info[dwi_AP_2] = [s.series_id]
        elif ('PA_MULTIBAND_BLOCK_1_DIFFUSION_22DIR_mono' in s.series_description):
            info[dwi_PA_1] = [s.series_id]
        elif ('PA_MULTIBAND_BLOCK_2_DIFFUSION_22DIR_mono' in s.series_description):
            info[dwi_PA_2] = [s.series_id]
        elif ('ep2d_REST_SMS6_A-P' in s.series_description):
            info[rest_AP] = [s.series_id]
        elif ('ep2d_REST_SMS6_P-A' in s.series_description):
            info[rest_PA] = [s.series_id]
        elif ('AP_PR_EP2D_SE_FMAP' in s.series_description):
            info[fmap_AP] = [s.series_id]
        elif ('PA_PR_EP2D_SE_FMAP' in s.series_description):
            info[fmap_PA] = [s.series_id]     
        elif ('ep2d_bold_M0_FOR_VE11C' in s.series_description):
            info[asl_M0] = [s.series_id]
        elif ('ep2d_pcasl_ve11c' in s.series_description):
            info[asl] = [s.series_id]
    return info

