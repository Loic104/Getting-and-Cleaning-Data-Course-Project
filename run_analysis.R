library(dplyr)

##Get the test data
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")

## get the train data
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

##Merge train and test data together
X<-rbind(x_train,x_test)
Y<-rbind(y_train,y_test)
subject <-rbind(subject_train,subject_test)
Y<-rename(Y,Activities=V1)
subject<-rename(subject,subjects=V1)

##Assemble the subjects, X and Y data
data<-cbind(subject,Y,X)

##Free memory
x_test<-NULL
y_test<-NULL
subject_test<-NULL
x_train<-NULL
y_train<-NULL
subject_train<-NULL
X<-NULL
Y<-NULL
subject<-NULL


##get the correspondance between activity label and name
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
## renaming the labels
data<-mutate(data,Activities=activity_labels$V2[Activities])
activity_labels<-NULL

## Get the name of the variables
features<-read.table("UCI HAR Dataset/features.txt")
##Rename the columns
d<-data.frame(V1=1:2,V2=c("Subjects","Activities"))
features <-rbind(d,features)
names(data)<-features$V2
features<-NULL

##Keep only the means and standard deviation
for(x in names(data)){
  if (!grepl("mean()",x) && !grepl("std()",x) && !grepl("Activities",x) && !grepl("Subjects",x))
    {
      data[[x]]<- NULL
    }
}

##rename columns
for(x in names(data)){
  if(!grepl("Activities",x) && !grepl("Subjects",x)){
    var = ""
    if(grepl("meanFreq()",x)){
      var= "MeanFrequencyOf"
    }else if(grepl("mean()",x)){
      var="MeanOf"
    }else{
      var="StandardDeviationOf"
    }
    if(grepl("Body",x)){
      var = paste(var,"Body") 
    }else{
      var = paste(var,"Gravity")
    }
    if(grepl("Acc",x)){
      var = paste(var,"Acceleration") 
    }else{
      var = paste(var,"Gyrospic")
    }
    if(grepl("Jerk",x)){
      var = paste(var,"Jerk")
    }
    if(grepl("Mag",x)){
      var = paste(var,"Magnitude")
    }
    last=substr(x,nchar(x),nchar(x))
    if(last=="X" || last=="Y" || last=="Z"){
      var = paste(var,"In",last,"Direction")
    }
    if(substr(x,1,1)=="t"){
      var = paste(var,"InTemporalDomain")
    }else{
      var = paste(var,"InFrequencyDomain")
    }
    
    names(data)[names(data) == x]<-var
  }
  
  
}  


##Creating tiny data
data2<-aggregate(data,by=list(data$Subjects,data$Activities),FUN= mean,na.rm=TRUE)
data2$Subjects <-NULL
data2$Activities <-NULL
data2<-rename(data2,Subjects=Group.1,Activities = Group.2)


##export the table
write.table(data2,"export.txt",row.names=FALSE)
