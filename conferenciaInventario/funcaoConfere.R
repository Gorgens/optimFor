confereInv = function(inventario, areaplot, probConf, nparcelas, mediaDesvio, desvPadDesvio){
    # sorteia parcelas que serão conferidas pelo órgão
    parcSorteadas = sample(seq(nparcelas), probConf*nparcelas)
    conferencia = subset(inventario, 
                         parcela %in% parcSorteadas)
    `%notin%` = Negate(`%in%`)
    naoConferencia = subset(inventario, 
                            parcela %notin% parcSorteadas)
    
    # simula dados conferidos a partir de media e desvio desejado
    desvio = rnorm(dim(conferencia)[1], mediaDesvio, desvPadDesvio)           # gera desvio aleatório
    conferencia$dapConferencia = conferencia$dap + desvio
    conferencia$volConferencia = VFCC(conferencia$dapConferencia)
    
    # calcula diferença média estre original e conferido
    # temp1 = conferencia %>% 
    #   group_by(parcela) %>%
    #   summarise(meanDap = mean(dap), meanDapCon = mean(dapConferencia))
    # difMedia = mean(temp1$meanDap - temp1$meanDapCon)
    # temp2 = conferencia %>% 
    #   group_by(parcela) %>%
    #   summarise(sdDap = sd(dap), sdDapCon = sd(dapConferencia))
    # difDesvio = mean(temp2$sdDap - temp2$sdDapCon)
    
    # junta parcelas conferidas com parcelas não conferidas
    temp0 = conferencia %>% mutate(vol = volConferencia,
                                  dap = dapConferencia) %>%
      select(parcela, arvore, dap, vol, centroClasse)
    inventarioComConferido = rbind(naoConferencia, temp0)
    
    # cria base de inventário com erro observado na conferência
    inventarioPropagado = inventario
    inventarioPropagado$dap = inventarioPropagado$dap + rnorm(dim(inventarioPropagado)[1], m, d)
    inventarioPropagado$vol = VFCC(inventarioPropagado$dap)
    
    # processa inventarios
    totalizacaoInv = plot_summarise(inventario, "parcela", plot_area = areaplot, dbh = "dap", vwb = 'vol')
    erroInv = sprs(totalizacaoInv, 'vol_ha', 'plot_area', total_area = 1)[12,2]
    
    totalizacaoInvCom = plot_summarise(inventarioComConferido, "parcela", plot_area = areaplot, dbh = "dap", vwb = 'vol')
    erroInvConf = sprs(totalizacaoInvCom, 'vol_ha', 'plot_area', total_area = 1)[12,2]
    
    totalizacaoInvProp = plot_summarise(inventarioPropagado, "parcela", plot_area = areaplot, dbh = "dap", vwb = 'vol')
    erroInvProp = sprs(totalizacaoInvProp, 'vol_ha', 'plot_area', total_area = 1)[12,2]
    
    diffErro = erroInv[i] - erroInvConf[i]
    
    # realiza teste t entre original e conferido
    conf_t = as.numeric(t.test(conferencia$dap, 
                                    conferencia$dapConferencia, 
                                    paired = TRUE)[3])
    
    # realiza teste KS entre original e conferido
    conf_ks = as.numeric(ks.test(conferencia$dap, 
                                      conferencia$dapConferencia)[2])
    
    # totaliza parcela para volume
    # realiza teste graybill entre original e conferido
    volPlot = conferencia %>% 
      group_by(parcela) %>%
      summarise(volOrig = sum(vol)*(areaplot/10000), volConf = sum(volConferencia)*(areaplot/10000))
    conf_graybill = as.numeric(graybill_f(volPlot, 'volOrig', 'volConf')[3])
    
    # realiza teste t entre inventario original e inventario propagado
    inv_t = as.numeric(t.test(inventario$dap, 
                                 inventarioPropagado$dap, 
                                 paired = TRUE)[3])
    
    # realiza teste KS entre inventario original e inventario propagado
    inv_ks = as.numeric(ks.test(inventario$dap, 
                                   inventarioPropagado$dap)[2])
    
    # totaliza parcela para volume
    # realiza teste graybill entre inventario original e inventario propagado
    volOriginal = inventario %>% 
      group_by(parcela) %>%
      summarise(volOrig = sum(vol)*(areaplot/10000))
    volPropagado = inventarioPropagado %>% 
      group_by(parcela) %>%
      summarise(volOrig = sum(vol)*(areaplot/10000))
    temp = merge(volOriginal, volPropagado, by = 'parcela')
    inv_graybill = as.numeric(graybill_f(temp, 'volOrig.x', 'volOrig.y')[3])
}