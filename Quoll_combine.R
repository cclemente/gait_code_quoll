

setwd("D:/project files/quoll paper/Analyse Quoll Gait")#clemente computer
#setwd("H:/quoll raw data/Quoll/Analyse Quoll Gait")#josh usb
#setwd("D:/Quoll/Analyse Quoll Gait")#Josh Laptop

filenames <- (Sys.glob("*xypts.csv"))

cvalues2= matrix(nrow = 0, ncol = 17)
#colnames(cvalues2)<-c('QuollRun', 'Cycle','Duration','Plag','Flag','Hlag', 'DF','DFH','DFF','Speed','Gait','sdh','sdf')
colnames(cvalues2)<-c('QuollRun', 'Cycle','Duration','Plag','Flag','Hlag', 'DF','DFH','DFF','Speed','Gait','sdh','sdf','PlagM','FlagM','HlagM','GaitM')

strides_out = matrix(nrow = 0, ncol = 9)
colnames(strides_out)<-c("filename","Stride","Foot","FF" ,"ES","SubFF","DF","ES-FF","SubFF-FF")

#ii=14
#for (ii in 1:10){
for (ii in 1:length(filenames)){

filename<-filenames[ii]

strides<-DF(filename) 
stff_out<-stff(filename,strides)
file_name<-rep_len(filename, nrow(strides))
#add line of code which finds surface magically....
#surface=rep_len("flat",nrow(strides))

strides<-cbind(file_name,strides)

strides_out = rbind(strides_out,strides)

cvalues2 = rbind(cvalues2, stff_out)

}

#setwd("D:/project files/quoll paper")#clemente computer
setwd("H:/quoll raw data/Quoll/quoll code")#josh usb
#setwd("D:/Quoll/quoll code")#josh laptop
write.csv(cvalues2,"Quoll_strides_averaged11.csv")
write.csv(strides_out,"Quoll_steps_all11.csv")



