setwd("H:/quoll raw data")
setwd("I:/Quoll gait paper")
setwd("D:/project files/quoll paper")

data1<-read.csv("quoll_surf_num_cali_11.csv")

GaitCY<-matrix(nrow = length(data1[,1]), ncol = 2)

#data1<-as.matrix(data1[,c("QuollRun","Cycle","Duration","Plag","Flag","Hlag","DF","DFH","DFF","Speed", "Gait", "GaitCY", "sdh", "sdf")])

flag<-as.numeric(data1[,5])
Hlag<-as.numeric(data1[,6])
df<-as.numeric(data1[,7])

hh=1
for (hh in 1:length(data1[,1])){
  
  if (!is.na(flag[hh]) && !is.na(Hlag[hh]) ){
  if (flag[hh]>=0.45 & flag[hh]<=0.55 & Hlag[hh]>=0.45 & Hlag[hh]<=0.55){#Flag and Hlag is between 0.45 and 0.55
      
      data1[hh,12]<-"Symmetrical"
    
    } else{
      if (flag[hh]<=0.1 & Hlag[hh]<=0.1){#if hlag and flag are less than 10%
        GaitCY[hh,1]<-"Bound"
      } else if (flag[hh]>0.1 & Hlag[hh]<=0.1){#if hlag is less than 10% but flag is more
        GaitCY[hh,1]<-"Half Bound"
      } else if (flag[hh]>0.1 & Hlag[hh]>0.1 & df[hh]<0.5){
        GaitCY[hh,1]<-"Gallop"
      } else if (flag[hh]>0.1 & Hlag[hh]>0.1 & df[hh]>0.5){
        GaitCY[hh,1]<-"Canter"
      }

    }
  }else{
    GaitCY[hh,1]<-"Unknown"
  }
}

#for flagM and hlagM 

flag<-as.numeric(data1[,15])
Hlag<-as.numeric(data1[,16])

for (hh in 1:length(data1[,1])){
  
  if (!is.na(flag[hh]) && !is.na(Hlag[hh]) ){
    if (flag[hh]>=0.45 & flag[hh]<=0.55 & Hlag[hh]>=0.45 & Hlag[hh]<=0.55){#Flag and Hlag is between 0.45 and 0.55
      
      data1[hh,12]<-"Symmetrical"
      
    } else{
      if (flag[hh]<=0.1 & Hlag[hh]<=0.1){#if hlag and flag are less than 10%
        GaitCY[hh,2]<-"Bound"
      } else if (flag[hh]>0.1 & Hlag[hh]<=0.1){#if hlag is less than 10% but flag is more
        GaitCY[hh,2]<-"Half Bound"
      } else if (flag[hh]>0.1 & Hlag[hh]>0.1 & df[hh]<0.5){
        GaitCY[hh,2]<-"Gallop"
      } else if (flag[hh]>0.1 & Hlag[hh]>0.1 & df[hh]>0.5){
        GaitCY[hh,2]<-"Canter"
      }
      
    }
  }else{
    GaitCY[hh,2]<-"Unknown"
  }
}






  
  
data1<-cbind(data1, GaitCY)
head(data1)

write.csv(data1,"Quoll_complete_data_ver11.csv")
