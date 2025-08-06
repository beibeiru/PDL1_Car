import os

# Define amino acid types
aa_types = ['K', 'P', 'R', 'T']

# Base SCANS directory
base_dir = "SCANS-master/source_code"

# Output global combined file in current directory
global_output_file = "combined_all_results.txt"

all_combined_lines = []

for aa in aa_types:
    scans_dir = os.path.join(base_dir, f"SCANS_{aa}")
    
    list_file = os.path.join(scans_dir, "lists", "test.list")
    result_file = os.path.join(scans_dir, "pred_results", "test.txt")

    if not os.path.exists(list_file):
        print(f"Missing: {list_file}")
        continue
    if not os.path.exists(result_file):
        print(f"Missing: {result_file}")
        continue

    # Read test.list
    with open(list_file, 'r') as lf:
        list_lines = [line.strip() for line in lf.readlines()]

    # Read test.txt (predictions)
    with open(result_file, 'r') as rf:
        result_lines = [line.strip() for line in rf.readlines()]

    if len(list_lines) != len(result_lines):
        print(f"Warning: Line count mismatch in SCANS_{aa} ({len(list_lines)} vs {len(result_lines)})")
        continue

    for name, pred in zip(list_lines, result_lines):
        all_combined_lines.append(f"{name},{pred}")

# Write global combined file in current directory
with open(global_output_file, 'w') as out_f:
    for line in all_combined_lines:
        out_f.write(line + "\n")

print(f"Global combined results saved to: {global_output_file}")
