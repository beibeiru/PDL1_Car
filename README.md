# PDL1 Carbonylation Site Prediction

The repo presents the pipeline of preprocessing protein sequences and predicting protein carbonylation sites. 

## 1. Cut fasta into windows

``` 
$ python 1_cut_fasta.py 

```

## 2. Compute pssm features

``` 

# install mmseqs
$ wget https://mmseqs.com/latest/mmseqs-linux-avx2.tar.gz
$ tar xzf mmseqs-linux-avx2.tar.gz
$ export PATH=$PWD/mmseqs/bin:$PATH
$ mmseqs databases UniProtKB/Swiss-Prot swissprot tmp

# convert a FASTA file to PSSM
$ sh 2_compute_pssm.sh 

```




``` 

#
sh 2_compute_pssm.sh 

python 3_extract_pssm.py 

python 4_compute_PCfeas.py 

python 5_move_to_SCANS.py 
```
