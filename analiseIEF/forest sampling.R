require(dplyr)

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

write.csv(inventario, 'inventario.csv')
