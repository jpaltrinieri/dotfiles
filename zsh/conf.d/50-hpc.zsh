command -v squeue >/dev/null || return

# Your jobs, readable columns: ID, partition, name, state, elapsed, limit, nodes, reason/node
alias sq='squeue -u $USER -o "%.10i %.9P %.25j %.8T %.10M %.10l %.5D %R"'

# Runtime and memory of a job: compare MaxRSS with ReqMem to right-size requests
jobinfo() { sacct -j "$1" --format=JobID,JobName%25,State,Elapsed,TotalCPU,ReqMem,MaxRSS,ExitCode }

# Interactive job: sint [partition] [time] [cpus]
# Default partition comes from SINT_PARTITION in ~/.zshrc.local
sint() {
  srun --pty -p "${1:-$SINT_PARTITION}" -t "${2:-01:00:00}" -n 1 -c "${3:-4}" \
       "${commands[zsh]:-/bin/bash}" -l
}

# Follow the newest slurm-*.out in this folder
slog() {
  local f=( slurm-*.out(N.om[1]) )
  (( $#f )) && tail -f "$f" || echo "no slurm-*.out here"
}

# Cancel all your jobs, with confirmation
scancelall() { read -q "?Cancel ALL your jobs? [y/N] " && { echo; scancel -u $USER } || echo }
