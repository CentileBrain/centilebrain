#!/usr/bin/env python
# coding: utf-8

# For optimal reproducibility, it is recommended to use specific versions of the neuroHarmonize, pandas, and numpy packages: 
# 2.1.0 for neuroHarmonize, 2.2.1 for pandas, and 1.26.4 for numpy
from neuroHarmonize import harmonizationLearn 
import pandas as pd
import numpy as np
np.random.seed(0)

data = pd.read_csv('data.csv')
my_data = np.array(data)
my_covars = pd.read_csv('covars.csv')
my_model, my_data_adj = harmonizationLearn(my_data, my_covars, smooth_terms=['age'])
