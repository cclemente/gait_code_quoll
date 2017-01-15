
setwd("D:/Quoll/quoll stuff/Platform&ForceStride")
setwd("D:/Quoll gait paper/Platform&ForceStride")
filenames <- (Sys.glob("*xyzpts.csv"))

data1<-read.csv(filenames[1])

.libPaths("D:/R code")
library("rgl")

test<-trans_plat(data1)

meanXPlat<-((mean(c(test[2,1],test[3,1]))) - (mean(c(test[1,1],test[4,1]))))
meanYPlat<-((mean(c(test[4,2],test[3,2]))) - (mean(c(test[1,2],test[2,2]))))
meanZPlat<-(mean(c(test[1,3],test[2,3],test[3,3],test[4,3])))

#need to calculate distance in X and Y of each foot from the centre of the force plate. 
#centrepoint<-c(meanXPlat,meanYPlat,meanZPlat)


copdist<-as.data.frame(matrix(nrow = 4, ncol = 3,))
colnames(copdist)<-c("X","Y","Hypotenuse")
p=1
for(pp in 1:4){
  copdist[pp,1]<-(test[pp+4,1]-meanXPlat)
  copdist[pp,2]<-(test[pp+4,2]-meanYPlat)
  copdist[pp,3]<- sqrt(copdist[pp,1]^2+copdist[pp,2]^2)
}

