## referências: https://www.revistaespacios.com/a17v38n23/a17v38n23p13.pdf
require(plotly)

VFCC = function(dap){                                                           # modelo para estimar o volume
  return(0.0233768+
         0.00730236*dap-
         0.000430709*dap^2+
         0.0000233749*dap^3)
}

nparcelas = 30                                                                  # número de parcelas na simulação
inventario = data.frame(parcela = integer(),
                              arvore = integer(),
                              dap = double(),
                              vol = double())
for(i in seq(nparcelas)){                                                       # gera parcelas aleatórias
  n = ceiling(rnorm(1, 545, 50))
  arvore = seq(n)
  dap = rweibull(n, 2.5, 7)
  vol = VFCC(dap)
  parcela = rep(i, n)
  temp = data.frame(parcela, arvore, dap, vol)
  inventario = rbind(inventario, temp)
}

# Desvio em relação ao diâmetro ------------------
erroMedio = c()
desvPadMedio = c()
variacaoErroMedio = seq(-1, 1, 0.1)
variacaoDesvMedio = seq(0.01, 1, 0.05)
for(m in variacaoErroMedio){
  for(d in variacaoDesvMedio){
      erroMedio = append(erroMedio, m)
      desvPadMedio = append(desvPadMedio, d)
  }
}
simulado = data.frame(erroMedio,
                      desvPadMedio,
                      t_pvalue = 0,
                      ks_pvalue = 0)
for(m in variacaoErroMedio){
  for(d in variacaoDesvMedio){
    t_pvalue = c()
    ks_pvalue = c()
    for(i in seq(100)){
      conferencia = subset(inventario, 
                           parcela %in% sample(seq(nparcelas), 0.1*nparcelas))
      mediaDesvio = m
      desvPadDesvio = d
      desvio = rnorm(dim(conferencia)[1], mediaDesvio, desvPadDesvio)           # gera desvio aleatório
      conferencia$dapConferencia = conferencia$dap + desvio
      
      t_pvalue[i] = as.numeric(t.test(conferencia$dap, 
                                      conferencia$dapConferencia, 
                                      paired = TRUE)[3])
      ks_pvalue[i] = as.numeric(ks.test(conferencia$dap, 
                                        conferencia$dapConferencia)[2])
    }
    simulado[simulado$erroMedio == m & 
               simulado$desvPadMedio == d, 3] = mean(t_pvalue)
    simulado[simulado$erroMedio == m & 
               simulado$desvPadMedio == d, 4] = mean(ks_pvalue)
  }
}


plot_ly(x=simulado$erroMedio, y=simulado$desvPadMedio, z=simulado$t_pvalue, 
        type="scatter3d", mode="markers", color=temp)

plot_ly(x=simulado$erroMedio, y=simulado$desvPadMedio, z=simulado$ks_pvalue, 
        type="scatter3d", mode="markers", color=temp)
