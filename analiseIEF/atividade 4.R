require(dplyr)

simulacoes = 100
resultado.simulacoes = data.frame(simulacao = seq(1, simulacoes, 1),
                                  n = rep(1, simulacoes),
                                  volume.medio = rep(1, simulacoes),
                                  variancia = rep(1, simulacoes),
                                  desvio.padrao = rep(1, simulacoes),
                                  erro.padrao = rep(1, simulacoes),
                                  ic.superior = rep(1, simulacoes),
                                  ic.inferior = rep(1, simulacoes),
                                  erro.amostral = rep(1, simulacoes))

for(j in seq(1, simulacoes, 1)){
  
  floresta = read.csv('simulated forest heterogenea.csv', header = FALSE)
  
  leg = 20
  linhas = nrow(floresta)
  colunas = ncol(floresta)
  
  nparcelas = 30
  
  coordx = nparcelas %>% runif(1, colunas) %>% floor()
  coordy = nparcelas %>% runif(1, linhas) %>% floor()
  
  inventario = data.frame(parcela = seq(1, nparcelas, 1),
                          coordx = coordx,
                          coordy = coordy,
                          vol_ha = rep(1, nparcelas))
  
  for(i in seq(1, nparcelas, 1)){
    inventario[inventario$parcela == i,'vol_ha'] = floresta[inventario[inventario$parcela == i,'coordy'], 
                                                            inventario[inventario$parcela == i,'coordx']]
  }
  
  resultado.simulacoes$volume.medio[j] = mean(inventario$vol_ha)
  resultado.simulacoes$variancia[j] = var(inventario$vol_ha)
  resultado.simulacoes$desvio.padrao[j] = sd(inventario$vol_ha)
  t.tabelado = qt(1-.05/2,n-1)
  resultado.simulacoes$erro.padrao[j] = sd(inventario$vol_ha)/sqrt(nrow(inventario))
  resultado.simulacoes$ic.superior[j] = mean(inventario$vol_ha) + t.tabelado * sd(inventario$vol_ha)/sqrt(nrow(inventario))
  resultado.simulacoes$ic.inferior[j] = mean(inventario$vol_ha) - t.tabelado * sd(inventario$vol_ha)/sqrt(nrow(inventario))
  resultado.simulacoes$erro.amostral[j] = (t.tabelado * sd(inventario$vol_ha)/sqrt(nrow(inventario))) / mean(inventario$vol_ha) * 100
}