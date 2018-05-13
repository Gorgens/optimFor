cadastro = read.csv("cadastro.csv")    							# importa cadastro 
mcp = read.csv("mcp.csv")										        # importa modelos de crescimento
metaProd = 20000												            # meta de producao anual

source("geradorAlternativaMaxProd.r")								# importa script que gera o plano de producao para as alternativas de manejo
source("geradorAlternativaDesvITC.r")								# importa script que gera o plano de producao para as alternativas de manejo

fo = NA														                	# variavel para armazenar a string da funcao objetivo
restArea = c()												            	# lista para armazenar restricoes de area
restProd = c()													            # criar matriz de producao 	
restProd2 = c()												            	# lista para armazenar restricoes de producao anual

for(t in seq(1, dim(cadastro)[1], 1)){							                          # para cada talhao do cadastro
  cortesR1 = c(cadastro$ITCr1[t]-1, cadastro$ITCr1[t], cadastro$ITCr1[t]+1)   # alterantivas de corte para rotacao 1
  cortesR2 = c(cadastro$ITCr2[t]-1, cadastro$ITCr2[t], cadastro$ITCr2[t]+1)   # alternativas de corte para rotacao 2
  #cortesR1 = c(6, 7, 8)   # alterantivas de corte para rotacao 1
  #cortesR2 = c(6, 7, 8)   # alternativas de corte para rotacao 2
  cenarios = expand.grid(cortesR1, cortesR2)				# cria combinacao das alternativas de manejo escolhidas: ciclo = rotacao 1 + rotacao 2							
  for(c in seq(1, dim(cenarios)[1], 1)){						# para cada alternativa de manejo
    out = alternativaITC(talhao = cadastro$ID[t],  # gera lista com: nome da variavel, calcula coeficiente de producao no horizonte, e horizonte de producao para a alternativa de manejo
                      area = cadastro$AREA[t], 
                      idade = cadastro$IDADE[t], 
                      rotacao = cadastro$ROTACAO[t],
                      ITCr1 = cadastro$ITCr1[t],
                      ITCr2 = cadastro$ITCr2[t],
                      icR1 = cenarios[c,1], 
                      icR2 = cenarios[c,2], 
                      modeloR1 = mcp[mcp$MatGen == cadastro$ESPECIE[t] & mcp$Sitio == cadastro$SITIO[t] & mcp$Rotacao == 1, c(4, 5, 6)], 
                      modeloR2 = mcp[mcp$MatGen == cadastro$ESPECIE[t] & mcp$Sitio == cadastro$SITIO[t] & mcp$Rotacao == 2, c(4, 5, 6)])
    if(t == 1 & c == 1){										              # se primeiro talhao e primeira alternativa de manejo
      fo = paste(round(out[[2]], 2), out[[1]])			      # inicia a FO com o coeficiente e nome da alternativa
    } else{													                    	# para os demais talhoes
      fo = paste(fo, "+", round(out[[2]], 2), out[[1]])		# adiciona o coeficiente e nome da alternativa
    }
    
    if(c==1){													                            # se primeiro cenario de um determinado talhao
      restArea[t] = out[[1]]									                    # inicie a restricao de area com o nome da alternativa
    }else{														                            # para os demais cenarios
      restArea[t] = paste(restArea[t], "+", out[[1]])			        # adicione na string o nome da variavel
    }
    restProd = rbind(restProd, paste(out[[3]], out[[1]]))	        # adiciona na matriz de producao o horizonte de producao de cada alternativa
  }
  restArea[t] = paste(restArea[t], "<=", cadastro$AREA[t], ";")	  # apos todas as alternativas de um determinado talhao, finaliza a restricao de area com inequacao e area do talhao
}

fo = paste(fo, ";")												                        # apos a criacao de todas as alternativas de manejo de todos os talhoes finaliza a FO

for(h in seq(1, dim(restProd)[2], 1)){                            # para cada coluna da matriz de producao - ano de producao
  for(c in seq(1, dim(restProd)[1], 1)){                          # para cada linha da matriz de producao - alternativa 
    if(c == 1){                                                   # se primeira alternativa do ano de producao analizado
      restProd2[h] = restProd[c,h]                                # incia a restricao de producao do ano analizado com o coeficiente e alternativa
    }else{                                                        # se demais alternativas do ano de producao analizado
      restProd2[h] = paste(restProd2[h], "+", restProd[c,h])      # adicionar coeficiente e alternativa
    }
  }
  restProd2[h] = paste(restProd2[h], ">=", metaProd, ";")         # finalizando todas as alternativas do ano, finaliza a restricao com ;
}

#print(fo)
#print(restArea)
#print(restProd)[1:5,]
#print(restProd2)
write.csv(restProd, "tabelaProducao.csv")                         # exporta matriz de producao numa arquivo csv

fileConn<-file("lpsolveModel.txt")                                # abre arquivo para criar modelo matematico
writeLines(fo, fileConn)                                          # adicionar FO ao arquivo
close(fileConn)                                                   # fecha arquivo

for(l in restArea){                                               # adiciona cada restricao de area ao arquivo de formulacao matematica
  write(l, file="lpsolveModel.txt",append=TRUE)
}
for(l in restProd2){                                              # adiciona cada restricao de producao anual ao arquivo de formulacao matematica
  write(l, file="lpsolveModel.txt",append=TRUE)
}
