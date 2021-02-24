require(dplyr)

df2017 = read.csv('antes2017.csv')
df2018 = read.csv('pos2018.csv')
anoDesbaste = read.csv('desbaste.csv')

# Organiza as bases e une
df2018 = df2018 %>% select(-FILA1, -FILA2)
dfinv = df2017 %>% bind_rows(df2018)

dfinv$sitio = cut(dfinv$S, 3, labels = c('baixo', 'medio', 'alto'))
dfinv$idadeInteira = floor(dfinv$I1)
dfinv$intervaloMed = dfinv$I2 - dfinv$I1
dfinv$incrementoDap = dfinv$DAP2 - dfinv$DAP1
dfinv$incDapAnual = dfinv$incrementoDap / dfinv$intervaloMed
dfinv$incDapAnualPerc = dfinv$incDapAnual / dfinv$DAP1
dfinv = dfinv %>%  
  mutate(binarioCresce = if_else(incDapAnual==0,0,1))

dfinv2 = dfinv %>% left_join(anoDesbaste, by = c('CODPROJETO', 'CODTALHAO', 'ANOREF1'))


intervaloClasse = 10.0
diametroMin = 10.0
classeMax = ((max(dfinv2$DAP1) %/% intervaloClasse) + 1) * intervaloClasse
intervalos = seq(diametroMin, classeMax, intervaloClasse) - 0.001
centros = head(round(intervalos + intervaloClasse/2.0, 0), -1)
dfinv2 = dfinv2[dfinv2['DAP1'] >= diametroMin,]
dfinv2$CC1 = cut(dfinv2$DAP1, breaks = intervalos, labels=centros)

intervaloClasse = 5.0
idadeMin = 0
idadeMax = ((max(dfinv2$I1) %/% intervaloClasse) + 1) * intervaloClasse
intervalos = seq(idadeMin, idadeMax, intervaloClasse) - 0.001
centros = head(round(intervalos + intervaloClasse/2.0, 1), -1)
dfinv2 = dfinv2[dfinv2['I1'] >= idadeMin,]
dfinv2$CI1 = cut(dfinv2$I1, breaks = intervalos, labels=centros)
