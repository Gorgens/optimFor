require(dplyr)
require(tidyr)
require(plotly)
require(magrittr)

inv.paisagens = read.csv("10_invPaisagensMerged.csv")
inv.paisagens.filtered = inv.paisagens %>%
  filter(type == "O" | is.na(type)) %>%                                         # remover não árvores
  filter(scientific.name != 'NI') %>%                                           # remover indivíduos não indentificados
  drop_na(DBH)   


ggplot(inv.paisagens.filtered, aes(DBH, Htot)) +                                # gráfico da hipsometria dos dados do paper
  geom_point(alpha = 0.1) + 
  theme_bw() + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(),
                     axis.line = element_line(colour = "black"))
ggsave("./plot/graphHipsometria.png")

parcelasArea = inv.paisagens.filtered %>%                                       # conta número de parcelas em cada área
  group_by(area, plot, subplot, year) %>%
  summarise(obs = n()) %>%
  group_by(area, year) %>%
  summarise(nplots = n(), trees = sum(obs)) %>%
  group_by(area) %>%
  summarise(nplots = mean(nplots), trees = sum(trees))
write.csv(parcelasArea, './tables/parcelaPorArea.csv')

#### G1 - Scatterplot ---------------
fig = inv.paisagens %>% plot_ly(x = ~DBH, y = ~Hcom, color = ~area)
fig

#### G2 - Histogram by group  ---------------
fig = inv.paisagens %>% plot_ly(x = ~cc, type = "histogram")
fig

#### G3 - Boxplot ---------------
fig = inv.paisagens %>% plot_ly(x = ~area, y = ~DBH, type = "box")
fig

#### G4 - Violin ---------------
fig = inv.paisagens %>%
  plot_ly(
    x = ~area,
    y = ~DBH,
    type = 'violin',
    box = list(visible = T),
    meanline = list(visible = T)
  ) 
fig

#### G5 - Histogram by group  ---------------
inv.paisagens%>%
  group_by(GrupoEco) %>%
  do(p=plot_ly(., x = ~cc, color = ~GrupoEco, type = "histogram")) %>%
  subplot(nrows = 4, shareX = TRUE, shareY = TRUE)


