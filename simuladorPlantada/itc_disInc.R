require(ggplot2)
require(dplyr)
require(plotly)
require(fitdistrplus)

source('parearDados.R')

## Investigar relações do incremento --------------------

# IncAnual = f(DAP1)|sitio
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~incDapAnual, 
              type="scatter", mode="markers",
              alpha = 0.5, color = ~sitio)
fig

# IncAnualPerc = f(DAP1)|sitio
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~incDapAnualPerc, 
              type="scatter", mode="markers",
              alpha = 0.5, color = ~sitio)
fig

# IncAnualPerc | sitio
fig = plot_ly(data = dfinv2, x = ~incDapAnualPerc, 
              type="histogram", alpha = 0.5, color = ~sitio, nbinsx = 15)
fig = fig %>% layout(barmode = "overlay")
fig

# IncAnualPerc | DESBASTESEQ
fig = plot_ly(data = dfinv2, x = ~incDapAnualPerc, 
              type="histogram", alpha = 0.5, color = ~factor(DESBASTESEQ), nbinsx = 15)
fig = fig %>% layout(barmode = "overlay")
fig

# IncAnualPerc | CLONESEMENTE
fig = plot_ly(data = dfinv2, x = ~incDapAnualPerc, 
              type="histogram", alpha = 0.5, color = ~factor(CLONESEMENTE1), nbinsx = 15)
fig = fig %>% layout(barmode = "overlay")
fig

# Modelo gamma para incDapAnualPerc = f(DAP1 + I1 + CLONESEMENTE + sitio + DESBASTESEQ)
dfinv2 = dfinv2 %>%
  filter(incDapAnualPerc > 0)
gammaIncDapAnualPerc = glm(data = dfinv2, incDapAnualPerc ~ DAP1 + I1 + CLONESEMENTE1 + sitio + DESBASTESEQ, family=Gamma)
summary(gammaIncDapAnualPerc)

# Distribuicao do incremento = f(CC1 + CI1 + CLONESEMENTE1 + sitio + factor(DESBASTESEQ))
parametros = list(15, 2.5, 'SEED', 'alto', 0)
fig = plot_ly(alpha = 0.6, nbinsx = 15)
temp = subset(dfinv2, CC1 = parametros[[1]] & CI1 == parametros[[2]], CLONESEMENTE1 == parametros[[3]] & sitio ==parametros[[4]] & DESBASTESEQ == parametros[[5]])
fig = fig %>% add_histogram(x = temp$incDapAnualPerc, name = paste(parametros, collapse = '-'))
temp = subset(dfinv2, CC1 = parametros[[1]] & CI1 == parametros[[2]], CLONESEMENTE1 == parametros[[3]] & sitio ==parametros[[4]] & DESBASTESEQ == parametros[[5]])
fig = fig %>% add_histogram(x = temp$incDapAnualPerc, name = paste(parametros, collapse = '-'))
temp = subset(dfinv2, CC1 = parametros[[1]] & CI1 == parametros[[2]], CLONESEMENTE1 == parametros[[3]] & sitio ==parametros[[4]] & DESBASTESEQ == parametros[[5]])
fig = fig %>% add_histogram(x = temp$incDapAnualPerc, name = paste(parametros, collapse = '-'))
temp = subset(dfinv2, CC1 = parametros[[1]] & CI1 == parametros[[2]], CLONESEMENTE1 == parametros[[3]] & sitio ==parametros[[4]] & DESBASTESEQ == parametros[[5]])
fig = fig %>% add_histogram(x = temp$incDapAnualPerc, name = paste(parametros, collapse = '-'))
fig = fig %>% layout(barmode = "overlay")
fig

# Ajustar parâmetros distribuição
temp = subset(dfinv2, CLONESEMENTE1 == 'SEED' & sitio =='alto' & DESBASTESEQ == 0)
fit.gamma <- fitdist(temp$incDapAnualPerc, distr = "gamma", method = "mle")
coef(fit.gamma)
rgamma(1, coef(fit.gamma)[1], coef(fit.gamma)[2])
