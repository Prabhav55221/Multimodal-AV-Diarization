#!/bin/bash -l

#SBATCH --job-name=testRun
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --mail-user="psingh54@jhu.edu"

source /home/psingh54/.bashrc

module load cuda/10.2

source activate diehard

cd /export/fs06/psingh54/AVA-AVD/dataset/third_party/denoising_DIHARD18

export LD_LIBRARY_PATH=/home/psingh54/miniconda3/envs/diehard/lib:$LD_LIBRARY_PATH
export PATH=/home/psingh54/openmpi-1.10/bin:$PATH
export LD_LIBRARY_PATH=/home/psingh54/openmpi-1.10/lib:$LD_LIBRARY_PATH

mpirun --version

WAV_DIR=../../waves/  # Directory of WAV files (16 kHz, 16 bit) to enhance.
SE_WAV_DIR=../../denoised_waves  # Output directory for enhanced WAV.
USE_GPU=true  # Use GPU instead of CPU. To instead use CPU, set to 'false'.
GPU_DEVICE_ID=0  # Use GPU with device id 0. Irrelevant if using CPU.
TRUNCATE_MINUTES=10  # Duration in minutes of chunks for enhancement. If you experience
                     # OOM errors with your GPU, try reducing this.

python main_denoising.py \
       --verbose \
       --wav_dir $WAV_DIR --output_dir $SE_WAV_DIR \
       --use_gpu $USE_GPU --gpu_id $GPU_DEVICE_ID \
       --truncate_minutes $TRUNCATE_MINUTES || exit 1

VAD_DIR=/data/vad  # Output directory for label files containing VAD output.
HOPLENGTH=30  # Duration in milliseconds of frames for VAD. Also controls step size.
MODE=3  # WebRTC aggressiveness. 0=least agressive and  3=most aggresive.
NJOBS=1  # Number of parallel processes to use.
python main_get_vad.py \
       --verbose \
       --wav_dir $SE_WAV_DIR --output_dir $VAD_DIR \
       --mode $MODE --hoplength $HOPLENGTH \
       --n_jobs $NJOBS || exit 1

exit 0