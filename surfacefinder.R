
setwd("D:/project files/quoll paper")
data1<-read.csv("Quoll_strides_averaged11.csv")

QFSD<-matrix(nrow = length(data1$QuollRun), ncol = 3)
QFSD[,1]<-as.character(data1$QuollRun)
xx=1
for (xx in 1:length(QFSD[,1])) {
  if (length(grep('angle', QFSD[xx,1], value = TRUE))==1){
    QFSD[xx,2]<-"angle"
  }
  if (length(grep('flat', QFSD[xx,1], value = TRUE))==1){
   QFSD[xx,2]<-"flat"
  }
  if (length(grep('pole', QFSD[xx,1], value = TRUE))==1){
   QFSD[xx,2]<-"pole"
  }
}
data3<-cbind(data1,QFSD)
#setwd("G:/Quoll gait paper")
write.csv(data3,"quoll_surf_11.csv")

data2<-read.csv("name_key_quoll.csv")
caliQ<-read.csv("cali_quoll.csv")

surf2 = data.frame(name=character(),num=integer())
#caliQ[which(caliQ[,1]==data2$calnum[ind[1]]),2]

ii=1
for (ii in 1:nrow(data3)){
  ind<-which(grepl(data3$QuollRun[ii],data2$fname)==TRUE)
  temp<-data.frame(name=data3$QuollRun[ii], num=caliQ[which(caliQ[,1]==data2$calnum[ind[1]]),2])
  surf2<-rbind(surf2,temp)
}

head(surf2)

data5<-cbind(data3,surf2)

setwd("G:/Quoll gait paper")
write.csv(data5,"quoll_surf_num_cali_11.csv")


