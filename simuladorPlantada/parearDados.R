require(dplyr)

df2017 = read.csv('antes2017.csv')
df2018 = read.csv('pos2018.csv')
anoDesbaste = read.csv('desbaste.csv')

# Organiza as bases e une
df2018 = df2018 %>% select(-FILA1, -FILA2)
dfInv = df2017 %>% bind_rows(df2018)

dfInv$sitio = cut(dfInv$S, 3, labels = c('baixo', 'medio', 'alto'))
dfInv$idadeInteira = floor(dfInv$I1)
dfInv$intervaloMed = dfInv$I2 - dfInv$I1
dfInv$incrementoDap = dfInv$DAP2 - dfInv$DAP1
dfInv$incDapAnual = dfInv$incrementoDap / dfInv$intervaloMed
dfInv$incDapAnualPerc = dfInv$incDapAnual / dfInv$DAP1
dfInv = dfInv %>%  
  mutate(binarioCresce = if_else(incDapAnual==0,0,1))

dfInv2 = dfInv %>% left_join(anoDesbaste, by = c('CODPROJETO', 'CODTALHAO', 'ANOREF1'))


intervaloClasse = 10.0
diametroMin = 10.0
classeMax = ((max(dfInv2$DAP1) %/% intervaloClasse) + 1) * intervaloClasse
intervalos = seq(diametroMin, classeMax, intervaloClasse) - 0.001
centros = head(round(intervalos + intervaloClasse/2.0, 0), -1)
dfInv2 = dfInv2[dfInv2['DAP1'] >= diametroMin,]
dfInv2$CC1 = cut(dfInv2$DAP1, breaks = intervalos, labels=centros)
