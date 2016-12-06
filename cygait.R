setwd("H:/quoll raw data")
setwd("I:/Quoll gait paper")
data1<-read.csv("Quoll_strides_averaged9.csv")
GaitCY<-matrix(nrow = length(data1[,1]), ncol = 1)
data1<-cbind(data1, GaitCY)
data1<-as.matrix(data1[,c("QuollRun","Cycle","Duration","Plag","Flag","Hlag","DF","DFH","DFF","Speed", "Gait", "GaitCY", "sdh", "sdf")])

hh=1
for (hh in 1:length(data1[,1])){
  
  if (as.numeric(data1[hh,5])>=0.45 & as.numeric(data1[hh,5])<=0.55 & as.numeric(data1[hh,6])>=0.45 & as.numeric(data1[hh,6])<=0.55){#Flag and Hlag is between 0.45 and 0.55
      
      data1[hh,12]<-"Symmetrical"
    
    } else{
      if (as.numeric(data1[hh,5])<=0.1 & as.numeric(data1[hh,6])<=0.1){#if hlag and flag are less than 10%
        data1[hh,12]<-"Bound"
      } else if (as.numeric(data1[hh,5])>0.1 & as.numeric(data1[hh,6])<=0.1){#if hlag is less than 10% but flag is more
        data1[hh,12]<-"Half Bound"
      } else if (as.numeric(data1[hh,5])>0.1 & as.numeric(data1[hh,6])>0.1 & as.numeric(data1[hh,7])<0.5){
        data1[hh,12]<-"Gallop"
      } else if (as.numeric(data1[hh,5])>0.1 & as.numeric(data1[hh,6])>0.1 & as.numeric(data1[hh,7])>0.5){
        data1[hh,12]<-"Canter"
      }

    }
}

write.csv(data1,"Quoll_strides_averaged10.csv")
