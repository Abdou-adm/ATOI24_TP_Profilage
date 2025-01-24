#!/bin/bash

# Compilation avec symboles de debug
gcc -O3 -g -o mandel_seq mandel.c ppm.c -lm
gcc -O3 -g -fopenmp -o mandel_static mandel.c ppm.c -lm
gcc -O3 -g -fopenmp -DSCHEDULE_DYNAMIC -o mandel_dynamic mandel.c ppm.c -lm
gcc -O3 -g -fopenmp -DSCHEDULE_GUIDED -o mandel_guided mandel.c ppm.c -lm

# Benchmark avec Hyperfine
hyperfine --warmup 3 --runs 5 \
    './mandel_seq' \
    'OMP_NUM_THREADS=4 ./mandel_static' \
    'OMP_NUM_THREADS=4 ./mandel_dynamic' \
    'OMP_NUM_THREADS=4 ./mandel_guided'

# Analyse avec perf
echo "Analyse des performances avec perf..."
sudo sysctl -w kernel.perf_event_paranoid=1
perf record -F 99 -g -- OMP_NUM_THREADS=4 ./mandel_static
perf report --stdio > perf_report.txt
perf stat -d OMP_NUM_THREADS=4 ./mandel_static