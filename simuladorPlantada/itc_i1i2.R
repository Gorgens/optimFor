require(ggplot2)
require(dplyr)
require(plotly)

source('parearDados.R')

## Investigar relações i1/i2 --------------------

## DAP --------------------------------
# DAP2 = f(DAP1)|sitio
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~sitio)
fig

# DAP2 = f(DAP1)|cc
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~CC1)
fig

# DAP2 = f(DAP1)|clonesemente
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~CLONESEMENTE1)
fig

# DAP2 = f(DAP1)|idade
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~I1)
fig

# DAP2 = f(DAP1)|desbasteseq
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~DESBASTESEQ)
fig

# DAP2 = f(DAP1)|tipodesbaste
fig = plot_ly(data = dfinv2, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~TIPODESBASTE)
fig

# Teste de Hipótese: DAP2 = f(DAP1)|variables
lm.dall = lm(DAP2 ~ DAP1, data = dfinv2)
lm.dsitio = lm(DAP2 ~ DAP1:sitio, data = dfinv2)
anova(lm.dall, lm.dsitio)
lm.dcc = lm(DAP2 ~ DAP1:CC1, data = dfinv2)
anova(lm.dall, lm.dcc)
lm.dcs = lm(DAP2 ~ DAP1:CLONESEMENTE1, data = dfinv2)
anova(lm.dall, lm.dcs)
lm.didade = lm(DAP2 ~ DAP1 * I1, data = dfinv2)         
anova(lm.didade, lm.dall)                               
lm.dall = lm(DAP2 ~ DAP1, data = dfinv2[!is.na(dfinv2$DESBASTESEQ),])
lm.ddes = lm(DAP2 ~ DAP1:factor(DESBASTESEQ), data = dfinv2[!is.na(dfinv2$DESBASTESEQ),])
anova(lm.dall, lm.ddes)                                 

lm.dred = lm(DAP2 ~ -1 + DAP1, data = dfinv2[!is.na(dfinv2$DESBASTESEQ),])
lm.dcompleto = lm(DAP2 ~ -1 + DAP1 + sitio + I1 + CLONESEMENTE1 + factor(DESBASTESEQ), 
                  data = dfinv2[!is.na(dfinv2$DESBASTESEQ),])
anova(lm.dred, lm.dcompleto)

## Altura --------------------------------
inv2alt = dfinv2 %>% filter(ALT1 > 0 & ALT2 > 0)

# ALT2 = f(ALT1)|sitio
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~sitio)
fig

# ALT2 = f(ALT1)|cc
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~CC1)
fig

# ALT2 = f(ALT1)|clonesemente
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~CLONESEMENTE1)
fig

# ALT2 = f(ALT1)|idade
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~I1)
fig

# ALT2 = f(ALT1)|desbasteseq
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~DESBASTESEQ)
fig

# ALT2 = f(ALT1)|tipodesbaste
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~TIPODESBASTE)
fig

# ALT2 = f(ALT1)|DAP1
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
              type="scatter", mode="markers",
              alpha = 0.7, color = ~log(DAP1))
fig

# Teste de Hipótese: ALT2 = f(ALT1)|variables
lm.aall = lm(ALT2 ~ ALT1, data = inv2alt)
lm.asitio = lm(ALT2 ~ ALT1:sitio, data = inv2alt)
anova(lm.aall, lm.asitio)
lm.acc = lm(ALT2 ~ ALT1:CC1, data = inv2alt)
anova(lm.aall, lm.acc)
lm.acs = lm(ALT2 ~ ALT1:CLONESEMENTE1, data = inv2alt)
anova(lm.aall, lm.acs)
lm.aidade = lm(ALT2 ~ ALT1 * I1, data = inv2alt)         
anova(lm.aidade, lm.aall) 
lm.adap = lm(ALT2 ~ ALT1 * DAP1, data = inv2alt)         
anova(lm.adap, lm.aall) 
lm.aall = lm(ALT2 ~ ALT1, data = inv2alt[!is.na(inv2alt$DESBASTESEQ),])
lm.ades = lm(ALT2 ~ ALT1:factor(DESBASTESEQ), data = inv2alt[!is.na(inv2alt$DESBASTESEQ),])
anova(lm.aall, lm.ades)                                 

lm.ared = lm(ALT2 ~ -1 + ALT1, data = inv2alt[!is.na(inv2alt$DESBASTESEQ),])
lm.acompleto = lm(ALT2 ~ -1 + ALT1  + DAP1 + sitio + I1 + CLONESEMENTE1 + factor(DESBASTESEQ), 
                  data = inv2alt[!is.na(inv2alt$DESBASTESEQ),])
anova(lm.ared, lm.acompleto)
summary(lm.acompleto)


