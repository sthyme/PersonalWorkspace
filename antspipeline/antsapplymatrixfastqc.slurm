#!/bin/bash

#SBATCH -p serial_requeue # Partition to submit to

#SBATCH -n 32 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 20 # Runtime in minutes
#SBATCH --mem=8000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname
#SBATCH --job-name=arrayJob
#SBATCH --array=140-172

/n/schierfs2/projects/ImageRegistration/ANTScode/ANTs/build/bin/antsApplyTransforms -d 3 -v 0 --float -n WelchWindowedSinc -i images/$SLURM_ARRAY_TASK_ID\/arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p$SLURM_ARRAY_TASK_ID\_03.nii.gz -r Ref20131120pt14pl2.nii -o fish$SLURM_ARRAY_TASK_ID\-03_Warped.nii -t fish$SLURM_ARRAY_TASK_ID\_1Warp.nii.gz -t fish$SLURM_ARRAY_TASK_ID\_0GenericAffine.mat


#source new-modules.sh; module load fastqc
#fastqc --casava -o fastqc_reports A01_R1.pair.fastq.gz
