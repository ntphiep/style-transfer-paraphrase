#!/bin/sh
#SBATCH --job-name=finetune_gpt2_test_paraphrase
#SBATCH -o style_paraphrase/logs/log_test_paraphrase.txt
#SBATCH --time=167:00:00
#SBATCH --partition=m40-long
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=3
#SBATCH --mem=50GB
#SBATCH -d singleton

# Experiment Details :- GPT2-large model for paraphrasing.
# Run Details :- accumulation = 2, batch_size = 5, beam_size = 1, cpus = 3, dataset = datasets/paranmt_filtered, eval_batch_size = 1, global_dense_feature_list = none, gpu = m40, learning_rate = 5e-5, memory = 50, model_name = gpt2-large, ngpus = 1, num_epochs = 3, optimizer = adam, prefix_input_type = original, save_steps = 500, save_total_limit = -1, specific_style_train = -1, stop_token = eos

export DATA_DIR=datasets/paranmt_filtered

source style-venv/bin/activate

BASE_DIR=style_paraphrase

torchrun --nproc-per-node=1 $BASE_DIR/run_lm_finetuning.py \
    --output_dir $BASE_DIR/saved_models/test_paraphrase \
    --model_type gpt2 \
    --overwrite_output_dir \
    --model_name_or_path gpt2-large \
    --data_dir $DATA_DIR \
    --local_rank 0 \
    --do_train \
    --save_steps 500 \
    --logging_steps 20 \
    --save_total_limit -1 \
    --evaluate_during_training \
    --num_train_epochs 3 \
    --gradient_accumulation_steps 2 \
    --per_gpu_train_batch_size 2 \
    --learning_rate 5e-5 \
    --job_id paraphraser_test \
    --prefix_input_type original \
    --global_dense_feature_list none \
    --specific_style_train -1 \
    --optimizer adam

# python -m torch.distributed.launch --nproc_per_node=1 $BASE_DIR/run_lm_finetuning.py \
#     --output_dir=$BASE_DIR/saved_models/test_paraphrase \
#     --model_type=gpt2 \
#     --model_name_or_path=gpt2-large \
#     --data_dir=$DATA_DIR \
#     --do_train \
#     --save_steps 500 \
#     --logging_steps 20 \
#     --save_total_limit -1 \
#     --evaluate_during_training \
#     --num_train_epochs 3 \
#     --gradient_accumulation_steps 2 \
#     --per_gpu_train_batch_size 5 \
#     --job_id paraphraser_test \
#     --learning_rate 5e-5 \
#     --prefix_input_type original \
#     --global_dense_feature_list none \
#     --specific_style_train -1 \
#     --optimizer adam

