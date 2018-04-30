source("agenteArvore.R")						# abrir arquivo com agente árvore modelado

# Simulação ----------------------------------

vivas = list()									# inicializa lista de árvore da parcela
p.dap = c()										# inicializa vetor de diametros de arvores vivas

i = 1											# inicializa contador para dap incluídos
while (i < 580){								# looping para criação de 580 árvores
  indap = rgamma(1, shape = 1.1, rate=0.08)		# gera aleatoriamente um diametro
  if(indap >= 10){								# verifica se DAP é maior que 10 cm
    vivas = c(vivas, tree$new(dap = indap, 
							  live = 1, 
							  trackLife = 1, 
							  dead = NULL))		# cria um objeto árvore viva e com DAP gerado anteriormente
    p.dap = c(p.dap, tail(vivas, 1)[[1]]$dap)	# adiciona DAP da árvore na lista de diâmetros
    i = i + 1									# incrementa contador de árvores incluídas
  }
}

hist(p.dap, breaks = 20)						# cria a distribuição diamétrica da parcela gerada

# Looping simulando tempo -----------------

plot(1, 
	 type="n", 
	 xlab="", 
	 ylab="", 
	 xlim=c(0, 50), 
	 ylim=c(0, 1000))   						# cria um canvas vazio para plotarmos o volume de cada ano


n =  1											# inicializa a variável que contatará a passagem de anos
mortas = list()									# inicializa lista das árvore que irão morrer na simulação
while(n < 50){									# looping para simulação de 50 anos
  remanescentes = list()						# inicializa lista para armazenar árvores que irão crescer e passar para o próximo ano
  p.vol = c()									# inicializa vetor para armezar volume da parcela de um ano simulado
  for(t in vivas){								# looping sobre as árvores vivas da parcela
    if(t$live == 1){							# inicia a condicional para árvores vivas
      p.vol = c(p.vol, t$vol())					# se viva, adiciona volume no vetor de volume
      t$growthDap()								# se viva, aplica função de crescimento para o próximo ano
      remanescentes = c(remanescentes, t)		# se viva, adiciona a árvore na lista das remanescentes
    } else {									# inicia condicional para árvores mortas
      mortas = c(mortas, t)						# se morta, inclui a árvore na lista de mortas
    }
    if(runif(1, 0, 1) <= 0.02){					# condicional para realizar mortalidade de percentual de árvores
      remanescentes = c(remanescentes, 
						tree$new(dap = 10, 
								 live = 1, 
								 trackLife = 1, 
								 dead = NULL))	# adiciona um árvore ingressante na lista das remanescentes
      p.vol = c(p.vol, 
				tail(remanescentes, 
					 1)[[1]]$vol())				# adiciona o volume das árvores ingressantes no vetor de volume
    }
  }
  vivas = remanescentes							# atualiza a lista de árvores vivas com as árvores remanescentes

  points(n, sum(na.omit(p.vol)))				# adiciona no gráfico o saldo de estoque de madeira (vivas + ingresso - mortas)
  n =  n + 1									# evolui simulação para o próximo ano
  
} 
  
 