#!/bin/bash

# Réduire les restrictions de sécurité pour perf
sudo sysctl -w kernel.perf_event_paranoid=1

# Définir les branches à tester
branches=("master" "fp32" "fp32_inline" "fp32_nosqrt" "inline" "nosqrt" "zoom")

# Créer un nouveau répertoire pour stocker les résultats de l'exercice 3
mkdir -p results_ex3

# Boucler sur chaque branche pour tester les performances
for branch in "${branches[@]}"; do
    echo "Testing $branch for Exercice 3..."
    git checkout $branch
    make clean && make
    
    # Définir la variable d'environnement pour les bibliothèques partagées
    export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
    
    # Mesurer les performances avec Hyperfine et sauvegarder les résultats
    hyperfine --show-output --export-csv results_ex3/hyperfine_$branch.csv ./mandel
    
    # Enregistrer les données de perf et générer le rapport
    perf record -o results_ex3/perf_$branch.data -g ./mandel
    perf report -i results_ex3/perf_$branch.data --stdio > results_ex3/profile_$branch.txt
done