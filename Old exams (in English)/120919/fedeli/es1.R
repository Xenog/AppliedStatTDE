df <- read.table("sequoia.txt")

eu <- dist(df, method='euclidean')
ward <- hclust(eu, method='ward.D2')

plot(ward, labels = F, sub = "")
tree <- cutree(ward, k = 5)

plot(df, col = tree)

groups <- lapply (1 : 5, function (x) which(tree==x))
num <- lapply(groups,length)
means <- lapply(groups,mean)

# sempre meno alberi raggiungono altezza e diametro consistenti,
# che sono sinonimo dell'età, per via dei forti incendi che
# periodicamente accadono. Questi incendi sono così forti da 
# far cadere gli alberi troppo piccoli in quei momenti,
# lasciando dunque dei clusters ben separati?

pvalues <- rep(NA,length(groups))

for (i in 1:length(groups)){
  pvalues[i] <- shapiro.test(df[unlist(groups[i]),2])$p
}
# ok gaussian

k <- 10
alpha <- .1

IC.mean <- matrix (rep (0,k), nrow = k/2)
IC.var <- matrix (rep (0,k), nrow = k/2)

for (i in 1:k/2){
  x <- df[unlist(groups[i]),2]
  n <- length(x)
  m <- mean(x)
  s <- var(x)
  
  IC.mean[i,1] <- m - qt(1-alpha/(2*k), n-1)* sqrt(s/n)
  IC.mean[i,2] <-  m + qt(1-alpha/(2*k), n-1)* sqrt(s/n)
  
  IC.var[i,1] <- s * (n-1) / qchisq(1-alpha/(2*k), n-1)
  IC.var[i,2] <- s * (n-1) / qchisq(alpha/(2*k), n-1)
}

IC.mean
IC.var


