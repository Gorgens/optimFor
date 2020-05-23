# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import matplotlib.pyplot as plt

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

ana2018 = pd.read_csv('ANA_A01_2015_2018_Inventory.csv', encoding='utf-8')
ana2018 = ana2018[['area', 'plot', 'tree', 'common.name', 'scientific.name', 'family.name',
       'type', 'DBH.2018', 'Dead.2018', 'date.2018', 'UTM.Easting', 'UTM.Northing']]
ana2018.rename(columns = {'DBH.2018':'DBH', 'Dead.2018':'dead', 'date.2018':'date'}, inplace=True)
ana2018['date'] = pd.to_datetime(ana2018.date, format='%Y%m%d')
print(ana2018.columns)
print(ana2018.shape)
#print(ana2018.head())


bon2014 = pd.read_csv('BON_A01_2014_Inventory.csv', encoding='latin-1')
(bon2014.rename(columns = {'Area':'area',
                          'plot_ID':'plot',
                          'common_name':'common.name',
                          'scientific_name': 'scientific.name',
                          'family_name':'family.name',
                          'burnt_area': 'burnt.area',
                          'd_class':'D.class',
                          'UTM_Easting': 'UTM.Easting',
                          'UTM_Northing': 'UTM.Northing'}, inplace=True))
bon2014['date'] = pd.to_datetime(bon2014.date, format='%Y%m%d')
print(bon2014.columns)
print(bon2014.shape)
#print(ana2018.head())



## Unir os dataframes

# frames = [and2013, ana2015]
# inv = pd.concat(frames)
# print(inv.columns)
# print(inv.shape)
# print(inv.head())
#
# inv.to_csv('dataBaseInventarios.csv', index=False, encoding='utf-8')
#
#
# # Visualizar distribuição diametrica
# dbh = inv['DBH']
#
# fig, ax = plt.subplots()
# ax.hist(dbh, bins=range(0, 250, 10), density=1)
# ax.set_xlabel('DBH (cm)')
# ax.set_ylabel('Probability density')
# fig.tight_layout()
# plt.show()
# #plt.savefig('dbhHist.png')
#
