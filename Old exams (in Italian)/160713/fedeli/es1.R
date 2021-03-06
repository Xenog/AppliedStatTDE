trulli <- read.table("trulli.txt")

shapiro.test(trulli[,1])
shapiro.test(trulli[,2])
shapiro.test(trulli[,3])
#mcshapiro.test(trulli)

# they are ~ normal

mu = c(5,2,2.5)

n <- dim(trulli)[1]  
p <- dim(trulli)[2]

D.mean   <- sapply(trulli,mean)
D.cov    <- cov(trulli)
D.invcov <- solve(D.cov)

alpha   <- .05

D.T2 <- n * (D.mean-mu) %*% D.invcov %*% (D.mean-mu)
D.T2

cfr.fisher <- ((n-1)*p/(n-p))*qf(1-alpha,p,n-p)
cfr.fisher

D.T2 < cfr.fisher # FALSE: we reject H0 at level 5%

# we compute the p-value
P <- 1-pf(D.T2*(n-p)/(p*(n-1)), p, n-p)
P

# p value molto basso -> rifiuto ipotesi h0

IC.T2.1 <- c( D.mean[1]-sqrt(cfr.fisher*D.cov[1,1]/n) , D.mean[1], D.mean[1]+sqrt(cfr.fisher*D.cov[1,1]/n) )
IC.T2.2  <- c( D.mean[2]-sqrt(cfr.fisher*D.cov[2,2]/n) , D.mean[2], D.mean[2]+sqrt(cfr.fisher*D.cov[2,2]/n) )
IC.T2.3  <- c( D.mean[3]-sqrt(cfr.fisher*D.cov[3,3]/n) , D.mean[3], D.mean[3]+sqrt(cfr.fisher*D.cov[3,3]/n) )

IC.T2.1
IC.T2.2
IC.T2.3

# si, va cambiata per altezza 2 soprattutto
trulli$C <- trulli[,1]*pi
D.mean <- colMeans(trulli)
D.cov <- var(trulli)
D.invcov <- solve(D.cov)

n <- dim(trulli)[1]
p <- dim(trulli)[2]

cfr.fisher <- ((n-1)*p/(n-p))*qf(1-alpha,p,n-p)


IC.T2.1 <- c( D.mean[1]-sqrt(cfr.fisher*D.cov[1,1]/n) , D.mean[1], D.mean[1]+sqrt(cfr.fisher*D.cov[1,1]/n) )
IC.T2.2  <- c( D.mean[2]-sqrt(cfr.fisher*D.cov[2,2]/n) , D.mean[2], D.mean[2]+sqrt(cfr.fisher*D.cov[2,2]/n) )
IC.T2.3  <- c( D.mean[3]-sqrt(cfr.fisher*D.cov[3,3]/n) , D.mean[3], D.mean[3]+sqrt(cfr.fisher*D.cov[3,3]/n) )
IC.T2.4 <- c( D.mean[4]-sqrt(cfr.fisher*D.cov[4,4]/n) , D.mean[4], D.mean[4]+sqrt(cfr.fisher*D.cov[4,4]/n) )

IC.T2.1
IC.T2.2
IC.T2.3
IC.T2.4
