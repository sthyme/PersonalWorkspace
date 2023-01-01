#!/bin/bash

#SBATCH -p short # Partition to submit to

#SBATCH -n 8 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 720 # Runtime in minutes
#SBATCH --array=1-96
#SBATCH --mem=48000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname

#/n/schierfs2/projects/ImageRegistration/ANTScode/ANTs/build/bin/antsRegistration -d 3 --float 1 -o [fish1_,fish1_Warped.nii.gz] --interpolation WelchWindowedSinc --use-histogram-matching 0 -r [Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1] -t rigid[0.1] -m MI[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t Affine[0.1] -m MI[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t SyN[0.1,6,0] -m CC[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,2] -c [200x200x200x200x10,1e-7,10] --shrink-factors 12x8x4x2x1 --smoothing-sigmas 4x3x2x1x0vox

module load Clang

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$SLURM_CPUS_PER_TASK
/home/sthyme/install/bin/antsRegistration -d 3 --float 1 -o [fish_$SLURM_ARRAY_TASK_ID\_01_,fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii] --interpolation WelchWindowedSinc --use-histogram-matching 0 -r [reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1] -t rigid[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t Affine[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t SyN[0.1,6,0] -m CC[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,2] -c [200x200x200x200x10,1e-7,10] --shrink-factors 12x8x4x2x1 --smoothing-sigmas 4x3x2x1x0vox

#/share/apps/rc/software/ANTs/2.1.0rc3-foss-2016a/bin/antsRegistration -d 3 --float 1 -o [fish_$SLURM_ARRAY_TASK_ID\_02_,fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii] --interpolation WelchWindowedSinc --use-histogram-matching 0 -r [reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1] -t rigid[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t Affine[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t SyN[0.1,6,0] -m CC[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,2] -c [200x200x200x200x10,1e-7,10] --shrink-factors 12x8x4x2x1 --smoothing-sigmas 4x3x2x1x0vox


#source new-modules.sh; module load fastqc
#fastqc --casava -o fastqc_reports A01_R1.pair.fastq.gz
