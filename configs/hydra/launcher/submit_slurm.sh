#!/bin/bash
#SBATCH --cpus-per-task=6
#SBATCH --tasks-per-node=1
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --job-name=${tags.0}
#SBATCH --gres=gpu:p100:1
#SBATCH --signal=USR1@120
# # SBATCH --array=0-511%512
#SBATCH --time=00-3:00
#SBATCH --job-name=delay_aware
#SBATCH --output=./results/delay_aware.txt
#SBATCH --ntasks=1

# Uncomment below lines if required
# #SBATCH --partition=
# #SBATCH --qos=
# #SBATCH --comment=
# #SBATCH --constraint=
# #SBATCH --exclude=
# #SBATCH --cpus-per-gpu=
# #SBATCH --mem-per-gpu=
# #SBATCH --mem-per-cpu=

# Mail settings
#SBATCH --mail-user=wwang828@uwo.ca
#SBATCH --mail-type=BEGIN,END,FAIL,ALL,REQUEUE

echo "Running a simple task"

python mbexp.py -logdir ./log/DATS \
    -env gym_pendulum \
    -o exp_cfg.exp_cfg.ntrain_iters 200 \
    -o exp_cfg.sim_cfg.delay_hor 10\
    -o ctrl_cfg.prop_cfg.delay_step 10\
    -ca opt-type CEM \
    -ca model-type PE \
    -ca prop-type E