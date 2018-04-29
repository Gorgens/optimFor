cadastro = read.csv("cadastro.csv")
mcp = read.csv("mcp.csv")
cortesR1 = c(6, 7, 8)
cortesR2 = c(6, 7, 8)
metaProd = 20000

source("geradorAlternativa.r")
cenarios = expand.grid(cortesR1, cortesR2)
fo = NA
restArea = c()
restProd = c()
restProd2 = c()


for(t in seq(1, 4, 1)){ #dim(cadastro)[1]
  for(c in seq(1, dim(cenarios)[1], 1)){
    out = alternativa(talhao = cadastro$ID[t], area = cadastro$AREA[t], 
                      idade = cadastro$IDADE[t], rotacao = cadastro$ROTACAO[t], 
                      icR1 = cenarios[c,1], icR2 = cenarios[c,2], 
                      modeloR1 = mcp[mcp$MatGen == cadastro$ESPECIE[t] & mcp$Sitio == cadastro$SITIO[t] & mcp$Rotação == 1, c(4, 5, 6)], 
                      modeloR2 = mcp[mcp$MatGen == cadastro$ESPECIE[t] & mcp$Sitio == cadastro$SITIO[t] & mcp$Rotação == 2, c(4, 5, 6)])
    if(c == 1){
      fo = paste(round(out[[2]], 2), out[[1]])
    } else{
    fo = paste(fo, "+", round(out[[2]], 2), out[[1]])
    }
    
    if(c==1){
      restArea[t] = out[[1]]
    }else{
      restArea[t] = paste(restArea[t], "+", out[[1]])
    }
    restProd = rbind(restProd, paste(out[[3]], out[[1]]))
  }
  restArea[t] = paste(restArea[t], "<=", cadastro$AREA[t], ";")
}

fo = paste(fo, ";")

for(h in seq(1, dim(restProd)[2], 1)){
  for(c in seq(1, dim(restProd)[1], 1)){
    if(c == 1){
      restProd2[h] = restProd[c,h]
    }else{
      restProd2[h] = paste(restProd2[h], "+", restProd[c,h])
    }
  }
  restProd2[h] = paste(restProd2[h], ">=", metaProd, ";")
}

#print(fo)
#print(restArea)
#print(restProd)[1:5,]
#print(restProd2)

 
fileConn<-file("lpsolveModel.txt")
writeLines(fo, fileConn)
close(fileConn)

for(l in restArea){
  write(l, file="lpsolveModel.txt",append=TRUE)
}
for(l in restProd2){
  write(l, file="lpsolveModel.txt",append=TRUE)
}
