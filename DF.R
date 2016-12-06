

DF = function(filename)
{

data5 <- read.csv(file=filename, header=TRUE, sep=",")
#footfall sequence footLH
           #test1<-!is.nan(diff(data5[,1]))
            #test2<-!is.nan(diff(data5$pt2_X))
            #test3<-!is.nan(diff(data5$pt3_X))
            #test4<-!is.nan(diff(data5$pt4_X))

ff=0 #what is this? 
strides<-matrix(NA,nrow=0,ncol=8)
colnames(strides)<-c('Stride','Foot','FF','ES','SubFF', 'DF','ES-FF','SubFF-FF')
#ee=2

if (ncol(data5)==10) {
  row_list<-c(1,3,5,7)
} 

if (ncol(data5)==20) {
  row_list<-c(1,5,9,13)
}

#ee = 3
for (ee in 1:4){
test1<-!is.nan(diff(data5[,row_list[ee]]))
  
#footfall end
ind<-which(test1==TRUE)
ind2<-ind[which(diff(ind)>1)]

#footfall start
         ind3<-which(test1==FALSE)
         ind4<-ind3[which(diff(ind3)>1)]
         
         #incase there is only one stride
         if (sum(ind2)==0) {ind2<-ind4+length(ind)}
         
         #incase the foot is in contact at the start of the film
         if (ind2[1]<ind4[1]){ind2<-ind2[-1]}
              
               #kk=1
               
         for (kk in 1:length(ind2)){
           
                strides = rbind(strides,0:0)
                strides[(kk+ff),1]<-kk
                strides[(kk+ff),2]<-ee
                strides[(kk+ff),3]<-ind4[kk]+2
                strides[(kk+ff),4]<-(ind2[kk]+2)
                strides[(kk+ff),5]<-(ind4[kk+1]+2)
                strides[(kk+ff),7]<-(strides[(kk+ff),4] - strides[(kk+ff),3]+1)
                strides[(kk+ff),8]<-(strides[(kk+ff),5] - strides[(kk+ff),3])
              
          }
                ff=(ff+length(ind2))#does this indicate stride?
                
          }
          


if(nrow(strides)>4){

strides<-strides[order(strides[,1]),]
#pull out which rows in strides is less than the ffirst FF to touch. 
test<-which(strides[,3] < min(strides[which(strides[,2]==c(3) | strides[,2]==c(4) & strides[,1]==1),3],na.rm=T))

if (length(test)>0){
str_num<-strides[1:(nrow(strides)-length(test)),1]
strides2<-as.matrix(strides[-test,])
strides2[,1]<-str_num
strides<-strides2
}
}


#calculating duty factor
#cc=1
for (cc in 1:length(strides[,1])){
  
  strides[cc,6]<- ((strides[(cc),7])/( strides[(cc),8]))
}
               

#test3<-list(Hstrides<-Hstrides,strides<-strides)              
return(strides)
            
}            