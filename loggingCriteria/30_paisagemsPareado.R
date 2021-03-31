require(dplyr)
require(magrittr)
require(tidyr)
require(reshape2)

inv.paisagens = read.csv("10_invPaisagensMerged.csv")

temp = dcast(inv.paisagens, area + trans.ID + plot + tree ~ year, value.var="DBH", fun.aggregate=sum)

temp %>% filter(area == 'DUC_A01')
