require(dplyr)
require(magrittr)
require(plotly)


inv.paisagens = read.csv("10_invPaisagensMerged.csv")

# check number number of observation in dataframe
sapply(inv.paisagens, function(x) sum(is.na(x)))
table(inv.paisagens$area)

# remove NA values for DBH
inv.paisagens.filtered = inv.paisagens %>% 
  filter(type == "O" | is.na(type)) %>%
  filter(scientific.name != 'NI') %>%
  drop_na(DBH)

# count n tree
speciesList = inv.paisagens.filtered %>%
  group_by(scientific.name) %>%
  summarise(ntree = n()) %>%
  filter(ntree > 300) %>%
  select(scientific.name)

# ntree per hectare by area
arvHaArea = inv.paisagens.filtered %>%
  group_by(area, plot, subplot) %>% 
  summarise(ntree = sum(eqTree)) %>%
  group_by(area) %>%
  summarise(ntree = mean(ntree))

# plot diameter distribution n/ha
inv.paisagens.filtered %>%
  filter(scientific.name %in% speciesList$scientific.name) %>%
  group_by(scientific.name) %>%
  do(p=plot_ly(., x = ~cc, name = ~scientific.name, type = "histogram")) %>%
  subplot(nrows = 5, shareX = TRUE, shareY = TRUE)

