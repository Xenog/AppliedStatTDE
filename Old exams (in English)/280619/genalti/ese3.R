library(car)
rm(list = ls())
df <- read.table('airport.txt')
head(df)

mod1 <- lm(duration ~ distance + distance:time.of.the.day + time.of.the.day, data = df)
summary(mod1)

coefs <- coef(mod1)
#   (Intercept)                    distance               time.of.the.day16-20 
#   17.2283433                     1.1574155                   -16.1704029 
# time.of.the.day6-10     distance:time.of.the.day16-20  distance:time.of.the.day6-10 
#   -3.8908612                      0.2930864                     0.5829262 

shapiro.test(mod1$residuals) # p-value = 0.0728 al 95% gaussiani

par(mfrow = c(2,2))
plot(mod1) #ok

vif(mod1)
#GVIF Df GVIF^(1/(2*Df))
# distance                     3.853418  1        1.963012
# time.of.the.day          26999.120216  2       12.818506
# distance:time.of.the.day 26827.942691  2       12.798140   sembra che time of the day generi collinearit�

linearHypothesis(mod1, rbind(c(0,0,1,0,0,0),
                             c(0,0,0,1,0,0),
                             c(0,0,0,0,1,0),
                             c(0,0,0,0,0,1)), c(0,0,0,0)) # pvalue < 2.2e-16 sembra che il giorno in qualche modo influisca

linearHypothesis(mod1, rbind(c(0,1,0,0,0,0),
                             c(0,0,0,0,1,0),
                             c(0,0,0,0,0,1)), c(0,0,0)) # pvalue < 2.2e-16 anche la distanza

linearHypothesis(mod1, rbind(c(0,0,1,0,0,0),
                             c(0,0,0,1,0,0)), c(0,0)) # pvalue = 0.466 il giorno della settimana in s� non sembra influenzare

# dal summary(mod1) e dalle collinearit� capisco comunque che il modello va ridotto

mod2 <- lm(duration ~ distance + distance:time.of.the.day, data = df)
summary(mod2) # piccolo miglioramento nell'R^2 e nella significativit� delle variabili

mod3 <- lm(duration ~ distance, data = df)
summary(mod3) # troppo, l'R^2 crolla

# scelgo mod2

shapiro.test(mod2$residuals) #pval= 0.0747 al pelo ma ok
vif(mod2) #ok
par(mfrow = c(2,2))
plot(mod2) #ok

coefs <- coef(mod2)

newdat <- data.frame(distance = 57, time.of.the.day = '6-10')
guess <- predict(mod2, newdat, interval = 'confidence', level = 0.99)
#    fit      lwr      upr
# 112.4174 110.4296 114.4052   in quella fascia oraria e con quella distanza ho questo IC al 99% per la durata

# essendo l'upper bound di 115 minuti circa, per essere l� al 99% alle 9:30 dovr� partire al pi� con lo shuttle
# delle 7:30




