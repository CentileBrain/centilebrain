#!/usr/bin/env python
# coding: utf-8

# In[1]:

# preferable version of the neuroHarmonize, pandas, and numpy packages are 2.1.1, 2.2.1, and 1.26.4  
from neuroHarmonize import harmonizationLearn 
import pandas as pd
import numpy as np
np.random.seed(0)

def combatGAM_Python4R_function(path):
    data = pd.read_csv(path + 'data_temp.csv')
    my_data = np.array(data)
    my_covars = pd.read_csv(path + 'covars_temp.csv')
    my_model, my_data_adj = harmonizationLearn(my_data, my_covars, smooth_terms=['age'])
    return my_data_adj, my_model


# In[ ]:




