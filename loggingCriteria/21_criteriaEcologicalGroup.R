require(dplyr)
require(magrittr)
require(plotly)
require(tidyr)
require(reshape2)
require(ggplot2)
require(V.PhyloMaker)
require(phytools)

inv.paisagens = read.csv("10_invPaisagensMerged.csv")
inv.paisagens.filtered = inv.paisagens %>%
  filter(type == "O" | is.na(type)) %>%                                         # remover não árvores
  filter(scientific.name != 'NI') %>%                                           # remover indivíduos não indentificados
  drop_na(DBH)                                                                  # remover valores NA no DBH

parcelasArea = inv.paisagens.filtered %>%                                       # conta número de parcelas em cada área
  group_by(area, plot, subplot, year) %>%
  summarise(obs = n()) %>%
  group_by(area, year) %>%
  summarise(nplots = n(), trees = sum(obs)) %>%
  group_by(area) %>%
  summarise(nplots = mean(nplots), trees = sum(trees))

grupo = "Intermediate"
grupo = "Shade-tolerant"
grupo = "Light-demanding" 
grupo = "Pioneer"
grupo = "Emergent"

## Grupo Ecológico -------------------------------------------------------------
grupoEcologico = inv.paisagens.filtered %>%
  filter(GrupoEco == grupo)

# Filogenia
filogenia = grupoEcologico %>%                                                    # filogenia das spécies estudadas
  group_by(scientific.name, genera.name, family.name) %>%
  summarise(n = n()) %>%
  drop_na(family.name) %>%
  filter(!is.na(family.name)) %>%
  filter(family.name != 'NI')

phy = phylo.maker(filogenia[,1:3])
tree = phy$scenario.3
png(paste0('./plot/filo_', grupo, '.png'), width = 10, height = 10, units = 'cm', res = 300)
plotTree(tree, type='fan', fsize=0.5, lwd=1, ftype='i')
dev.off()

### Critérios por espécies grupo escológico ------------------------------------

# Densidade de indivíduos
arvHaEspecie = inv.paisagens.filtered %>%
  filter(DBH >= 10) %>%
  group_by(area, plot, subplot, year, GrupoEco) %>% 
  summarise(ntree = sum(eqTree)) %>%
  drop_na(ntree) %>%
  group_by(area, plot, subplot, GrupoEco) %>%
  summarise(ntree = mean(ntree)) %>%
  group_by(area, GrupoEco) %>%
  summarise(ntree = sum(ntree)) %>%
  left_join(parcelasArea) %>%
  mutate(arvha = ntree / nplots) %>%
  group_by(GrupoEco) %>%
  summarise(arvha = mean(arvha))

# Distribuição diamétrica
for(i in unique(inv.paisagens.filtered$GrupoEco)){
  numeroArvores = inv.paisagens.filtered %>%
    filter(GrupoEco == i) %>%
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
  ggsave(paste0('./plot/dd_',i, '.png'), width = 13, height = 8, units = 'cm')
}

# Ciclo de exploração
#pareado = dcast(inv.paisagens, area + plot + subplot + tree ~ year, value.var='DBH', fun.aggregate=sum)
incremento = inv.paisagens %>%
  group_by(area, plot, subplot, tree, scientific.name, GrupoEco) %>%
  summarise(cc = min(cc), minDBH = min(DBH), maxDBH = max(DBH), 
            inc = max(DBH) - min(DBH), intervMed = max(year) - min(year), 
            incAnual = inc / intervMed) %>%
  filter(inc > 0)

incrementoGrupo = incremento %>%
  group_by(GrupoEco) %>%
  summarise(incAnual = mean(incAnual), tp = 50 / incAnual)

# Padrão espacial








