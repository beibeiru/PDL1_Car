from Bio import SeqIO
import os
import glob

def extract_centered_windows_to_files(fasta_file, window_size, center_aa_set, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    base_name = os.path.basename(fasta_file).split('.')[0]
    half_window = window_size // 2
    records = list(SeqIO.parse(fasta_file, "fasta"))
    for record in records:
        seq = str(record.seq)
        seq_padded = 'X' * half_window + seq + 'X' * half_window  # Pad with 'X'
        for i in range(len(seq)):
            center_residue = seq[i]
            if center_residue in center_aa_set:
                window = seq_padded[i:i + window_size]
                filename = os.path.join(output_dir, f"{base_name}_{center_residue}{i+1}.txt")  # i+1 for 1-based position
                with open(filename, 'w') as f:
                    f.write(f"{window},1,0,0\n")
    print(f"Saved individual window files to {output_dir}")


def process_all_fastas(fasta_dir="preprocess/fastas", output_dir="preprocess/window", window_size=27, center_aa_set={'K', 'P', 'R', 'T'}):
    fasta_files = glob.glob(os.path.join(fasta_dir, "*.fasta"))
    print(f"Found {len(fasta_files)} FASTA files.")
    for fasta_file in fasta_files:
        print(f"Processing {fasta_file}...")
        extract_centered_windows_to_files(fasta_file, window_size, center_aa_set, output_dir)
    print(f"All windows saved in {output_dir}")


# === Usage ===
process_all_fastas()