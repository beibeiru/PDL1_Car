import os

# Physicochemical feature mapping for each amino acid
phyChem_dict = {
    "A": "0,0,0,1,0,0,0,0,1,0",
    "R": "0,0,0,0,1,1,1,0,0,0",
    "N": "0,0,0,0,0,1,0,1,1,0",
    "D": "0,0,0,0,1,1,0,0,1,0",
    "C": "0,1,0,1,0,1,0,0,1,0",
    "Q": "0,0,0,0,0,1,0,1,0,0",
    "E": "0,0,0,0,1,1,0,0,0,0",
    "G": "0,0,0,0,0,0,0,0,1,0",
    "H": "0,0,1,1,1,1,1,0,0,0",
    "I": "1,0,0,1,0,0,0,0,0,0",
    "L": "1,0,0,1,0,0,0,0,0,0",
    "K": "0,0,0,1,1,1,1,0,0,0",
    "M": "0,1,0,1,0,0,0,0,0,0",
    "F": "0,0,1,1,0,0,0,0,0,0",
    "P": "0,0,0,0,0,0,0,0,1,0",
    "S": "0,0,0,0,0,1,0,0,1,1",
    "T": "0,0,0,1,0,1,0,0,1,1",
    "W": "0,0,1,1,0,1,0,0,0,0",
    "Y": "0,0,1,1,0,1,0,0,0,0",
    "V": "1,0,0,1,0,0,0,0,1,0",
    "X": "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1"
}

# Paths
input_dir = "preprocess/window/"
output_dir = "preprocess/PCfeas/"
os.makedirs(output_dir, exist_ok=True)

# Process all window files
for file_name in os.listdir(input_dir):
    if file_name.endswith(".txt"):
        input_file = os.path.join(input_dir, file_name)
        output_file = os.path.join(output_dir, file_name)

        with open(input_file, 'r') as infile:
            line = infile.readline().strip()
            window_seq = line.split(',')[0]  # Extract amino acid sequence

        with open(output_file, 'w') as outfile:
            for aa in window_seq:
                feature_vector = phyChem_dict.get(aa, "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1")
                outfile.write(f"{feature_vector}\n")

print(f"All feature files saved to {output_dir}")
