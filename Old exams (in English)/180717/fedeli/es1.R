df <- read.table("tourists.txt")

boxplot(df[,3:10])
# scale -> too much difference in variance
pca <- princomp(scale(df[,3:10]))

pca$sd^2/sum(pca$sd^2) # prop per direzione
pca$loadings # loadings

(pca$sdev)^2 # guardo prime tre per var per direzione 

# b

# usare più dei colori standard
op <- par(cex = 0.8)

plot(pca$scores[,1],pca$scores[,2], col = df[,1])
abline(h=0, v=0, lty=2, col='grey')

legend('topright',legend = levels(df[,1]), pch = 16,col = unique(df[,1]),bty='n')

# etc etc