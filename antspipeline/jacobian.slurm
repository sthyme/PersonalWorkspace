#!/bin/bash

#SBATCH -p express # Partition to submit to

#SBATCH -n 1 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 5 # Runtime in minutes
#SBATCH --array=3-96
#SBATCH --mem=16000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname

module load Clang
#fish_66_01_1Warp.nii.gz`
/home/sthyme/install/bin/CreateJacobianDeterminantImage 3 fish_$SLURM_ARRAY_TASK_ID\_01_1Warp.nii.gz jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1 0
/home/sthyme/install/bin/ConvertImagePixelType jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1
