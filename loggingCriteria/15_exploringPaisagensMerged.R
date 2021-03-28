require(dplyr)
require(tidyr)
require(plotly)
require(magrittr)

inv.paisagens = read.csv("10_invPaisagensMerged.csv")

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


