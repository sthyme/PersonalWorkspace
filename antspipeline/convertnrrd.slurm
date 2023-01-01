#!/bin/bash

#SBATCH -p express # Partition to submit to

#SBATCH -n 1 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 20 # Runtime in minutes
#SBATCH --mem=4000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH --job-name=arrayJob
#SBATCH --array=1-174
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname
module load CMTK/3.3.1
#echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
#fish_32_02_warped.nii
#/n/schierfs2/projects/ImageRegistration/cmtk-3.2.3/build/bin/convertx images/$SLURM_ARRAY_TASK_ID/*.nrrd fish_$SLURM_ARRAY_TASK_ID.nii
/share/apps/rc/software/CMTK/3.3.1-src/bin/convertx fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii fish_$SLURM_ARRAY_TASK_ID\_01_warped.nrrd
/share/apps/rc/software/CMTK/3.3.1-src/bin/convertx fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii fish_$SLURM_ARRAY_TASK_ID\_02_warped.nrrd

#source new-modules.sh; module load fastqc
#fastqc --casava -o fastqc_reports A01_R1.pair.fastq.gz
