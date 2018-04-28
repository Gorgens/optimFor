# -*- coding: utf-8 -*-
"""
Created on Thu Dec 28 20:14:50 2017

@author: Gorgens, E. B.
"""
import numpy as np
import matplotlib.pyplot as plt

'''
Fórmulas da matemática financeira
'''

def frange(start, stop, step):
    i = start
    while i < stop:
        yield i
        i += step

def vp(Vn, i, n):
    return Vn / (1 + i)**n

def vf(V0, i, n):
    return V0 * (1 + i)**n

def serieFinita(a, i, n, presente = True, t = None):
    if presente:        
        if t == None:
            return (a*((1+i)**n)-1)/(i*(1+i)**n)
        else:
            return (a*((1+i)**(n*t)-1))/(((1+i)**t - 1)*(1+i)**(n*t))
    else:
        if t == None:
            return (a*((1+i)**n - 1))/(i)
        else:
            return a*(((1+i)**n*t - 1)/((1+i)**t -1))

def serieInfinita(a, i, t = None):
    if t == None:
        return a/i
    else:
        return a/((1+i)^t -1)


#print(valorPresente(100, 0.10, 0))
#print(valorPresente(100, 0.10, 1))
#print(valorPresente(100, 0.10, 2))
#print(valorPresente(100, 0.10, 3))

#print(valorFuturo(100, 0.10, 0))
#print(valorFuturo(100, 0.10, 1))
#print(valorFuturo(100, 0.10, 2))
#print(valorFuturo(100, 0.10, 3))

'''
Calcular valor presente ou futuro para fluxo de caixa

Exemplo de um projeto de 12 anos. Com as seguintes realizações anuais:
    
custo = [325,0,0,0,0,0,0,0,0,0,0,0,0]
receita = [0,0,0,0,0,0,0,0,80,80,80,80,960]

OBS: Os vetores de custo e receita devem possuir igual dimensão. Para anos que 
não ocorrerem realizações financeiras incluir no fluxo de caixa como 0.

TO DO:

    1. Incluir vetor de tempo como input das funções.
'''

def vpLista(lista, i):
    vpVector = []
    element = 0
    for l in lista:
        vpVector.append(vp(l, i, element))
        element += 1
    return np.sum(vpVector)

def vfLista(lista, i):
    vfVector = []
    element = len(lista)-1
    for l in lista:
        vfVector.append(vf(l, i, element))
        element -= 1
    return np.sum(vfVector)

#print(vpLista([100, 100, 100, 100, 100], 0.10))
#print(vpLista([200, 50, 50, 50, 1000], 0.10))
#print(vfLista([0,0,0,0,0,0,0,0,80,80,80,80,960], 0.10))

'''
Fórmulas de matemática financeira avaliação de projetos baseado em fluxos de 
caixa dos custos e das receitas.

TO DO:

    1. ...
'''

def vpl(custo, receita, i):
    r0 = vpLista(receita, i)
    c0 = vpLista(custo, i)
    return r0 - c0

#print(vpl([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960], 0.128995))

def sensibilidadeVpl(custo, receita, imin = 0.01, imax = 0.2, step = 0.01):
    i = []
    vpl = []
    for r in frange(imin, imax, step):
        r0 = vpLista(receita, r)
        c0 = vpLista(custo, r)
        i.append(r)
        vpl.append(r0 - c0)
    
    i = np.array(i)
    i = i * 100
    vpl = np.array(vpl)
    
    plt.plot(i, vpl)
    plt.axhline(y=0, color='black', linestyle='-')
    plt.xlabel('Taxa de juros')
    plt.ylabel('VPL')   
    return plt.show()

#print(sensibilidadeVpl([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960]))

def bc(custo, receita, i):
    r0 = vpLista(receita, i)
    c0 = vpLista(custo, i)
    return r0/c0

#print(bc([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960], 0.10))

def vet(custo, receita, i, t = None):
    if t == None:
        t = len(custo) - 1
    
    rlf = vfLista(receita, i) - vfLista(custo, i)
    return rlf / ((1+i)**t - 1)

#print(vet([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960], 0.10))
#print(vet([2800,2000,200,200,200,200,200,200], [0, 0, 0, 0, 0, 0, 0, 15750], 0.10))

def sensibilidadeVet(custo, receita, imin = 0.05, imax = 0.2, step = 0.01, t = None):
    if t == None:
        t = len(custo) - 1
        
    i = []
    vet = []
    for r in frange(imin, imax, step):
        rlf = vfLista(receita, r) - vfLista(custo, r)
        i.append(r)
        vet.append(rlf / ((1+r)**t - 1))
    
    i = np.array(i)
    i = i * 100
    vet = np.array(vet)
    
    plt.plot(i, vet)
    plt.axhline(y=0, color='black', linestyle='-')
    plt.xlabel('Taxa de juros')
    plt.ylabel('VET')   
    return plt.show()

#print(sensibilidadeVet([2800,2000,200,200,200,200,200,200], [0, 0, 0, 0, 0, 0, 0, 15750]))

def vpla(custo, receita, i, t = None):
    if t == None:
        t = len(custo) - 1

    return vpl(custo, receita, i) * (i * (1+i)**t) / ((1+i)**t - 1)

#print(vpla([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960], 0.1, 12))
#print(vpla([2800,2000,200,200,200,200,200,200], [0, 0, 0, 0, 0, 0, 0, 15750], 0.10))

def tir(custo, receita, iteracoes = 100):
    i = 1.0
    for r in range(1, iteracoes+1):
        i *= (1 - vpl(receita, custo, i) / vpLista(custo, i))
    return i

#print(tir([100,0,0,0], [0,60,60,60]))
#print(tir([325,0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,80,80,80,80,960]))

'''
Avaliação de rotação economicamente ótima

TO DO:

    1. ...
'''

def prod(beta, alpha, theta, t):
    return (beta * (1 - np.exp(- alpha * t)))**theta


def optVol(beta, alpha, theta, tmin = 3, tmax = 10):
    itc = None
    for t in range(tmin, tmax+1):
        l1 = np.exp(alpha*t) - 1
        l2 = alpha * theta * t
        if np.round(l1) == np.round(l2):
            itc = t
            return itc 
    return itc
#print(optVol(10.4, 0.25, 2.81))

def optEco(c0, p, i, beta1, alpha1, theta1, beta2 = None, alpha2 = None, theta2 = None, tmin = 3, tmax = 10):
    rot1 = 99
    rot2 = 99
    vet = 0
    if beta2 != None:
        for t1 in range(tmin, tmax + 1):
            for t2 in range(tmin, tmax + 1):
                v1 = vf(prod(beta1, alpha1, theta1, t1), i, t2)
                v2 = prod(beta2, alpha2, theta2, t2)
                cf = vf(c0, i, t1 + t2)
                vetnovo = (p*(v1+v2) - cf) / ((1+i)**(t1+t2) - 1)
                if vetnovo > vet:
                    vet = vetnovo
                    rot1 = t1
                    rot2 = t2
    else:
        for t1 in range(tmin, tmax + 1):
                v1 = prod(beta2, alpha2, theta2, t1)
                cf = vf(c0, i, t1)
                vetnovo = (p*(v1) - cf) / ((1+i)**(t1) - 1)
                if vetnovo > vet:
                    vet = vetnovo
                    rot1 = t1
                    rot2 = None
    return rot1, rot2, vet            

#print(optEco(1200, 12, 0.07, 10.4, 0.25, 2.81, 14.0, 0.24, 2.44))
    
    
