import wandb

class TrainRunner:
    
    def start(self, cfg):
        print("Running default runner")
        self.cfg = cfg
        