#!/bin/bash

#SBATCH -p express # Partition to submit to

#SBATCH -n 1 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 120 # Runtime in minutes
#SBATCH --array=97-174
#SBATCH --mem=48000 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -o hostname_%A_%a.out # Standard out goes to this file
#SBATCH -e hostname_%A_%a.err # Standard err goes to this filehostname

#/n/schierfs2/projects/ImageRegistration/ANTScode/ANTs/build/bin/antsRegistration -d 3 --float 1 -o [fish1_,fish1_Warped.nii.gz] --interpolation WelchWindowedSinc --use-histogram-matching 0 -r [Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1] -t rigid[0.1] -m MI[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t Affine[0.1] -m MI[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t SyN[0.1,6,0] -m CC[Ref20131120pt14pl2.nii,arl6ip4arl6ip4satb1abmir137_2016_11_01__19_42_10__p001_01.nii.gz,1,2] -c [200x200x200x200x10,1e-7,10] --shrink-factors 12x8x4x2x1 --smoothing-sigmas 4x3x2x1x0vox

module load Clang

#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=16
#export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$SLURM_CPUS_PER_TASK
# do the registration, with these faster parameters
/home/sthyme/install/bin/antsRegistration --dimensionality 3 --float 0 --collapse-output-transforms 1 -o [fish_$SLURM_ARRAY_TASK_ID\_01_,fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii] --interpolation Linear --use-histogram-matching 0 --winsorize-image-intensities [ 0.005,0.995 ] -r [reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1] -t rigid[0.1] --metric MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,32,Regular,0.25] --convergence [ 1000x500x250x0,1e-6,10 ] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox --transform Affine[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,32,Regular,0.25] --convergence [ 1000x500x250x0,1e-6,10 ] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox --transform SyN[0.1,3,0] --metric MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_01.nii.gz,1,32] --convergence [ 100x100x70x50x0,1e-6,10 ] --shrink-factors 10x6x4x2x1 --smoothing-sigmas 5x3x2x1x0vox

# convert pixel type to 8-bit and overwrite the 32-bit
/home/sthyme/install/bin/ConvertImagePixelType fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii fish_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1

# make the jacobian determinant and convert the result to 8-bit
/home/sthyme/install/bin/CreateJacobianDeterminantImage 3 fish_$SLURM_ARRAY_TASK_ID\_01_1Warp.nii.gz jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1 0
/home/sthyme/install/bin/ConvertImagePixelType jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii jacobian_$SLURM_ARRAY_TASK_ID\_01_warped.nii 1

# transform channels to move the pErk based on the tErk channel
/home/sthyme/install/bin/antsApplyTransforms -d 3 -v 0 --float -n WelchWindowedSinc -i fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz -r reference.nii.gz -o fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii -t fish_$SLURM_ARRAY_TASK_ID\_01_1Warp.nii.gz -t fish_$SLURM_ARRAY_TASK_ID\_01_0GenericAffine.mat
/home/sthyme/install/bin/ConvertImagePixelType fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii 1


#/share/apps/rc/software/ANTs/2.1.0rc3-foss-2016a/bin/antsRegistration -d 3 --float 1 -o [fish_$SLURM_ARRAY_TASK_ID\_02_,fish_$SLURM_ARRAY_TASK_ID\_02_warped.nii] --interpolation WelchWindowedSinc --use-histogram-matching 0 -r [reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1] -t rigid[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t Affine[0.1] -m MI[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,32,Regular,0.25] -c [200x200x200x0,1e-8,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox -t SyN[0.1,6,0] -m CC[reference.nii.gz,fish_$SLURM_ARRAY_TASK_ID\_02.nii.gz,1,2] -c [200x200x200x200x10,1e-7,10] --shrink-factors 12x8x4x2x1 --smoothing-sigmas 4x3x2x1x0vox


#source new-modules.sh; module load fastqc
#fastqc --casava -o fastqc_reports A01_R1.pair.fastq.gz
