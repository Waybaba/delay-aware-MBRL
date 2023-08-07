from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import os
import argparse
import pprint
import copy
# os.environ["CUDA_VISIBLE_DEVICES"] = "-1"  # Force TF to use only the CPU
# os.environ["CUDA_VISIBLE_DEVICES"] = "0"  # Force TF to use only the CPU
import tensorflow as tf
import wandb
config = tf.ConfigProto()
config.gpu_options.allow_growth = True



from dotmap import DotMap

from dmbrl.misc.MBExp import MBExperiment
from dmbrl.controllers.MPC import MPC
from dmbrl.config import create_config
from dmbrl.misc import logger


def main(env, ctrl_type, ctrl_args, overrides, logdir, args):
    ctrl_args = DotMap(**{key: val for (key, val) in ctrl_args})
    cfg = create_config(env, ctrl_type, ctrl_args, overrides, logdir)
    logger.info('\n' + pprint.pformat(cfg))

    # add the part of popsize
    if ctrl_type == "MPC":
        cfg.exp_cfg.exp_cfg.policy = MPC(cfg.ctrl_cfg)

    cfg.exp_cfg.misc = copy.copy(cfg)
    exp = MBExperiment(cfg.exp_cfg)

    if not os.path.exists(exp.logdir):
        os.makedirs(exp.logdir)
    with open(os.path.join(exp.logdir, "config.txt"), "w") as f:
        f.write(pprint.pformat(cfg.toDict()))

    exp.run_experiment()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-env', type=str, required=True,
                        help='Environment name: select from [cartpole, reacher, pusher, halfcheetah]')
    parser.add_argument('-ca', '--ctrl_arg', action='append', nargs=2, default=[],
                        help='Controller arguments, see https://github.com/kchua/handful-of-trials#controller-arguments')
    parser.add_argument('-o', '--override', action='append', nargs=2, default=[],
                        help='Override default parameters, see https://github.com/kchua/handful-of-trials#overrides')
    parser.add_argument('-logdir', type=str, default='log',
                        help='Directory to which results will be logged (default: ./log)')
    parser.add_argument('-e_popsize', type=int, default=500,
                        help='different popsize to use')
    parser.add_argument('-seed', type=int, default=0)
    # env_name
    parser.add_argument('-env_name', type=str, help='environment name')
    # env_delay
    parser.add_argument('-env_delay', type=int, default=0, help='delay of the environment')
    args = parser.parse_args()

    # seed
    tf.set_random_seed(args.seed)
    import numpy as np
    np.random.seed(args.seed)

    wandb.init(
        project="mbexp",
        tags=["mbexp", "notag"],
        config=args,
        dir=args.logdir,
        mode="online",
    )

    main(args.env, "MPC", args.ctrl_arg, args.override, args.logdir, args)
