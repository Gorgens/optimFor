require(MASS)

# Dados reais
df = read.csv("Kelly Cauaxi.csv")
df = df[df$dap2012>=10,]
hist(df$dap2012, breaks = 20)

coefExp = fitdistr(df$dap2012,"exponential")
coefExp
hist(rexp(600, rate=0.07),breaks=20, xlim=c(0, 200), xlab= "DAP", ylab="", main = "")

coefGamma = fitdistr(df$dap2012,"gamma")
coefGamma
hist(rgamma(600, shape = 1.1, rate=0.08), xlim=c(10, 200), xlab= "DAP", ylab="", main = "")

# Dados reais, processados
dap = c(rep(15, 335), rep(25, 125), rep(35, 47), rep(45, 23), rep(55, 13), rep(65, 5), rep(75, 3))
hist(dap)

coefExp = fitdistr(dap,"exponential")
coefExp
hist(rexp(600, rate=0.07),breaks=20, xlim=c(0, 200), xlab= "DAP", ylab="", main = "")

coefGamma = fitdistr(dap,"gamma")
coefGamma
hist(rgamma(600, shape = 1.1, rate=0.08), xlim=c(10, 200), xlab= "DAP", ylab="", main = "")