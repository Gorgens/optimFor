# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
#import numpy as  np
import matplotlib.pyplot as plt
#import scipy.stats as sc

and2013 = pd.read_csv('AND_A01_2013_Inventory.csv', encoding='latin-1')
print(and2013.columns)
print(and2013.shape)
and2013['date'] = pd.to_datetime(and2013.date, format='%Y%m%d')
#print(and2013.head())


ana2015 = pd.read_csv('ANA_A01_2015_Inventory.csv', encoding='latin-1')
print(ana2015.columns)
print(ana2015.shape)
ana2015['date'] = pd.to_datetime(ana2015.date, format='%Y%m%d')
ana2015.rename(columns = {'Dead':'dead'}, inplace=True)
print(ana2015.columns)
#print(ana2015.head())


## Unir os dataframes

frames = [and2013, ana2015]
inv = pd.concat(frames) 
print(inv.columns)
print(inv.shape)
print(inv.head())



# Visualizar distribuição diametrica
dbh = inv['DBH']

fig, ax = plt.subplots()
ax.hist(dbh, bins=range(0, 250, 10), density=1)
ax.set_xlabel('DBH (cm)')
ax.set_ylabel('Probability density')
fig.tight_layout()
plt.show()
#plt.savefig('dbhHist.png')
    