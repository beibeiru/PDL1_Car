#!/bin/bash

# Set input and output directories
FASTA_DIR="preprocess/fastas"
QUERY_DIR="preprocess/query"
RESULT_DIR="preprocess/result"
PROFILE_DIR="preprocess/profile"
PSSM_DIR="preprocess/pssm"
TMP_DIR="preprocess/tmp"

# Create output directories if they don't exist
mkdir -p "$QUERY_DIR" "$RESULT_DIR" "$PROFILE_DIR" "$PSSM_DIR" "$TMP_DIR"

# Loop over all FASTA files in FASTA_DIR
for fasta_file in "$FASTA_DIR"/*.fasta; do
    # Get the base name without extension
    base_name=$(basename "$fasta_file" .fasta)
    
    echo "Processing $base_name..."

    # Create MMseqs database
    mmseqs createdb "$fasta_file" "$QUERY_DIR/$base_name.DB"

    # Run MMseqs search
    mmseqs search "$QUERY_DIR/$base_name.DB" swissprot "$RESULT_DIR/$base_name.out" "$TMP_DIR" -a

    # Convert result to profile
    mmseqs result2profile "$QUERY_DIR/$base_name.DB" swissprot "$RESULT_DIR/$base_name.out" "$PROFILE_DIR/$base_name.profile"

    # Convert profile to PSSM
    mmseqs profile2pssm "$PROFILE_DIR/$base_name.profile" "$PSSM_DIR/$base_name.pssm"

    echo "Finished $base_name"
done

echo "All FASTA files processed."