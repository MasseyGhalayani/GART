#!/bin/bash -l
#
#SBATCH --job-name=solver_job         # A descriptive name for your job
#SBATCH --output=job_%j.out            # Standard output will be saved to job_<jobID>.out
#SBATCH --error=job_%j.err             # Standard error will be saved to job_<jobID>.err
#SBATCH --gres=gpu:rtx3080:1              # Request 1 rtx3080 GPU (adjust if needed)
#SBATCH --partition=rtx3080               # Use the rtx3080 partition (change to e.g., a100 or work as appropriate)
#SBATCH --time=6:00:00                 # Set maximum walltime to 6 hours
#SBATCH --export=NONE                  # Do not propagate your current environment

# Unset exported environment variables from the submission environment (if needed)
unset SLURM_EXPORT_ENV

# Load necessary modules (for example, the Python module that provides conda)
module load cuda/11.8

# Activate your conda environment (replace 'gart' with your actual environment name)
source activate gart


dataset="people_snapshot"
profile="people_30s"
logbase=${profile}

for seq in  "male-3-casual" "male-4-casual" "female-3-casual" "female-4-casual"
do
    python solver.py --profile ./profiles/people/${profile}.yaml --dataset $dataset --seq $seq --eval_only --log_dir logs/${logbase}/seq=${seq}_prof=${profile}_data=${dataset}
done
