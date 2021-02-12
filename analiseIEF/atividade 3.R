# No excel, você calculou:

# número de parcelas
# Volume médio
# Variância
# desvio padrão
# t
# Intervalo de Confiança Superior (ICS):
# Intervalo de Confiança Superior (ICS):
# Erro amostral (%)

# Estes seriam os comandos no R para fazer os mesmos passos.

inventario = read.csv(file = "inventario.csv")
head(inventario)


n = nrow(inventario)
volume.medio = mean(inventario$vol_ha)
variancia = var(inventario$vol_ha)
desvio.padrao = sd(inventario$vol_ha)
t.tabelado = qt(1-.05/2,n-1)
erro.padrao = desvio.padrao/sqrt(n)
ic.superior = volume.medio + t.tabelado * erro.padrao
ic.inferior = volume.medio - t.tabelado * erro.padrao
erro.amostral = (t.tabelado * erro.padrao) / volume.medio * 100
