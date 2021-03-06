library(car)
df <- read.table("pigeons.txt")
head(df)
load("mcshapiro.test.Rdata")

x11()
par(mfrow = c(1,2))
matplot(t(df[,c(1,3)]), type = 'l')
matplot(t(df[,c(2,4)]), type = 'l')
dev.off()

D <- data.frame(weight = df[,1]-df[,3], wing = df[,2]-df[,4])

mcshapiro.test(D)
# siamo di fronte ad una normale bivariata pvalue = 0.5536
# voglio verificare che la sua media non sia (0,0) per poter asserire che vi siano differenze
plot(D)

mu0      <- c(0, 0)
x.mean   <- colMeans(D)
x.cov    <- cov(d)
x.invcov <- solve(x.cov)
n <- dim(D)[1]
p <- 2

x.T2       <- n * (x.mean-mu0) %*% x.invcov %*% (x.mean-mu0) 
Pb <- 1-pf(x.T2*(n-p)/(p*(n-1)), p, n-p)
Pb

# the pval is null so we can accept the alternative hypothesis that males and females differ

k <- 4
alpha <- 0.1

ICmean <- cbind(inf=x.mean - sqrt(diag(x.cov)/n) * qt(1 - alpha/(2*k), n-1),
                center= x.mean,
                sup= x.mean + sqrt(diag(x.cov)/n) * qt(1 - alpha/(2*k), n-1))

ICvar <- cbind(inf=diag(x.cov)*(n-1) / qchisq(1 - alpha/(2*k), n-1),
               center=diag(x.cov),
               sup=diag(x.cov)*(n-1) / qchisq(alpha/(2*k), n-1))

ICmean
#           inf    center    sup
# weight 83.56402 83.57701 83.59001
# wing   14.75797 14.76731 14.77666
ICvar
#     inf        center       sup
# 0.003400293 0.004402619 0.005905514
# 0.001759474 0.002278125 0.003055794

# gli intervalli di bonferroni non intersecano lo zero e specialmente quelli per la media sono ben lontani
# dal farmi pensare che le differenze tra maschi e femmine siano nulle 

wingspan <- df[,2] - 1.2*df[,4]

t.test(wingspan, alternative = "greater", mu = 0)
# One Sample t-test
# 
# data:  wingspan
# t = 4.49, df = 133, p-value = 7.643e-06
# alternative hypothesis: true mean is greater than 0
# 95 percent confidence interval:
#   1.122918      Inf
# sample estimates:
#   mean of x 
# 1.779313 

# accetto l'ipotesi alternativa, cio� che la differenza sia maggiore di 0, quindi i maschi hanno effettivamente
# l'apertura alare pi� del 20% pi� grande delle loro femmine



