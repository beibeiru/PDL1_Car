#!/bin/bash

cd SCANS-master/source_code/SCANS_K/
python runPredictions.py
cd ../../..

cd SCANS-master/source_code/SCANS_P/
python runPredictions.py
cd ../../..

cd SCANS-master/source_code/SCANS_R/
python runPredictions.py
cd ../../..

cd SCANS-master/source_code/SCANS_T/
python runPredictions.py
cd ../../..
