alternativaProd = function(
  talhao = NA,
  area = NA,
  idadeRot = NA,
  rotacao = NA,
  ITCr1 = 7,
  ITCr2 = 7,
  icR1 = NA,
  icR2 = NA,
  modeloR1 = NA,
  modeloR2 = NA,
  anoInicio = 2018,
  anoFim  = 2047){
  i = 1
  coeficiente = 0
  producao = 0
  hoje = anoInicio
  while(hoje <= anoFim){
    #print(hoje)
    #print(idadeRot)
    if(rotacao == 1){
      idadecheck = idadeRot
      if(idadecheck == icR1){
        coeficiente = coeficiente + (modeloR1[1] * (1 - exp(modeloR1[2] * idadeRot)))^modeloR1[3]
        producao[i] = (modeloR1[1] * (1 - exp(modeloR1[2] * idadeRot)))^modeloR1[3]
        rotacao = 2
        idadeRot = 1
      } else {
        idadeRot = idadeRot + 1
        producao[i] = 0
      }
    } else {
      idadecheck = idadeRot
      if(idadecheck == icR2){
        coeficiente = coeficiente + (modeloR2[1] * (1 - exp(modeloR2[2] * idadeRot)))^modeloR2[3]
        producao[i] = (modeloR2[1] * (1 - exp(modeloR2[2] * idadeRot)))^modeloR2[3]
        rotacao = 1
        idadeRot = 1
      } else {
        idadeRot = idadeRot + 1
        producao[i] = 0
      }
    }
    hoje = hoje + 1
    i = i + 1
    #print(producao)
  }
  return(list(variavel = paste("T", talhao, "_", icR1, icR2, sep=""), coefFO = round(coeficiente, 2), horizonteProd = round(producao, 2)))
}

# Verificar função
# print(alternativa(talhao = 101, area = 19.44, idade = 6, rotacao = 2, icR1 = 7, icR2 = 7, modeloR1 = c(10.40, -0.25, 2.81), modeloR2 = c(14, -0.24, 2.44)))
# print(alternativa(talhao = 101, area = 19.44, idade = 6, rotacao = 2, icR1 = 6, icR2 = 7, modeloR1 = c(10.40, -0.25, 2.81), modeloR2 = c(14, -0.24, 2.44)))
# print(alternativa(talhao = 401, area = 15.03, idade = 5, rotacao = 1, icR1 = 8, icR2 = 7, modeloR1 = c(16, -0.18, 2.20), modeloR2 = c(15.13, -0.20, 2.16)))
