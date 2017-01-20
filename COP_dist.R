
setwd("D:/Quoll/quoll stuff/Platform&ForceStride")
setwd("D:/project files/quoll paper/Platform&ForceStride")
filenames <- (Sys.glob("*xyzpts.csv"))

.libPaths("D:/R code")
library("rgl")

data3out<-data.frame(name=NA,Fdist=NA,Hdist=NA,Pdist=NA,CopHLx=NA,CopHLy=NA,CopHRx=NA,CopHRy=NA,CopFLx=NA,CopFLy=NA,CopFRx=NA,CopFRy=NA)

for (ii in 1:length(filenames)){

data1<-read.csv(filenames[ii])
plat<-trans_plat(data1)
#plot3d(plat[,1],plat[,2],plat[,3], col=c("red","green","blue","grey","pink","lightblue","orange","orange"), zlim=c(-0.1,1), size=20)

#foot order = Hind left, hind right, fore left, fore right

Fdist=sqrt((plat[7,1]-plat[8,1])^2+(plat[7,2]-plat[8,2])^2+(plat[7,3]-plat[8,3])^2)
Hdist=sqrt((plat[5,1]-plat[6,1])^2+(plat[5,2]-plat[6,2])^2+(plat[5,3]-plat[6,3])^2)
Pdist1=sqrt((plat[5,1]-plat[7,1])^2+(plat[5,2]-plat[7,2])^2+(plat[5,3]-plat[7,3])^2)
Pdist2=sqrt((plat[6,1]-plat[8,1])^2+(plat[6,2]-plat[8,2])^2+(plat[6,3]-plat[8,3])^2)
Pdist=mean(c(Pdist1,Pdist2))

#plot(plat[,1],plat[,2], col=c("red","green","blue","grey","pink","lightblue","orange","orange"), pch=20, asp=1, cex=2)
#meanXPlat<-((mean(c(plat[2,1],plat[3,1]))) - (mean(c(plat[1,1],plat[4,1]))))
#meanYPlat<-((mean(c(plat[4,2],plat[3,2]))) - (mean(c(plat[1,2],plat[2,2]))))
#points(meanXPlat,meanXPlat)

centreX<-mean(c((plat[2,1]-plat[1,1])/2,(plat[3,1]-plat[4,1])/2))
centrey<-mean(c((plat[4,2]-plat[1,2])/2,(plat[3,2]-plat[2,2])/2))

points(centreX,centrey)

CopHLx<-plat[5,1]-centreX
CopHLy<-centrey - plat[5,2]
CopHRx<-plat[6,1]-centreX
CopHRy<-centrey - plat[6,2]
CopFLx<-plat[7,1]-centreX
CopFLy<-centrey - plat[7,2]
CopFRx<-plat[8,1]-centreX
CopFRy<-centrey - plat[8,2]

data2out<-data.frame(name=filenames[ii],Fdist=Fdist,Hdist=Hdist,Pdist=Pdist,CopHLx=CopHLx,CopHLy=CopHLy,CopHRx=CopHRx,CopHRy=CopHRy,CopFLx=CopFLx,CopFLy=CopFLy,CopFRx=CopFRx,CopFRy=CopFRy)
data3out<-rbind(data3out,data2out)

}

write.csv(data3out,'data3out.csv')




