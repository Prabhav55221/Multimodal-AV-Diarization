#!/bin/bash -l

#SBATCH --job-name=testRun
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --mail-user="psingh54@jhu.edu"

source /home/psingh54/.bashrc

module load cuda/10.2

source activate avd-ava

cd /export/fs06/psingh54/AVA-AVD

export PYTHONPATH=./dataset/third_party/insightface/detection/retinaface
python dataset/scripts/preprocessing.py