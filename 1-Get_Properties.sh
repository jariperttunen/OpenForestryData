#!/bin/bash -l

#SBATCH -J SpaFHy_Peat
#SBATCH --account=project_2000611
#SBATCH -o error/my_output_%j
#SBATCH -e error/my_output_err_%j
#SBATCH -t 001:40:00
#SBATCH -n 1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH -p serial 
#SBATCH --partition=small
#SBATCH --mail-type=END
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kyle.eyvindson@luke.fi


module load geoconda/3.7

srun python Python/check_properties.py
wait
srun python Python/extract_forest.py
wait
