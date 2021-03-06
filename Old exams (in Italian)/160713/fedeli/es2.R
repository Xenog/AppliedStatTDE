df <- read.table("fishing.txt")

dist.eucl <- dist(df, method = "euclidean")
hclust <- hclust(dist.eucl, method = "ward.D")
plot(hclust, labels = F, sub = "")
tree <- cutree(hclust, k = 2)

plot(df, col = tree)

i1 <- which(tree == 1)
i2 <- which(tree == 2)

length(i1)
length(i2)
colMeans(df[i1,])
colMeans(df[i2,])

D_1 = df[i1,]
D_2 = df[i2,]

mcshapiro.test(D_1)
mcshapiro.test(D_2)
# tutto squisitamente gaussiano


n1 <- dim(D_1)[1] 
n2 <- dim(D_2)[1] 
n <- n1 + n2
p  <- dim(D_1)[2] 

t1.mean <- sapply(D_1,mean)
t2.mean <- sapply(D_2,mean)
t1.cov  <-  cov(D_1)
t2.cov  <-  cov(D_2)

# le covarianze son simili (la struttura di correlazione è uguale)

# Posso davvero usare Spooled?

Sp      <- ((n1-1)*t1.cov + (n2-1)*t2.cov)/(n1+n2-2)

alpha   <- .05
delta.0 <- c(0,0,0)
Spinv   <- solve(Sp)

T2 <- n1*n2/(n1+n2) * (t1.mean-t2.mean-delta.0) %*% Spinv %*% (t1.mean-t2.mean-delta.0)

cfr.fisher <- (p*(n1+n2-2)/(n1+n2-1-p))*qf(1-alpha,p,n1+n2-1-p)
T2 < cfr.fisher 

P <- 1 - pf(T2/(p*(n1+n2-2)/(n1+n2-1-p)), p, n1+n2-1-p)
P  
# big evidence to reject sameness hypothesis 

k <- 3 

IC1 <- c(t1.mean[1]-t2.mean[1] - qt(1-alpha/(2*k), n-1) * sqrt(Sp[1,1]*(1/n1 + 1/n2)) ,t1.mean[1]-t2.mean[1] + qt(1-alpha/(2*k), n-1) * sqrt(Sp[1,1]*(1/n1 + 1/n2)))
IC1
IC2 <- c(t1.mean[2]-t2.mean[2] - qt(1-alpha/(2*k), n-1) * sqrt(Sp[2,2]*(1/n1 + 1/n2)) ,t1.mean[2]-t2.mean[2] + qt(1-alpha/(2*k), n-1) * sqrt(Sp[2,2]*(1/n1 + 1/n2)) )
IC2
IC3 <- c(t1.mean[3]-t2.mean[3] - qt(1-alpha/(2*k), n-1) * sqrt(Sp[3,3]*(1/n1 + 1/n2)) ,t1.mean[3]-t2.mean[3] + qt(1-alpha/(2*k), n-1) * sqrt(Sp[3,3]*(1/n1 + 1/n2)) )
IC3

# forte influenza per Orate e Cernie, leggera per Mormore