

setwd("D:/Quoll gait paper/Platform&ForceStride")
filenames <- (Sys.glob("*xyzpts.csv"))

data1<-read.csv(filenames[1])

.libPaths("D:/R code")
library("rgl")

test<-trans_plat(data1)

meanXPlat<-((mean(c(test[2,1],test[3,1]))) - (mean(c(test[1,1],test[4,1]))))
meanYPlat<-((mean(c(test[4,2],test[3,2]))) - (mean(c(test[1,2],test[2,2]))))

#need to calculate distance in X and Y of each foot from the centre of the force plate. 

