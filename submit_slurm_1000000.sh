#!/bin/bash
#SBATCH --cpus-per-task=6
#SBATCH --tasks-per-node=1
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --gres=gpu:p100:1
#SBATCH --signal=USR1@120
#SBATCH --array=0-239%240
#SBATCH --time=00-72:00
#SBATCH --job-name=delay_aware
#SBATCH --output=/home/waybaba/scratch/output/slurm_output/%A/%A_%a.txt
#SBATCH --ntasks=1

# Mail settings
#SBATCH --mail-user=wwang828@uwo.ca
#SBATCH --mail-type=BEGIN,END,FAIL,ALL,REQUEUE



# ENV_DELAY and ENV_NAME and SEED arrays
ENV_DELAYS=(0 1 2 4 8 12)
ENV_NAMES=("gym_walker2d" "gym_ant" "gym_hopper" "gym_cheetah" "gym_swimmer" "gym_reacher" "gym_invertedPendulum" "pusher")
SEEDS=(0 1 2 3 4)

# Calculate indices
ENV_DELAY_INDEX=$((SLURM_ARRAY_TASK_ID / 40))
ENV_NAME_INDEX=$(( (SLURM_ARRAY_TASK_ID / 5) % 8))
SEED_INDEX=$((SLURM_ARRAY_TASK_ID % 5))

# Set variables
export ENV_DELAY=${ENV_DELAYS[$ENV_DELAY_INDEX]}
export ENV_NAME=${ENV_NAMES[$ENV_NAME_INDEX]}
export SEED=${SEEDS[$SEED_INDEX]}

echo "Running a simple task with ENV_DELAY=$ENV_DELAY, ENV_NAME=$ENV_NAME, SEED=$SEED"

# Your other environment settings
source ./venv/bin/activate
export OMP_NUM_THREADS=1
export WANDB_API_KEY=360492802218be41f7b8a1636cee89cc215a1d76
export NSTEPS=1000000
export TAG="1000000step"
export WANBD_MODE=offline
python mbexp.py -logdir $UOUTDIR/delay_aware/ \
    -env $ENV_NAME \
    -o exp_cfg.exp_cfg.ntrain_iters 200000 \
    -o exp_cfg.sim_cfg.delay_hor $ENV_DELAY \
    -o ctrl_cfg.prop_cfg.delay_step $ENV_DELAY \
		-o exp_cfg.exp_cfg.n_steps $NSTEPS \
		-seed $SEED \
    -ca opt-type CEM \
    -ca model-type PE \
    -ca prop-type E \
		-env_name $ENV_NAME \
		-env_delay $ENV_DELAY \
		-tag $TAG
