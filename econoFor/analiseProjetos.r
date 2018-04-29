vpl = function(
  receita = NA,
  custo = NA,
  i = 0.10
){
  #length(receita) == length(custo) # Conferência
  horizonte = seq(0, length(receita) - 1, 1)
  
  VPR = sum(receita / (1 + i)^horizonte)
  VPC = sum(custo / (1 + i)^horizonte)
  
  return(VPR - VPC)
}

# Conferência
# print(vpl(c(0, 0, 0, 0, 0, 0, 0, 0, 80, 80, 80, 80, 960), 
#           c(325, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) # Resutlado esperado: 111.02

vet = function(
  receita = NA,
  custo = NA,
  i = 0.10
){
  #length(receita) == length(custo) # Conferência
  horizonte = seq(length(receita) - 1, 0, -1)
  
  VFR = sum(receita * (1 + i)^horizonte)
  VFC = sum(custo * (1 + i)^horizonte)
  
  
  return((VFR - VFC)/((1+i)^(length(horizonte)-1)-1))
}

# Conferência
# print(vet(c(0, 0, 0, 0, 0, 0, 0, 0, 80, 80, 80, 80, 960), 
#           c(325, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) # Resutlado esperado: 111.02