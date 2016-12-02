

setwd("I:/Quoll gait paper")
data5<-read.csv("quoll_surf_num_cali2.csv")
plot(Speed~SpC,data=data5)
#test

cols<-c("red","blue","green","pink")
boxplot(SpC~X2, data=data5)
boxplot(SpC~GaitCY+X2,col=cols, data=data5)

summary(fit<-aov(SpC~Gait+X2, data=data5))
TukeyHSD(fit)

library(lattice)
xyplot(Plag~DF,data=data5,groups=X2)

boxplot(DF~X2, data=data5)
#duty factor is highest on the pole - reflects slow speed

boxplot(Duration~X2, data=data5)
#but duration is also low on the pole??

xyplot(SpC~DF,data5,group=X2, auto.key = T)

#swing time is important??? 

xyplot(Plag~DF,data5,group=X2, auto.key = T)
xyplot(Flag~DF,data5,group=X2, auto.key = T)#let this be +vs / -ve??
xyplot(Hlag~DF,data5,group=X2, auto.key = T)# which is left vs right lead?? 


#stride distance?
xyplot(sdf~DF,data5,group=X2, auto.key = T)

boxplot(SpC~Gait, data5)
summary(fit<-aov(SpC~Gait+Error(QuollRun), data=data5))# significant effect - but not convinving! 
TukeyHSD(fit)


boxplot(DF~Gait, data5)


