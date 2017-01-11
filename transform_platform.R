.libPaths("D:/R code")
install.packages(c("rgl", "car"))
library("rgl")

trans_plat = function(data1)
{

data2<-data1[1:4,1:3]
#add first foot
data2<-rbind(data2,c(data1[which(data1$pt2_X!='NaN'),4],data1[which(data1$pt2_X!='NaN'),5],data1[which(data1$pt2_X!='NaN'),6]))
#second foot
data2<-rbind(data2,c(data1[which(data1$pt3_X!='NaN'),7],data1[which(data1$pt3_X!='NaN'),8],data1[which(data1$pt3_X!='NaN'),9]))
#third foot
data2<-rbind(data2,c(data1[which(data1$pt4_X!='NaN'),10],data1[which(data1$pt4_X!='NaN'),11],data1[which(data1$pt4_X!='NaN'),12]))
#fourth
data2<-rbind(data2,c(data1[which(data1$pt5_X!='NaN'),13],data1[which(data1$pt5_X!='NaN'),14],data1[which(data1$pt5_X!='NaN'),15]))

#plot the data to have a look
plot3d(data2[,1],data2[,2],data2[,3], col=c("red","green","blue","grey","orange","orange","orange","orange"), size=20)


#transform data, to move axis to first point on forceplate. 
transformed_data1<-cbind(data2[,1]-data2[1,1],data2[,2]-data2[1,2],data2[,3]-data2[1,3])
tdata<-as.data.frame(transformed_data1)

plot3d(tdata[,1],tdata[,2],tdata[,3], col=c("red","green","blue","grey","orange","orange","orange","orange"), size=20)

tdata3<-tdata

#rotate about the x-axis
theta_x1<-atan(tdata3[4,3]/tdata3[4,2])#angle along pt1 - pt4 edge
theta_x2<-atan((tdata3[3,3]-tdata3[2,3])/(tdata3[3,2]-tdata3[2,2]))#angle along pt2 - pt3 edge
#get average angle
theta_x<-mean(c(theta_x1,theta_x2))
theta_x<--theta_x
#y' = y*cos q - z*sin q 
#z' = y*sin q + z*cos q 
#x' = x 

for (ii in 1:8) {
  yt<- tdata3[ii,2]*cos(theta_x) - tdata3[ii,3]*sin(theta_x)
  zt<- tdata3[ii,2]*sin(theta_x) + tdata3[ii,3]*cos(theta_x)
  tdata3<-rbind(tdata3,c(tdata3[ii,1],yt,zt))
}

plot3d(tdata3[,1],tdata3[,2],tdata3[,3], col=c("red","green","blue","grey","orange","orange","orange","orange"), size=20)



#rotate about the y-axis

theta_y1<-atan(tdata[2,3]/tdata[2,1])
theta_y2<-atan((tdata[3,3]-tdata[4,3])/(tdata[3,1]-tdata[4,1]))
theta_y<-mean(c(theta_y1,theta_y2))

#z' = z*cos q - x*sin q 
#x' = z*sin q + x*cos q 
#y' = y 

#trim the data set
tdata4<-tdata3[9:16,]

for (ii in 1:8) {
zt<- tdata4[ii,3]*cos(theta_y) - tdata4[ii,1]*sin(theta_y)
xt<- tdata4[ii,3]*sin(theta_y) + tdata4[ii,1]*cos(theta_y)
tdata4<-rbind(tdata4,c(xt,tdata4[ii,2],zt))
}

plot3d(tdata4[,1],tdata4[,2],tdata4[,3], col=c("red","green","blue","grey","orange","orange","orange","orange"), size=20)


tdata5<-tdata4[9:16,]

plot3d(tdata5[,1],tdata5[,2],tdata5[,3], col=c("red","green","blue","grey","orange","orange","orange","orange"), zlim=c(-0.1,1), size=20)

return(tdata5)

} 

#not run
#rotate about the z-axis
#theta_x<-atan(tdata3[4,3]/tdata3[4,2])
#theta_x<--theta_x
#y' = y*cos q - z*sin q 
#z' = y*sin q + z*cos q 
#x' = x 

#for (ii in 1:4) {
#  yt<- tdata3[ii,2]*cos(theta_x) - tdata3[ii,3]*sin(theta_x)
#  zt<- tdata3[ii,2]*sin(theta_x) + tdata3[ii,3]*cos(theta_x)
#  tdata3<-rbind(tdata3,c(tdata[ii,1],yt,zt))
#}