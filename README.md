# PDL1 Carbonylation Site Prediction

The repo presents the pipeline of predicting protein carbonylation sites. 

## cut fasta into windows

To install `SecAct`, we recommend using `devtools`:

``` 
python 1_cut_fasta.py 

sh 2_compute_pssm.sh 

export PATH=$PWD/mmseqs/bin:$PATH

sh 2_compute_pssm.sh 

python 3_extract_pssm.py 

python 4_compute_PCfeas.py 

python 5_move_to_SCANS.py 
```
