require(ggplot2)
require(dplyr)
require(plotly)

source('parearDados.R')

# Relação DAP2 = f(DAP1)|sitio
fig = plot_ly(data = d.baixo, x = ~DAP1)

d.baixo = dfInv2 %>% filter(sitio == 'baixo')
m.baixo = lm(DAP2~DAP1, data = d.baixo)
fig = add_markers(fig, y = ~DAP2, 
              type="scatter", mode="markers", name = 'baixo', 
              alpha = 0.2, color = I('red'))
fig = add_lines(fig, x = ~DAP1, y = fitted(m.baixo), name = 'baixo')

d.medio = dfInv2 %>% filter(sitio == 'medio')
m.medio = lm(DAP2~DAP1, data = d.medio)
fig = add_markers(fig, data = d.medio, x = ~DAP1, y = ~DAP2, 
              type="scatter", mode="markers", name = 'baixo',
              alpha = 0.2, color = I('green'))
fig = add_lines(fig, data = d.medio, x = ~DAP1, y = fitted(m.medio), 
                name = 'baixo', color = I('green') )

d.alto = dfInv2 %>% filter(sitio == 'alto')
m.alto = lm(DAP2~DAP1, data = d.alto)
fig = add_markers(fig, data = d.alto, x = ~DAP1, y = ~DAP2, 
                  type="scatter", mode="markers", name = 'alto', 
                  alpha = 0.2, color = I('blue'))
fig = add_lines(fig, data = d.alto, x = ~DAP1, y = fitted(m.alto), 
                name = 'alto', color = I('blue') )
fig


## Modelo DAP2 = f(DAP1) ---------------------------------------
fig = plot_ly(data = dfInv2, x = ~DAP1)
fig = add_markers(fig, y = ~DAP2, 
                  type="scatter", mode="markers", name = 'DAP', 
                  alpha = 0.5, color = I('black'))
m.dap2 = lm(DAP2~DAP1, data = dfInv2)
fig = add_lines(fig, x = ~DAP1, y = fitted(m.dap2), name = 'DAP')
fig

fig = plot_ly(x = m.dap2$residuals, type = "histogram")
fig = layout(fig, xaxis = list(range = c(-4, 4)))
fig

## Modelo ALT2 = f(ALT1) ---------------------------------------
inv2alt = dfInv2 %>% filter(ALT1 > 0 & ALT2 > 0)
fig = plot_ly(data = inv2alt, x = ~ALT1, y = ~ALT2, 
                  type="scatter", mode="markers", name = 'ALT', 
                  alpha = 0.3, color = I('black'))
m.alt2 = lm(ALT2~ALT1, data = inv2alt)
fig = add_lines(fig, x = ~ALT1, y = fitted(m.alt2), name = 'ALT')
fig

fig = plot_ly(x = m.alt2$residuals, type = "histogram")
fig = layout(fig, xaxis = list(range = c(-4, 4)))
fig
