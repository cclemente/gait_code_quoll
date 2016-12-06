
setwd("D:/project files/quoll paper")
setwd("I:/Quoll gait paper")
data5<-read.csv("Quoll_complete_data_ver11.csv")
plot(Speed~SpC,data=data5)
#test

cols<-c("red","blue","green","pink","grey")
boxplot(SpC~surf, data=data5)
boxplot(SpC~Gait+surf,col=cols, data=data5)

summary(fit<-aov(SpC~Gait+surf, data=data5))
TukeyHSD(fit)

library(lattice)
xyplot(Plag~DF,data=data5,groups=surf)

boxplot(DF~surf, data=data5)
#duty factor is highest on the pole - reflects slow speed

boxplot(Duration~X2, data=data5)
#but duration is also low on the pole??

xyplot(SpC~DF,data5,group=X2, auto.key = T)

#swing time is important??? 

xyplot(Plag~DF,data5,pch=20,cex=4,group=surf, auto.key = T)
xyplot(Flag~SpC,data5,pch=20,cex=4,group=surf, auto.key = T, ylim=c(-0.3,1))#let this be +vs / -ve??
xyplot(Hlag~DF,data5,pch=20,cex=4,group=surf, auto.key = T)# which is left vs right lead?? 


#stride distance?
xyplot(Duration~SpC,data5,pch=20,cex=4,group=surf, auto.key = T)

boxplot(SpC~Gait, data5)
summary(fit<-aov(SpC~Gait+Error(QuollRun), data=data5))# significant effect - but not convinving! 
TukeyHSD(fit)


boxplot(HlagM~surf, data5)


xyplot(Hlag~SpC,data5,pch=20,cex=4,group=surf, auto.key = T)

plot(HlagM~SpC,pch=20,cex=4,col='blue',data5, ylim=c(-0.5,1))
points(data5$SpC,data5$FlagM, pch=20,cex=4,col='red')
points(data5$SpC,data5$PlagM, pch=20,cex=4,col='green')
plot(Hlag~SpC,data5)
lines(x,y2,col="green")