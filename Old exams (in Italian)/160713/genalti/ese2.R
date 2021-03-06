library(rgl)
rm(list = ls())
load('mcshapiro.test.RData')
df <- read.table('fishing.txt')

open3d()
plot3d(df[,1],df[,2],df[,3])

df.e<- dist(df, method='euclidean') # distance matrix

## single linkage

df.es <- hclust(df.e, method='ward.D') # clustering gerarchico con ward linkage

x11() # dendrogramma
plot(df.es, main='euclidean-single', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(df.es, k=2)

help(cutree)
cluster.es <- cutree(df.es, k=2) 
cluster.es 

dim1 <- length(cluster.es[which(cluster.es == 1)]) # cluster di dimensione 52
dim2 <- length(cluster.es[which(cluster.es == 2)]) # cluster di dimensione 38

centroids <- apply (df, 2, function (x) tapply (x, cluster.es, mean))
centroids
#   Orate  Mormore   Cernie
# 70.21423 30.46904 89.07423
# 77.40026 30.15105 66.65026

open3d()
plot3d(df[,1],df[,2],df[,3], col= cluster.es) #ottimo

d.1 <- df[cluster.es == 1,]
d.2 <- df[cluster.es == 2,]

mcshapiro.test(d.1)
mcshapiro.test(d.2)
# sono entrambi normali multivariati

p  <- 3
n1 <- dim(d.1)[1]
n2 <- dim(d.2)[1]
alpha <- 0.05

mean1 <- sapply(d.1,mean)
mean2 <- sapply(d.2,mean)
cov1  <-  cov(d.1)
cov2  <-  cov(d.2)
Sp      <- ((n1-1)*cov1 + (n2-1)*cov2)/(n1+n2-2)

delta.0 <- c(0,0,0)
Spinv   <- solve(Sp)

T2 <- n1*n2/(n1+n2) * (mean1-mean2-delta.0) %*% Spinv %*% (mean1-mean2-delta.0)

cfr.fisher <- (p*(n1+n2-2)/(n1+n2-1-p))*qf(1-alpha,p,n1+n2-1-p)

pvalue <- 1 - pf(T2/(p*(n1+n2-2)/(n1+n2-1-p)), p, n1+n2-1-p)
pvalue

# metodo alternativo con media tra i tre pesci

p <- 1
M1 <- (d.1[,1]+d.1[,2]+d.1[,3])/3
M2 <- (d.2[,1]+d.2[,2]+d.2[,3])/3
mean1 <- mean(M1)
mean2 <- mean(M2)
cov1  <-  var(M1)
cov2  <-  var(M2)
Sp      <- ((n1-1)*cov1 + (n2-1)*cov2)/(n1+n2-2)

delta.0 <- 0
Spinv   <- solve(Sp)

T2 <- n1*n2/(n1+n2) * (mean1-mean2-delta.0) %*% Spinv %*% (mean1-mean2-delta.0)

cfr.fisher <- (p*(n1+n2-2)/(n1+n2-1-p))*qf(1-alpha,p,n1+n2-1-p)

pvalue <- 1 - pf(T2/(p*(n1+n2-2)/(n1+n2-1-p)), p, n1+n2-1-p)
pvalue


# accetto l'ipotesi alternativa che vi sia differenza nel pescato

dm <- (mean1-mean2)
A  <- rbind(c(1,0,0), c(0,1,0), c(0,0,1))
k  <- dim(A)[1]

A.s2 <- diag(A%*%Sp%*%t(A))
A.dm <- A%*%(mean1-mean2)

Bonf <- cbind(inf=A.dm - qt(1-(alpha/(2*k)), n1+n2-2) * sqrt( A.s2*(1/n1+1/n2) ), 
              center=A.dm, 
              sup=A.dm + qt(1-(alpha/(2*k)), n1+n2-2) * sqrt( A.s2*(1/n1+1/n2) ))

#         Bonferroni IC
# -9.364178 -7.1860324 -5.007887
# -1.430365  0.3179858  2.066337
# 20.681684 22.4239676 24.166251

# il terzo gruppo � sicuramente quello pi� influenzato dalla giornata, anche il primo ha significativa differenza
# mentre nel secondo non si pu� concludere che ci sia differenza


