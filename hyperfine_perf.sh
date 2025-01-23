#!/bin/bash

sudo sysctl -w kernel.perf_event_paranoid=1

branches=("master" "fp32" "fp32_inline" "fp32_nosqrt" "inline" "nosqrt" "zoom")

mkdir -p results

for branch in "${branches[@]}"; do
    echo "Testing $branch..."
    git checkout $branch
    make clean && make
    
    export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
    
    hyperfine --show-output --export-csv results/hyperfine_$branch.csv ./mandel
    
    perf record -o results/perf_$branch.data -g ./mandel
    perf report -i results/perf_$branch.data --stdio > results/profile_$branch.txt
done