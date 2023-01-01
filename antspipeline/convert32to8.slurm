#!/bin/bash

#SBATCH -p express # Partition to submit to

#SBATCH -n 1 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 10 # Runtime in minutes
#SBATCH --array=1-96
#SBATCH --mem=48000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname

module load Clang

/home/sthyme/install/bin/ConvertImagePixelType fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1
#/home/sthyme/install/bin/CreateJacobianDeterminantImage 3 fish_$SLURM_ARRAY_TASK_ID\_01_1Warp.nii.gz jacobian_35_01_1Warp.nii.gz 1 0
