#! /bin/bash -l

#SBATCH --partition=scu-cpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=cfDNA_cov
#SBATCH --cpus-per-task=12
#SBATCH --time=120:00:00   # HH/MM/SS
#SBATCH --mem=150G # memory requested, units available: K,M,G,T
#SBATCH --output=exp/slurm_out/cov/slurm-%x-%j.out

source ~/.bashrc

set -euxo pipefail

export TMPDIR=/scratch

echo $TMPDIR

cd $SLURM_SUBMIT_DIR

date

for i in $(seq 1 ${SLURM_CPUS_PER_TASK}); do
    export LOG_SUBJOB=$i
    python -u python/cfDNA_coverage.py &
done

exitcode=0
for job in $(jobs -p); do
    echo "waiting for job $job"
    if wait $job; then
        echo "job $job succeeded at $(date)"
    else
        exitcode=$?
        echo "job $job failed with exit code $exitcode at $(date)"
    fi
done

exit $exitcode

