import os
import shutil

# Map amino acid suffixes to SCANS subfolders
aa_map = {
    '_K': 'SCANS_K',
    '_P': 'SCANS_P',
    '_R': 'SCANS_R',
    '_T': 'SCANS_T'
}

# Base SCANS directory and source folders
base_scans_dir = "SCANS-master/source_code/"
sources = {
    "PCfeas": "preprocess/PCfeas/",
    "PSSMfeas": "preprocess/PSSMfeas/",
    "window": "preprocess/window/"
}

for aa_tag, scans_folder in aa_map.items():
    print(f"Processing {aa_tag} → {scans_folder}")

    # Destination folders
    pc_dst = os.path.join(base_scans_dir, scans_folder, "feas/PCfeas/")
    pssm_dst = os.path.join(base_scans_dir, scans_folder, "feas/PSSMfeas/")
    seqs_dst = os.path.join(base_scans_dir, scans_folder, "seqs/")
    list_dir = os.path.join(base_scans_dir, scans_folder, "lists/")
    os.makedirs(pc_dst, exist_ok=True)
    os.makedirs(pssm_dst, exist_ok=True)
    os.makedirs(seqs_dst, exist_ok=True)
    os.makedirs(list_dir, exist_ok=True)

    # Track filenames for test.list (from PCfeas)
    filenames_no_ext = []

    # === Copy PCfeas files ===
    for file in os.listdir(sources["PCfeas"]):
        if file.endswith(".txt") and aa_tag in file:
            src = os.path.join(sources["PCfeas"], file)
            dst = os.path.join(pc_dst, file)
            shutil.copy(src, dst)
            filenames_no_ext.append(os.path.splitext(file)[0])
            print(f"Copied PCfeas: {file}")

    # === Copy PSSMfeas files ===
    for file in os.listdir(sources["PSSMfeas"]):
        if file.endswith(".pssm") and aa_tag in file:
            src = os.path.join(sources["PSSMfeas"], file)
            dst = os.path.join(pssm_dst, file)
            shutil.copy(src, dst)
            print(f"Copied PSSMfeas: {file}")

    # === Copy window files to seqs ===
    for file in os.listdir(sources["window"]):
        if file.endswith(".txt") and aa_tag in file:
            src = os.path.join(sources["window"], file)
            dst = os.path.join(seqs_dst, file)
            shutil.copy(src, dst)
            print(f"Copied seq: {file}")

    # === Write test.list ===
    list_file = os.path.join(list_dir, "test.list")
    with open(list_file, 'w') as f:
        for name in sorted(filenames_no_ext):
            f.write(f"{name}\n")
    print(f"Generated test.list with {len(filenames_no_ext)} entries in {list_file}\n")

print("All files copied and test.list created for K, P, R, T.")
