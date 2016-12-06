
stff = function(filename, strides)

  {
data5 <- read.csv(file=filename, header=TRUE, sep=",")
cvalues= matrix(nrow = 0, ncol = 17)
colnames(cvalues)<-c('QuollRun', 'Cycle','Duration','Plag','Flag','Hlag', 'DF','DFH','DFF','Speed','Gait','sdh','sdf','PlagM','FlagM','HlagM','GaitM')
#stridecyc = matrix(nrow = 0, ncol = 8)

#find temporal stride variables
mm=2#stride number
nn=1
pp=1
#ff2=0

loopcount=max(strides[,1])
if (length(which(strides[,1]==loopcount))!=4){loopcount=loopcount-1}
if (loopcount==0){loopcount=1}

for (mm in 1:loopcount){
  
  stridecyc = matrix(nrow = 0, ncol = 8)
  cvalues = rbind(cvalues,0:0) #makes a matrix with all zeros
  
  #extract stride event
  for (nn in 1:length(strides[,1])){
    
    if (strides[nn,1]==mm){
      strind<-strides[nn,]
      stridecyc=rbind(stridecyc,strind)
     }# only add the strides for which we have all four feet
  }
    
    #selected file
    cvalues[mm,1] <- filename
    #selected stride
    cvalues[mm,2] <- mm
    #calculate Cycle Duration#
    stridecyc<-stridecyc[order(stridecyc[,2]),]
    DurationC<-as.vector(stridecyc[,3])
    DurationF<-as.vector(stridecyc[,3:4])
    DurationD<-as.vector(rowMeans(stridecyc[,3:4], na.rm=T))
    cvalues[mm,3] <- mean(stridecyc[,8],na.rm=T)#stride duration in frames
    
    
    #temporal Variables#
    cvalues[mm,4] <- abs(DurationC[3]-DurationC[1]) / as.numeric(cvalues[mm,3])#plag
    cvalues[mm,5] <- abs(DurationC[3]-DurationC[4]) / as.numeric(cvalues[mm,3])#flag
    cvalues[mm,6] <- (DurationC[1]-DurationC[2]) / (as.numeric(cvalues[mm,3]))#hlag
    
    cvalues[mm,14] <- abs(DurationD[3]-DurationD[1]) / as.numeric(cvalues[mm,3])#plagM
    cvalues[mm,15] <- abs(DurationD[3]-DurationD[4]) / as.numeric(cvalues[mm,3])#flagM
    cvalues[mm,16] <- (DurationD[1]-DurationD[2]) / (as.numeric(cvalues[mm,3]))#hlagM
    
    if(!is.na(as.numeric(cvalues[mm,5]))&&as.numeric(cvalues[mm,5])>=0.5){cvalues[mm,5]<-1-as.numeric(cvalues[mm,5])}#flag logic if > 0.5
    if(!is.na(as.numeric(cvalues[mm,6]))&&as.numeric(cvalues[mm,6])>=0.5){cvalues[mm,6]<-1-as.numeric(cvalues[mm,6])}#hlag logic if > 0.5   

    if(!is.na(as.numeric(cvalues[mm,15]))&&as.numeric(cvalues[mm,15])>=0.5){cvalues[mm,15]<-1-as.numeric(cvalues[mm,15])}#flag logic if > 0.5
    if(!is.na(as.numeric(cvalues[mm,16]))&&as.numeric(cvalues[mm,16])>=0.5){cvalues[mm,16]<-1-as.numeric(cvalues[mm,16])}#hlag logic if > 0.5
    
    #DutyFactor#
    cvalues[mm,7] <-mean(stridecyc[complete.cases(stridecyc[,6]),6])#gets average duty factor
    cvalues[mm,8]<-mean(stridecyc[which(stridecyc[,2]==1 | stridecyc[,2]==2),6][complete.cases(stridecyc[which(stridecyc[,2]==1 | stridecyc[,2]==2),6])])#gets average duty factor for hind legs
    cvalues[mm,9]<-mean(stridecyc[which(stridecyc[,2]==3 | stridecyc[,2]==4),6][complete.cases(stridecyc[which(stridecyc[,2]==3 | stridecyc[,2]==4),6])])#gets average duty factor for fore legs
    
    #stride length 
    if (ncol(data5)==10) {
      row_list<-c(1,3,5,7)
    } else {
      row_list<-c(1,5,9,13)
    }
    
    #foot 1 (hind left)
    foot1x<-data5[stridecyc[which(stridecyc[,2]==1),3],row_list[1]] - data5[stridecyc[which(stridecyc[,2]==1),5],row_list[1]]
    foot1y<-data5[stridecyc[which(stridecyc[,2]==1),3],row_list[1]+1] - data5[stridecyc[which(stridecyc[,2]==1),5],row_list[1]+1]
    distF1<-sqrt(foot1x^2 + foot1y^2)
    
    #foot 2 (hind right)
    foot2x<-data5[stridecyc[which(stridecyc[,2]==2),3],row_list[2]] - data5[stridecyc[which(stridecyc[,2]==2),5],row_list[2]]
    foot2y<-data5[stridecyc[which(stridecyc[,2]==2),3],row_list[2]+1] - data5[stridecyc[which(stridecyc[,2]==2),5],row_list[2]+1]
    distF2<-sqrt(foot2x^2 + foot2y^2)
    
    #foot 3 (fore left)
    foot3x<-data5[stridecyc[which(stridecyc[,2]==3),3],row_list[3]] - data5[stridecyc[which(stridecyc[,2]==3),5],row_list[3]]
    foot3y<-data5[stridecyc[which(stridecyc[,2]==3),3],row_list[3]+1] - data5[stridecyc[which(stridecyc[,2]==3),5],row_list[3]+1]
    distF3<-sqrt(foot3x^2 + foot3y^2)
    
    #foot 4 (fore right)
    foot4x<-data5[stridecyc[which(stridecyc[,2]==4),3],row_list[4]] - data5[stridecyc[which(stridecyc[,2]==4),5],row_list[4]]
    foot4y<-data5[stridecyc[which(stridecyc[,2]==4),3],row_list[4]+1] - data5[stridecyc[which(stridecyc[,2]==4),5],row_list[4]+1]
    distF4<-sqrt(foot4x^2 + foot4y^2)
    
    cvalues[mm,12]<-mean(c(distF1,distF2)[complete.cases(c(distF1,distF2))])
    cvalues[mm,13]<-mean(c(distF3,distF4)[complete.cases(c(distF3,distF4))])
    
    #Speed#
    
    #which column is speed? 
    if (ncol(data5)==10) {
      sp_col<-9
    } else {
      sp_col<-17
    }
    
    diffx <- diff(data5[min(DurationF):max(DurationF),sp_col])
    diffy <- diff(data5[min(DurationF):max(DurationF),sp_col+1])
    dist_moved_per_frame<-sqrt((diffx^2)+(diffy^2))# in pixels
    Speed_vect<-dist_moved_per_frame*250 # in pixel/ sec
    mean_speed <- mean(Speed_vect,na.rm=TRUE)
    #test<-(mean_speed/1.401)/1000 #m/s
    
    cvalues[mm,10] <- mean_speed
    
    ##Gait Patterns##
    
    if (!is.na(cvalues[mm,4]) && !is.na(cvalues[mm,5]) && !is.na(cvalues[mm,6])){
    
    if (cvalues[mm,5]<=0.55 & cvalues[mm,5]>=0.45 & cvalues[mm,6]<=0.55 & cvalues[mm,6]>=0.45) {
      if (cvalues[mm,4]>=0.95){
        cvalues[mm,11]<-"Pace"
      } else if(cvalues[mm,4]<=0.94999999 & cvalues[mm,4]>=0.55){
        cvalues[mm,11]<-"Lateral Walk"
      } else if (cvalues[mm,4]<=0.549999 & cvalues[mm,4]>=0.45){
        cvalues[mm,11]<-"Trot"
      } else if (cvalues[mm,4] <=0.449999){
        cvalues[mm,11]<-"Diagonal Walk"
      }
      
    } else  if(cvalues[mm,5]<=0.55 & cvalues[mm,5]>=0.05){
      if (cvalues[mm,6]<=0.5 & cvalues[mm,6]>0.05){
        cvalues[mm,11]<-"Transverse Gallop"
      } else if(cvalues[mm,6]<0 & cvalues[mm,4]>=0.02){
        cvalues[mm,11]<-"Rotary Gallop"
      } else if(cvalues[mm,6]<=0.05 & cvalues[mm,4]>=0.02){
        cvalues[mm,11]<-"Half Bound"
      }
    } else if(cvalues[mm,5]<0.05){
      if (cvalues[mm,4]>=0.05){
        cvalues[mm,11]<-"Bound"
      } else {
        cvalues[mm,11]<-"pronk"
      }
      
    } else{
      cvalues[mm,11]<-"Unknown"
    }
    } else{
      cvalues[mm,11]<-"Unknown"
    } 
    #FF2
    
    ##GaitM Patterns##
    
    if (!is.na(cvalues[mm,14]) && !is.na(cvalues[mm,15]) && !is.na(cvalues[mm,16])){
    
    if (cvalues[mm,15]<=0.55 & cvalues[mm,15]>=0.45 & cvalues[mm,16]<=0.55 & cvalues[mm,16]>=0.45) {
      if (cvalues[mm,14]>=0.95){
        cvalues[mm,17]<-"Pace"
      } else if(cvalues[mm,14]<=0.94999999 & cvalues[mm,14]>=0.55){
        cvalues[mm,17]<-"Lateral Walk"
      } else if (cvalues[mm,14]<=0.549999 & cvalues[mm,14]>=0.45){
        cvalues[mm,17]<-"Trot"
      } else if (cvalues[mm,14] <=0.449999){
        cvalues[mm,17]<-"Diagonal Walk"
      }
      
    } else  if(cvalues[mm,15]<=0.55 & cvalues[mm,15]>=0.05){
      if (cvalues[mm,16]<=0.5 & cvalues[mm,16]>0.05){
        cvalues[mm,17]<-"Transverse Gallop"
      } else if(cvalues[mm,16]<0 & cvalues[mm,14]>=0.02){
        cvalues[mm,17]<-"Rotary Gallop"
      } else if(cvalues[mm,16]<=0.05 & cvalues[mm,14]>=0.02){
        cvalues[mm,17]<-"Half Bound"
      }
    } else if(cvalues[mm,15]<0.05){
      if (cvalues[mm,14]>=0.05){
        cvalues[mm,17]<-"Bound"
      } else {
        cvalues[mm,17]<-"pronk"
      }
      
    } else{
      cvalues[mm,17]<-"Unknown"
    }
    }else{
      cvalues[mm,17]<-"Unknown"
    } 
    
}

return(cvalues)

}
