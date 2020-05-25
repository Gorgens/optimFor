# -*- coding: utf-8 -*-
"""
Organizar os dados de inventário
Fonte: Inventários Paisagens Sustentáveis

Criado por: Eric Gorgens
Criado em: 24/05/2020, Data Science Lab, DEF, UFVJM
"""

import pandas as pd
import matplotlib.pyplot as plt

and2013 = pd.read_csv('AND_A01_2013_Inventory.csv', encoding='latin-1')
# print(and2013.columns)
# print(and2013.shape)
and2013['date'] = pd.to_datetime(and2013.date, format='%Y%m%d')
# print(and2013.head())

ana2015 = pd.read_csv('ANA_A01_2015_Inventory.csv', encoding='latin-1')
# print(ana2015.columns)
# print(ana2015.shape)
ana2015['date'] = pd.to_datetime(ana2015.date, format='%Y%m%d')
ana2015.rename(columns={'Dead': 'dead'}, inplace=True)
# print(ana2015.columns)
# print(ana2015.head())

ana2018 = pd.read_csv('ANA_A01_2015_2018_Inventory.csv', encoding='utf-8')
ana2018 = ana2018[['area', 'plot', 'tree', 'common.name', 'scientific.name', 'family.name',
                   'type', 'DBH.2018', 'Dead.2018', 'date.2018', 'UTM.Easting', 'UTM.Northing']]
ana2018.rename(columns={'DBH.2018': 'DBH', 'Dead.2018': 'dead', 'date.2018': 'date'}, inplace=True)
ana2018['date'] = pd.to_datetime(ana2018.date, format='%Y%m%d')
# print(ana2018.columns)
# print(ana2018.shape)
# print(ana2018.head())


bon2014 = pd.read_csv('BON_A01_2014_Inventory.csv', encoding='latin-1')
(bon2014.rename(columns={'Area': 'area',
                         'plot_ID': 'plot',
                         'common_name': 'common.name',
                         'scientific_name': 'scientific.name',
                         'family_name': 'family.name',
                         'burnt_area': 'burnt.area',
                         'd_class': 'D.class',
                         'UTM_Easting': 'UTM.Easting',
                         'UTM_Northing': 'UTM.Northing'}, inplace=True))
bon2014['date'] = pd.to_datetime(bon2014.date, format='%Y%m%d')
# print(bon2014.columns)
# print(bon2014.shape)
# print(bon2014.head())

cau2012 = pd.read_csv('CAU_A01_2012_Inventory.csv', encoding='latin-1')
# print(cau2012.columns)
# print(cau2012.shape)
cau2012.rename(columns={'area.code': 'area',
                        'transect': 'trans.ID',
                        'Date': 'date',
                        'Dead': 'dead'}, inplace=True)
cau2012['date'] = pd.to_datetime(cau2012.date, format='%Y%m%d')
# print(cau2012.columns)
# print(cau2012.head())

cau2014 = pd.read_csv('CAU_A01_2012&2014_Inventory.csv', encoding='latin-1')
print(cau2014.columns)
cau2014 = cau2014[['area.code', 'transect', 'tree', 'common.name', 'scientific.name',
                   'family.name', 'type', 'DBH.2014', 'Dead.2014', 'D.class.2014', 'RN.2014',
                   'RS.2014', 'RL.2014', 'RO.2014', 'Date.2014', 'UTM.Easting', 'UTM.Northing']]
print(cau2014.columns)
print(cau2014.shape)
cau2014.rename(columns={'area.code': 'area',
                        'transect': 'trans.ID',
                        'DBH.2014': 'DBH',
                        'Dead.2014': 'dead',
                        'D.class.2014': 'D.class',
                        'RN.2014': 'RN',
                        'RS.2014': 'RS',
                        'RL.2014': 'RE',
                        'RO.2014': 'RW',
                        'Date.2014': 'date'}, inplace=True)
cau2014['date'] = pd.to_datetime(cau2014.date, format='%Y%m%d')


cau2018 = pd.read_csv('CAU_A01_2014_2018_Inventory_plot50x50_delivery.csv', encoding='latin-1')
print(cau2018.columns)
cau2018 = cau2018[['area', 'group_code', 'plot_ID', 'tree', 'common_name', 'scienfic_name',
                   'family_name', 'type', 'DBH.2018', 'Dead.2018', 'date.2018',
                   'UTM_Easting', 'UTM_Northing']]
print(cau2018.columns)
print(cau2018.shape)
cau2018.rename(columns={'group_code': 'trans.ID',
                        'plot_ID': 'plot',
                        'common_name': 'common.name',
                        'scienfic_name': 'scientific.name',
                        'family_name': 'family.name',
                        'DBH.2018': 'DBH',
                        'Dead.2018': 'dead',
                        'date.2018': 'date',
                        'UTM_Easting': 'UTM.Easting',
                        'UTM_Northing': 'UTM.Northing'}, inplace=True)
cau2018['date'] = pd.to_datetime(cau2018.date, format='%Y%m%d')

duc2009 = pd.read_csv('DUC_A01_2009&2011_Inventory.csv', encoding='latin-1')
# print(duc2009.columns)
duc2009 = duc2009[['Area', 'trans', 'tree', 'common.name', 'scientific.name',
                   'family.name', 'DBH.09', 'type.09', 'canopy.09', 'light.09',
                   'Dead.09', 'D.class.09', 'Hcom.09', 'Htot.09', 'RN.09', 'RS.09',
                   'RE.09', 'RW.09', 'UTM.Easting', 'UTM.Northing']]
