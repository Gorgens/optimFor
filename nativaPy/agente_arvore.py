#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from scipy.stats import binom
from scipy.stats import gamma
import math as m


# Modelo do agente árvore

# In[ ]:


class arvore:

    def __init__(self, sp, grupoEcologico, dap):
        self.sp = sp
        self.ge = grupoEcologico
        self.st = 'viva'
        self.dap = dap
        self.s = 3.14 * dap**2 / 40000
        # modelo de altura: https://acta.inpa.gov.br/fasciculos/35-3/BODY/v35n3a07.html
        self.alt = (((dap**2)/(-8.8722 + 3.4217 * dap + 0.1382 * dap**2))**2)+1.3
        self.cc = (dap//10 * 10) + 10/2
        self.vol = -0.09712 + 0.013697 * dap + 0.000838 * dap**2

    def evoluir(self):
      if self.st == 'viva':
        # define probabilidade de morrer
        # pMorrer = 0.041
        if self.ge == 'Pioneer':
          pMorrer = m.exp(-3.20606 + 0.21794)/(1+m.exp(-3.20606 + 0.21794))
        elif self.ge == 'LightDemanding':
          pMorrer = m.exp(-3.20606 + 0.30018)/(1+m.exp(-3.20606 + 0.30018))
        elif self.ge == 'Intermediate':
          pMorrer = m.exp(-3.20606 + -0.16983)/(1+m.exp(-3.20606 + -0.16983))
        elif self.ge == 'ShadeTolerant':
          pMorrer = m.exp(-3.20606 + -0.00247)/(1+m.exp(-3.20606 + -0.00247))
        elif self.ge == 'Emergent':
          pMorrer = m.exp(-3.20606 + -0.29289)/(1+m.exp(-3.20606 + -0.29289))
        else:
          pMorrer = 0.041
        # verifica se árvore permanece viva ou morre
        if binom.rvs(n = 1, p = pMorrer, size = 1)[0] == 1:
          self.dap = None
          self.st = 'morta'
        # se permanece viva, evolui
        else:
          # define probabilidade de crescer
          if self.ge == 'Pioneer':
            pCrescer = m.exp(1.49856 + 0.72065)/(1+m.exp(1.49856 + 0.72065))
          elif self.ge == 'LightDemanding':
            pCrescer = m.exp(1.49856 + -0.1768)/(1+m.exp(1.49856 + -0.1768))
          elif self.ge == 'Intermediate':
            pCrescer = m.exp(1.49856 + 0.12109)/(1+m.exp(1.49856 + 0.12109))
          elif self.ge == 'ShadeTolerant':
            pCrescer = m.exp(1.49856 + -0.06119)/(1+m.exp(1.49856 + -0.06119))
          elif self.ge == 'Emergent':
            pCrescer = m.exp(1.49856 + -0.38159)/(1+m.exp(1.49856 + -0.38159))
          else:
            pCrescer = 0.8174
          # se cresce gera valor para IDA e evolui
          if binom.rvs(n = 1, p = pCrescer, size = 1)[0] == 1:
            if self.cc == 15.0:
              aGamma = m.exp(-0.44316 + -0.28469)
            elif self.cc == 25.0:
              aGamma = m.exp(-0.44316 + -0.15414)
            elif self.cc == 35.0:
              aGamma = m.exp(-0.44316 + -0.04404)
            elif self.cc == 45.0:
              aGamma = m.exp(-0.44316 + 0.27027)
            elif self.cc == 55.0:
              aGamma = m.exp(-0.44316 + 0.30840)
            elif self.cc == 65.0:
              aGamma = m.exp(-0.44316 + 0.68567)
            elif self.cc == 75.0:
              aGamma = m.exp(-0.44316 + 0.83409)
            elif self.cc == 85.0:
              aGamma = m.exp(-0.44316 + 0.88638)
            elif self.cc >= 95.0:
              aGamma = m.exp(-0.44316 + 1.35671)
            else:
              aGamma = 0.4978
            self.dap = self.dap + gamma.rvs(aGamma, loc=0, scale=1, size=1)[0]
            self.cc = (self.dap//10 * 10) + 10/2
            self.vol = -0.09712 + 0.013697 * self.dap + 0.000838 * self.dap**2
            self.alt = (((dap**2)/(-8.8722 + 3.4217 * dap + 0.1382 * dap**2))**2)+1.3


# Criando um agente árvore como exemplo

# In[ ]:


# tree1 = arvore(None, 'Pioneer', 23.3)


# Evoluindo um agente como exemplo

# In[ ]:


# print(tree1.dap, tree1.cc, tree1.vol, tree1.st)
# tree1.evoluir()
# print(tree1.dap, tree1.cc, tree1.vol, tree1.st)

