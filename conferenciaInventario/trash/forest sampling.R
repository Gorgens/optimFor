require(dplyr)

simulacoes = 100
resultado.simulacoes = data.frame(simulacao = seq(1, simulacoes, 1),
                                  volume.medio.original = rep(1, simulacoes),
                                  volume.inferior.original = rep(1, simulacoes),
                                  volume.superior.original = rep(1, simulacoes),
                                  volume.medio.conferencia = rep(1, simulacoes),
                                  volume.inferior.conferencia = rep(1, simulacoes),
                                  volume.superior.conferencia = rep(1, simulacoes))

for(j in seq(1, simulacoes, 1)){
  # selecionar parcelas aleatórias ----------------
  
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

  #write.csv(inventario, 'inventario.csv')
  
  # # Inclue um erro nas parcelas conferidas ----------------------
  # inventario$vol2_ha = inventario$vol_ha
  # parcela.checkagem = sample(seq(1, nparcelas, 1), nparcelas*0.1)
  # erro.medio = 0.50
  # 
  # for(p in parcela.checkagem){
  #   inventario$vol2_ha[p] = inventario$vol_ha[p] * (1+erro.medio)
  # }
  
  # Inclue um erro das parcelas conferidas em todas as parcelas ----------------------
  inventario$vol2_ha = inventario$vol_ha
  erro.medio = 0.10
  
  for(p in seq(1, nparcelas, 1)){
    inventario$vol2_ha[p] = inventario$vol_ha[p] * (1+erro.medio)
  }

  # Calcular estatísticas ----------------
  
  # Ref: http://www.mensuracaoflorestal.com.br/capitulo-4-amostragem-casual-simples#:~:text=A%20amostragem%20casual%20simples%20%C3%A9,mesmas%20chances%20de%20ser%20selecionadas.
  
  media.original = mean(inventario$vol_ha)
  variancia.original = var(inventario$vol_ha)
  desvio.padrao.original = sd(inventario$vol_ha)
  erro.padrao.original = sqrt(variancia.original/nparcelas)
  
  erro.amostral.original = erro.padrao.original * qt(1-.05/2,nparcelas-1)
  erro.amostral.perc.original = erro.amostral.original/media.original*100
  
  volume.total.original = media.original * linhas * colunas
  lim.inferior.original = (media.original - erro.amostral.original) * linhas * colunas
  lim.superior.original = (media.original + erro.amostral.original) * linhas * colunas
  
  resultado.simulacoes$volume.medio.original[j] = volume.total.original
  resultado.simulacoes$volume.inferior.original[j] = lim.inferior.original
  resultado.simulacoes$volume.superior.original[j] = lim.superior.original
  
  
  media.conferencia = mean(inventario$vol2_ha)
  variancia.conferencia = var(inventario$vol2_ha)
  desvio.padrao.conferencia = sd(inventario$vol2_ha)
  erro.padrao.conferencia = sqrt(variancia.conferencia/nparcelas)
  
  erro.amostral.conferencia = erro.padrao.conferencia * qt(1-.05/2,nparcelas-1)
  erro.amostral.perc.conferencia = erro.amostral.conferencia/media.conferencia*100
  
  volume.total.conferencia = media.conferencia * linhas * colunas
  lim.inferior.conferencia = (media.conferencia - erro.amostral.conferencia) * linhas * colunas
  lim.superior.conferencia = (media.conferencia + erro.amostral.conferencia) * linhas * colunas
  
  resultado.simulacoes$volume.medio.conferencia[j] = volume.total.conferencia
  resultado.simulacoes$volume.inferior.conferencia[j] = lim.inferior.conferencia
  resultado.simulacoes$volume.superior.conferencia[j] = lim.superior.conferencia
}

# Percentual de resultados fora do intervalo de confiança -------------------

resultado.simulacoes$check = (resultado.simulacoes$volume.inferior.conferencia > sum(floresta) |
                                resultado.simulacoes$volume.superior.conferencia < sum(floresta))

print(nrow(subset(resultado.simulacoes, check == TRUE))/simulacoes * 100)
