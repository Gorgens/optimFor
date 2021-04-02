require(dplyr)
require(magrittr)
require(plotly)
require(tidyr)
require(reshape2)
require(ggplot2)

inv.paisagens = read.csv("10_invPaisagensMerged.csv")
inv.paisagens.filtered = inv.paisagens %>%
  filter(type == "O" | is.na(type)) %>%                                         # remover não árvores
  filter(scientific.name != 'NI') %>%                                           # remover indivíduos não indentificados
  drop_na(DBH)                                                                  # remover valores NA no DBH

ggplot(inv.paisagens.filtered, aes(DBH, Htot)) +                                # gráfico da hipsometria dos dados do paper
  geom_point(alpha = 0.1) + 
  theme_bw() + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(),
                     axis.line = element_line(colour = "black"))
ggsave("./graphHipsometria.png")

parcelasArea = inv.paisagens.filtered %>%                                       # conta número de parcelas em cada área
  group_by(area, plot, subplot, year) %>%
  summarise(obs = n()) %>%
  group_by(area, year) %>%
  summarise(nplots = n()) %>%
  group_by(area) %>%
  summarise(nplots = mean(nplots))

### Critérios por espécie -------------------------------
speciesList = inv.paisagens.filtered %>%                                        # Lista das espécies com maior número de árvores
  group_by(scientific.name) %>%
  summarise(ntree = n()) %>%
  filter(ntree > 300) %>%
  select(scientific.name)

# Densidade de indivíduos
arvHaEspecie = inv.paisagens.filtered %>%
  filter(DBH >= 10) %>%
  group_by(area, plot, subplot, year, scientific.name) %>% 
  summarise(ntree = sum(eqTree)) %>%
  drop_na(ntree) %>%
  group_by(area, plot, subplot, scientific.name) %>%
  summarise(ntree = mean(ntree)) %>%
  group_by(area, scientific.name) %>%
  summarise(ntree = sum(ntree)) %>%
  left_join(parcelasArea) %>%
  mutate(arvha = ntree / nplots) %>%
  group_by(scientific.name) %>%
  summarise(arvha = mean(arvha))

# Distribuição diamétrica
numeroArvores = inv.paisagens.filtered %>%
  filter(scientific.name == speciesList$scientific.name[1]) %>%
  filter(DBH >= 10) %>%
  group_by(area, plot, subplot, year, cc) %>% 
  summarise(ntree = sum(eqTree))  %>%
  drop_na(ntree) %>%
  group_by(area, cc) %>%
  summarise(narv = sum(ntree)) %>%
  left_join(parcelasArea) %>%
  mutate(arvha = narv / nplots) %>%
  group_by(cc) %>%
  summarise(arvha = mean(arvha))
  
ggplot(numeroArvores, aes(cc, arvha)) + geom_col() +
  xlab('Diameter distribution') + ylab('Trees per hectare') +
  ggtitle(paste0(speciesList$scientific.name[1])) + 
  theme_bw() + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(),
                     axis.line = element_line(colour = "black"))
ggsave(paste0('dd_',speciesList$scientific.name[1], '.png'))

# Ciclo de exploração
pareado = inv.paisagens %>% dcast(area + plot + subplot + tree ~ year, 
                                  value.var="DBH", fun.aggregate=sum)
incremento = pareado %>%
  group_by(area, plot, subplot, tree) %>%
  summarise(minDBH = min(DBH), maxDBH = max(DBH), inc = max(DBH) - min(DBH)) %>%
  filter(inc > 0)

# Padrão espacial








