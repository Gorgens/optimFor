# -*- coding: utf-8 -*-
"""
Spyder Editor

Projeto: modelagem do crescimento de uma árvore por agentes 
"""

import pandas as pd
import numpy as np
import math as m
import matplotlib as mpl
import matplotlib.pyplot as plt
from ggplot import *
import time

"""
Funções auxiliares
"""

def distanceDec(lon1, lat1, lon2, lat2):
    lon1, lat1, lon2, lat2 = map(m.radians, [lon1, lat1, lon2, lat2])
    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = m.sin(dlat/2)**2 + m.cos(lat1) * m.cos(lat2) * m.sin(dlon/2)**2
    c = 2 * m.atan2(m.sqrt(a), m.sqrt(1-a))
    d = (6373 * c) * 1000
    return d

def spatialMean(file, buffer = 50.0, minLat = -15, minLon = -40):
    
    """
    Importa base de dados e retira ruidos armazenados pelo GPS
    """
    df = pd.read_csv(file)                  #Importar arquivo para análise
    dfFilter = df[df.Latitude < minLat]     #Filtrar pontos espúrios do GPS
    dfFilter = df[df.Longitude < minLon]    #Filtrar pontos espúrios do GPS

    """
    Cria variáveis de ambiente e variáveis de saída
    """
    velMean = []
    lat = []
    lon = []     

    """
    Looping para calculo da média por buffer
    """
    booleans = [False] * dfFilter.shape[0]
    for i in range(0, dfFilter.shape[0]): 
        if booleans[i] == False:
            vel = []
            lat1 = dfFilter.iloc[i]['Latitude']
            lon1 = dfFilter.iloc[i]['Longitude']
            
            for j in range(0, dfFilter.shape[0]):
                if booleans[j] == False:
                    lat2 = dfFilter.iloc[j]['Latitude']
                    lon2 = dfFilter.iloc[j]['Longitude']
                    if  distanceDec(lon1, lat1, lon2, lat2) <= buffer:
                        vel.append(dfFilter.iloc[j]['Velocidade'])
                        booleans[j] = True
            if len(vel) > 1:
                lat.append(dfFilter.iloc[i]['Latitude'])
                lon.append(dfFilter.iloc[i]['Longitude'])
                velMean.append(round(np.mean(vel), 2))
                #print(i, round(np.mean(vel), 2))

    """
    Cria dataframe com vetores
    """    
    refPoints = pd.DataFrame(
        {'Longitude': lon,
         'Latitude': lat,
         'Velocidade': velMean
        })
    return(refPoints)
    
    
def spatialCEPlimits(listFiles, buffer = 50.0, minLat = -15, minLon = -40):    
    print('Creating reference file...')
    ref = spatialMean(listFiles[0])
    refCEP = ref
    print('Reference done!')
    
    for file in listFiles[1:]:
        print('Doing:', file)
        df = pd.read_csv(file)                  #Importar arquivo para análise
        dfNew = df[df.Latitude < minLat]        #Filtrar pontos espúrios do GPS
        dfNew = df[df.Longitude < minLon]       #Filtrar pontos espúrios do GPS
        
        velCheck = []
        booleans = [False] * dfNew.shape[0]
        for i in range(0, ref.shape[0]):
            lat1 = ref.iloc[i]['Latitude']
            lon1 = ref.iloc[i]['Longitude']
            vel = []
            for j in range(0, dfNew.shape[0]): 
                if booleans[j] == False:
                    lat2 = dfNew.iloc[j]['Latitude']
                    lon2 = dfNew.iloc[j]['Longitude']
                    if distanceDec(lon1, lat1, lon2, lat2) <= buffer:
                        vel.append(dfNew.iloc[j]['Velocidade'])
                        booleans[j] = True
            if not vel:
                velCheck.append(np.nan)
            else:
                velCheck.append(round(np.mean(vel), 2))
        
        refCEP['vel' + file[0:4]] = pd.Series(velCheck, index=refCEP.index)
        print(file, 'done!')
        
    refCEP['meanVel'] = refCEP.ix[:,2:3+len(listFiles)].mean(axis=1)
    refCEP['sdVel'] = refCEP.ix[:,2:3+len(listFiles)].std(axis=1)
    return(refCEP)
    
def checkCEP(listFiles, reference, desv = 3, buffer = 50.0, minLat = -15, minLon = -40):    
    output = reference
    
    for file in listFiles:
        print('Doing:', file)
        df = pd.read_csv(file)                  #Importar arquivo para análise
        dfNew = df[df.Latitude < minLat]        #Filtrar pontos espúrios do GPS
        dfNew = df[df.Longitude < minLon]       #Filtrar pontos espúrios do GPS
        
        
        velCheck = []
        velCEP = []
        booleans = [False] * dfNew.shape[0]
        for i in range(0, reference.shape[0]):
            lat1 = reference.iloc[i]['Latitude']
            lon1 = reference.iloc[i]['Longitude']
            vel = []
            for j in range(0, dfNew.shape[0]): 
                if booleans[j] == False:
                    lat2 = dfNew.iloc[j]['Latitude']
                    lon2 = dfNew.iloc[j]['Longitude']
                    if distanceDec(lon1, lat1, lon2, lat2) <= buffer:
                        vel.append(dfNew.iloc[j]['Velocidade'])
                        booleans[j] = True
            if not vel:
                velCheck.append(np.nan)
                velCEP.append(True)
            else:
                velCheck.append(round(np.mean(vel), 2))
                if np.mean(vel) < (reference.iloc[i]['meanVel'] - desv * reference.iloc[i]['sdVel']):
                    velCEP.append(False)
                elif np.mean(vel) > (reference.iloc[i]['meanVel'] + desv * reference.iloc[i]['sdVel']):
                    velCEP.append(False)
                else:
                    velCEP.append(True)
                
        print(file, 'done!')
        
        output['vel' + file[0:4]] = pd.Series(velCheck, index=output.index)
        output['status'] = pd.Series(velCEP, index=output.index)
    return(output)
    


"""
Teste
"""

start_time = time.time()
avgZoneTrans = spatialMean('trans_local1_o1.csv', buffer = 250.0, minLat = -15, minLon = -40)
print("--- %s seconds ---" % (time.time() - start_time))

ggplot(avgZoneTrans, aes('Longitude', 'Latitude', color = 'Velocidade')) + geom_point(size = 25) +\
scale_color_gradient(low='blue', high='red') +\
xlab("Longitude") + ylab("Latitude") + ggtitle("Spatial CEP") +\
xlim(-42.09, -42.00) + ylim(-17.965, -17.84) + theme_bw()


listFiles = ['trans_local1_o1.csv', 'trans_local1_o2.csv', 'trans_local1_o3.csv', 'trans_local1_o4.csv', 'trans_local1_o5.csv', 'trans_local1_o6.csv']
start_time = time.time()
cepZone = spatialCEPlimits(listFiles, buffer = 250.0, minLat = -15, minLon = -40)
print("--- %s seconds ---" % (time.time() - start_time))

start_time = time.time()
checkTrans = checkCEP(['trans_local1_o7.csv'], cepZone, buffer = 250.0, minLat = -15, minLon = -40)
print("--- %s seconds ---" % (time.time() - start_time))

ggplot(checkTrans, aes('Longitude', 'Latitude', color = 'status')) + geom_point() +\
xlab("Longitude") + ylab("Latitude") + ggtitle("Spatial CEP") +\
xlim(-42.09, -42.00) + ylim(-17.965, -17.84) + theme_bw()
