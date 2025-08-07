# PDL1 Carbonylation Site Prediction

The repo presents the pipeline of preprocessing protein sequences and predicting protein carbonylation sites. 

## 1. Cut fasta into windows

```
$ python 1_cut_fasta.py 
```

## 2. Compute PSSM features

``` 
# install mmseqs
$ wget https://mmseqs.com/latest/mmseqs-linux-avx2.tar.gz
$ tar xzf mmseqs-linux-avx2.tar.gz
$ export PATH=$PWD/mmseqs/bin:$PATH
$ mmseqs databases UniProtKB/Swiss-Prot swissprot tmp

# convert a FASTA file to PSSM
$ sh 2_compute_pssm.sh 
```

## 3. Cut PSSM features

``` 
$ python 3_extract_pssm.py 
```

## 4. Compute PC features

``` 
$ python 4_compute_PCfeas.py 
```

## 5. Move all files to SCANS folder

``` 
$ python 5_move_to_SCANS.py 
```

## 6. Run SCANS

``` 
# install SCANS
$ wget https://github.com/jianzhang-xynu/SCANS/archive/refs/heads/master.zip
$ pip install fair-esm
$ export PYTHONPATH=/home/rub2/.local/lib/python3.10/site-packages:$PYTHONPATH

$ sh 6_run_SCANS.sh 
```

## 7. Combine all sequences

``` 
$ python 7_combine_results.py 
```

## 8. Plot

``` 
$ R 8_plot.R 
```

## ppendix
```
rm SCANS-master/source_code/SCANS_*/feas/*/*@*
rm SCANS-master/source_code/SCANS_*/seqs/*@*

rm -rf preprocess/PCfeas
rm -rf preprocess/profile
rm -rf preprocess/pssm
rm -rf preprocess/PSSMfeas
rm -rf preprocess/query
rm -rf preprocess/result
rm -rf preprocess/tmp
rm -rf preprocess/window

mmseqs createdb swissprot.fasta swissprot
mmseqs createindex swissprot tmp
```
