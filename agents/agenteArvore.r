require(R6)														# ativa pacote para programação orientada a objeto


tree = R6Class("tree",											# cria objeto árvore
	public = list(												# inicia lista de parâmetros e métodos
		dap = NULL, 											# cria atributo DAP
		live = NULL, 											# cria flag para identificar vivas
		trackLife = NULL, 										# cria atributo para contar de vida das árvores
		dead = NULL,											# cria flag para identificar ano em que a árvore morreu 
		initialize = function(dap = NA, 						# inicia método para criação do objeto, com a parâmetro DAP recebendo valor NA
							  live = 1, 						# inicia flag como viva
							  trackLife = 1, 					# inicia contagem de tempo como 1
							  dead = NA){						# inicia identificador da morte como NA
			self$dap = dap										# atribui o valor dap ao atributo dap
			self$live = live									# atribui o valor live à flag live
			self$dead = dead									# atribui o valor dead à flag dead
			self$trackLife = trackLife							# atribui o valor tracklife ao atributo tracklife
		},
		growthDap = function(binCoef = 0.8649, 
							 gammaCoef = 0.5311){				# cria método para crescer o diametro
			if(runif(1, 0, 1) <= 0.02){							# calcula a probabilidade do objeto árvore morrer 
				self$live = 0									# se morrer, flag live assume valor 0
				self$dead = self$trackLife						# se morrer, flag dead assumo valor armazenado em trackLife
			} 
			if(self$live == 1){									# condicional para árvore que permenecem vivas
				self$dap = self$dap + 
								rbinom(1, 
									   size = 1, 
									   prob = binCoef) * 
								rgamma(1, 
									   shape = gammaCoef)		# aplica crescimento baseado numa probabilidade binomial de crescer e distribuição gamma para incremento diametrico anual
				self$trackLife = self$trackLife + 1				# adiciona um ano no atributo trackLife
			}
		},		
		vol = function(b0 = -0.068854, b1 = 0.000841){			# cria método para obter o volume da árvore
			return(b0 + b1 * self$dap^2)						# crescimento baseado numa formula V = f(DAp^2)
		}
	)
)		


