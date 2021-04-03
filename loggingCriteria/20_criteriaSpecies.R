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
ggsave("./plot/graphHipsometria.png")

parcelasArea = inv.paisagens.filtered %>%                                       # conta número de parcelas em cada área
  group_by(area, plot, subplot, year) %>%
  summarise(obs = n()) %>%
  group_by(area, year) %>%
  summarise(nplots = n()) %>%
  group_by(area) %>%
  summarise(nplots = mean(nplots))

### Critérios por espécies comerciais  -------------------------------
speciesList = inv.paisagens.filtered %>%                                        # Lista das espécies com maior número de árvores
  filter(comercial == 1) %>%                                                    # filtra espécies comerciais
  group_by(scientific.name) %>%
  summarise(ntree = n()) %>%
  filter(ntree > 60) %>%
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
  summarise(arvha = mean(arvha)) %>%
  filter(scientific.name %in% speciesList$scientific.name)

# Distribuição diamétrica
for(i in speciesList$scientific.name){
  numeroArvores = inv.paisagens.filtered %>%
    filter(scientific.name == i) %>%
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
    ggtitle(paste0(i)) + 
    theme_bw() + theme(panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       panel.background = element_blank(),
                       axis.line = element_line(colour = "black"))
  ggsave(paste0('./plot/dd_',i, '.png'))
}

# Ciclo de exploração
#pareado = dcast(inv.paisagens, area + plot + subplot + tree ~ year, value.var='DBH', fun.aggregate=sum)
incremento = inv.paisagens %>%
  group_by(area, plot, subplot, tree, scientific.name) %>%
  summarise(cc = min(cc), minDBH = min(DBH), maxDBH = max(DBH), 
            inc = max(DBH) - min(DBH), intervMed = max(year) - min(year), 
            incAnual = inc / intervMed) %>%
  filter(inc > 0)

ggplot(incremento, aes(as.factor(cc), incAnual)) + geom_boxplot() +
  xlab('Diameter class') +
  theme_bw() + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(),
                     axis.line = element_line(colour = "black"))
ggsave('./plot/incrementoAnual.png')

incrementoSpecies = incremento %>%
  filter(scientific.name %in% speciesList$scientific.name) %>%
  group_by(scientific.name) %>%
  summarise(incAnual = mean(incAnual), tp = 50 / incAnual)

# Padrão espacial








