import numpy as np
from Bio import SeqIO
import os
import glob

def read_pssm_corrected(pssm_file):
    """Read the formatted PSSM file and return a numpy array of shape (L, 20)"""
    pssm = []
    with open(pssm_file, 'r') as f:
        lines = f.readlines()
    for line in lines[2:]:
        if line.strip() == "":
            continue
        parts = line.strip().split()
        if len(parts) != 22:
            continue
        try:
            values = [float(x) for x in parts[2:]]
            pssm.append(values)
        except ValueError:
            continue
    return np.array(pssm)

def extract_centered_patches(pssm_array, sequence, center_aa_set={'K', 'P', 'R', 'T'}, window_size=27):
    """Extract 27×20 patches centered on specified amino acids"""
    half_window = window_size // 2
    padded = np.pad(pssm_array, ((half_window, half_window), (0, 0)), mode='constant')
    patches = []
    positions = []
    aas = []
    for i, aa in enumerate(sequence):
        if aa in center_aa_set:
            patch = padded[i:i + window_size, :]
            patches.append(patch)
            positions.append(i + 1)  # 1-based position
            aas.append(aa)
    return patches, positions, aas

def save_centered_patches(patches, positions, aas, output_dir, base_name):
    os.makedirs(output_dir, exist_ok=True)
    for patch, pos, aa in zip(patches, positions, aas):
        outfile = os.path.join(output_dir, f"{base_name}_{aa}{pos}.pssm")
        with open(outfile, 'w') as f:
            for row in patch:
                row_str = ",".join(f"{val:.0f}" for val in row)
                f.write(row_str + "\n")

# === Batch Processing ===
pssm_dir = "preprocess/pssm/"
fasta_dir = "preprocess/fastas/"
output_dir = "preprocess/PSSMfeas/"
center_aa_set = {'K', 'P', 'R', 'T'}

pssm_files = glob.glob(os.path.join(pssm_dir, "*.pssm"))

for pssm_file in pssm_files:
    base_name = os.path.splitext(os.path.basename(pssm_file))[0]
    fasta_file = os.path.join(fasta_dir, base_name + ".fasta")
    if not os.path.exists(fasta_file):
        print(f"FASTA file missing for {base_name}, skipping.")
        continue

    # Read PSSM and FASTA
    pssm_array = read_pssm_corrected(pssm_file)
    record = next(SeqIO.parse(fasta_file, "fasta"))
    sequence = str(record.seq)

    # Extract and save patches for K/P/R/T
    patches, positions, aas = extract_centered_patches(pssm_array, sequence, center_aa_set)
    save_centered_patches(patches, positions, aas, output_dir, base_name)
    print(f"Processed {base_name}: {len(patches)} patches saved.")

print("All files processed.")