# print(duc2009.columns)
# print(duc2009.shape)
duc2009.rename(columns={'Area': 'area',
                        'trans': 'trans.ID',
                        'DBH.09': 'DBH',
                        'type.09': 'type',
                        'canopy.09': 'canopy',
                        'light.09': 'light',
                        'Dead.09': 'dead',
                        'D.class.09': 'D.class',
                        'Hcom.09': 'Hcom',
                        'Htot.09': 'Htot',
                        'RN.09': 'RN',
                        'RS.09': 'RS',
                        'RE.09': 'RE',
                        'RW.09': 'RW'}, inplace=True)
duc2009['date'] = '2009-01-01'

duc2011 = pd.read_csv('DUC_A01_2009&2011_Inventory.csv', encoding='latin-1')
# print(duc2011.columns)
duc2011 = duc2011[['Area', 'trans', 'tree', 'common.name', 'scientific.name',
                   'family.name', 'DBH.11', 'type.11', 'canopy.11', 'light.11',
                   'Dead.11', 'D.class.11', 'Hcom.11', 'Htot.11', 'RN.11', 'RS.11',
                   'RE.11', 'RW.11', 'UTM.Easting', 'UTM.Northing']]
# print(duc2011.columns)
# print(duc2011.shape)
duc2011.rename(columns={'Area': 'area',
                        'trans': 'trans.ID',
                        'DBH.11': 'DBH',
                        'type.11': 'type',
                        'canopy.11': 'canopy',
                        'light.11': 'light',
                        'Dead.11': 'dead',
                        'D.class.11': 'D.class',
                        'Hcom.11': 'Hcom',
                        'Htot.11': 'Htot',
                        'RN.11': 'RN',
                        'RS.11': 'RS',
                        'RE.11': 'RE',
                        'RW.11': 'RW'}, inplace=True)
duc2011['date'] = '2011-01-01'

duc2016 = pd.read_csv('DUC_A01_2016_inventory.csv', encoding='latin-1')
# print(duc2016.columns)
# print(duc2016.columns)
# print(duc2016.shape)
duc2016.rename(columns={'Dead': 'dead'}, inplace=True)
duc2016['date'] = pd.to_datetime(duc2016.date, format='%Y%m%d')

fn2015 = pd.read_csv('FN_A01_2015_Inventory.csv', encoding='latin-1', delimiter=';', decimal='.')
fn2015.drop('UTM.Easting', axis=1, inplace=True)
fn2015.drop('UTM.Northing', axis=1, inplace=True)
# print(fn2015.columns)
# print(fn2015.columns)
# print(fn2015.shape)
fn2015.rename(columns={'Dead': 'dead',
                       'group': 'trans.ID'}, inplace=True)
fn2015['date'] = pd.to_datetime(fn2015.date, format='%Y%m%d')

fna2013 = pd.read_csv('FNA_A01_2013_Inventory.csv', encoding='latin-1')
# print(fna2013.columns)
fna2013 = fna2013[['area', 'transect', 'tree', 'common_name', 'scienfic_name',
                   'family_name', 'DBH', 'type', 'canopy', 'Light', 'plot_code',
                   'Dead', 'D_class', 'Hcom', 'Htot', 'RN', 'RS', 'Date',
                   'RE', 'RW', 'UTM_Easting', 'UTM_Northing']]
# print(fna2013.columns)
# print(fna2013.shape)
fna2013.rename(columns={'transect': 'trans.ID',
                        'common_name': 'common.name',
                        'scienfic_name': 'scientific.name',
                        'family_name':  'family.name',
                        'plot_code': 'plot',
                        'Dead': 'dead',
                        'Light': 'light',
                        'Date': 'date',
                        'D_class': 'D.class',
                        'UTM_Easting': 'UTM.Easting',
                        'UTM_Northing': 'UTM.Northing'}, inplace=True)
fna2013['date'] = pd.to_datetime(fna2013.date, format='%Y%m%d')


# Unir os dataframes

frames = [and2013, ana2015, ana2018, bon2014, cau2012, cau2014, cau2018, duc2009,
          duc2011, duc2016, fn2015, fna2013]
inv = pd.concat(frames)
print(inv.columns)
print(inv.shape)
# print(inv.head())
# tem que ter 23 colunas (variáveis)

inv.to_csv('dataBaseInventarios.csv', index=False, encoding='utf-8')
# Variável do dataframe
# ['area', 'trans.ID', 'plot', 'tree', 'common.name', 'scientific.name',
# 'family.name', 'DBH', 'type', 'canopy', 'light', 'dead', 'D.class',
# 'Hcom', 'Htot', 'RN', 'RS', 'RE', 'RW', 'date', 'UTM.Easting',
# 'UTM.Northing', 'burnt.area'])

# Visualizar distribuição diametrica
# dbh = inv['DBH']
#
# fig, ax = plt.subplots()
# ax.hist(dbh, bins=range(0, 250, 10), density=1)
# ax.set_xlabel('DBH (cm)')
# ax.set_ylabel('Probability density')
# fig.tight_layout()
# plt.show()
# plt.savefig('dbhHist.png')

