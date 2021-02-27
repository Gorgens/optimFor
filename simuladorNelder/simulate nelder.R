require(circular)
require(plotly)
require(reshape2)

# Simula o delineamento nelder --------------------------
iniciaRaio = 10
comprimentoRaio = 50
entrePlantasRaio = 10
anguloEntreRaios = 30
nRaios = 360 / anguloEntreRaios

posicaoRaio = seq(iniciaRaio, comprimentoRaio+0.01, entrePlantasRaio)


coordenadas = function(dist, angulo){
  x = round(cos(circular::rad(angulo)) * dist, 1)
  y = round(sin(circular::rad(angulo)) * dist, 1)
  return(c(x, y))
}

raio = c()
dist = c()
x = c()
y = c()
n = 1
for(r in seq(1, nRaios)){
  for(d in posicaoRaio){
    coord = coordenadas(d, r*anguloEntreRaios)
    #print(r, d, coord[0], coord[1])
    raio[n] = r
    dist[n] = d
    x[n] = coord[1]
    y[n] = coord[2]
    n = n + 1
  }
}

nelder = data.frame(raio = raio, distancia = dist, coordx = x, coordy = y)
minx = min(nelder$coordx)
if(minx < 0){
  nelder$coordx = nelder$coordx + -1*minx
}
miny = min(nelder$coordy)
if(miny < 0){
  nelder$coordy = nelder$coordy + -1*miny
}


fig = plot_ly(data = nelder, x = ~coordx, y = ~coordy, 
               type = 'scatter', mode = 'markers')
fig


# Simula superfície de resposta -------------------------

# Homogênea
df.surface = tidyr::expand_grid(x = seq(min(nelder$coordx), max(nelder$coordx), length.out = comprimentoRaio*2), 
                                 y = seq(min(nelder$coordy), max(nelder$coordy), length.out = comprimentoRaio*2))
df.surface$z = (3 + 0 * df.surface$x**0 - 0 * df.surface$y**0)
surface = reshape2::acast(df.surface, x~y, value.var="z")

fig = plot_ly(z = surface) %>% add_surface()
#fig = add_markers(fig, data = nelder, y = ~coordy, x = ~coordx, z = 0, name = 'trees', mode = 'markers', size=2)
fig

# Efeito lateral
df.surface = tidyr::expand_grid(x = seq(min(nelder$coordx), max(nelder$coordx), length.out = comprimentoRaio*2), 
                                 y = seq(min(nelder$coordy), max(nelder$coordy), length.out = comprimentoRaio*2))
df.surface$z = ((df.surface$x-50)**2)/3000
surface = reshape2::acast(df.surface, x~y, value.var="z")

fig = plot_ly(z = surface) %>% add_surface()
#fig = add_markers(fig, data = nelder, y = ~coordy, x = ~coordx, z = 0, name = 'trees', mode = 'markers', size=2)
fig

# Efeito chapéu
df.surface = tidyr::expand_grid(x = seq(min(nelder$coordx), max(nelder$coordx), length.out = comprimentoRaio*2), 
                                 y = seq(min(nelder$coordy), max(nelder$coordy), length.out = comprimentoRaio*2))
df.surface$z = (50 - 0.01 * (df.surface$x-comprimentoRaio)^2 - 0.01 * (df.surface$y-comprimentoRaio)^2)/10
surface = reshape2::acast(df.surface, x~y, value.var="z")

fig = plot_ly(z = surface) %>% add_surface()
#fig = add_markers(fig, data = nelder, y = ~coordy, x = ~coordx, z = 0, name = 'trees', mode = 'markers', size=2)
fig

# Efeito cuia
df.surface = tidyr::expand_grid(x = seq(min(nelder$coordx), max(nelder$coordx), length.out = comprimentoRaio*2), 
                                y = seq(min(nelder$coordy), max(nelder$coordy), length.out = comprimentoRaio*2))
df.surface$z = (0.01 * (df.surface$x-comprimentoRaio)^2 + 0.01 * (df.surface$y-comprimentoRaio)^2)/10
surface = reshape2::acast(df.surface, x~y, value.var="z")

fig = plot_ly(z = surface) %>% add_surface()
#fig = add_markers(fig, data = nelder, y = ~coordy, x = ~coordx, z = 0, name = 'trees', mode = 'markers', size=2)
fig