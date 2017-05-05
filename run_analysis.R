#load in the libraries we need
library(dplyr)
library(tidyr)
library(data.table)

tidyData<-function(rawY, rawX, subjectLabels, sourceName){
  
  n<-16 #fixed width of values in the X values file
  
  #split the values using a fixed width
  splitX<-lapply(rawX, 
                  function(x) as.numeric(substring(x,seq(1,nchar(x),n),seq(n,nchar(x),n)))
  ) 
  
  #convert the list of split values to a dataframe
  x<-data.frame(t(sapply(splitX,c)))
  
  #read in the activity labels
  activities<-data.frame(readLines("activity_labels.txt"))

  #split the column from "1 WALKING" to "1" and "WALKING" etc
  activities<-separate(data = activities, col = readLines..activity_labels.txt.., 
           into = c("idx", "ActivityName"), sep = " ")
  
  #turn the idx column name to a number
  activities<-activities %>% mutate(idx=as.numeric(idx))
  
  #get the list of feature names
  features<-readLines("features.txt")
  
  #replcae the spaces with underscores
  features<-lapply(features, function(x) {
                      gsub(" ", "_", x)
                  })
  #set the names of the columns of the X values to be the feature names
  colnames(x)<-features
  
  #join the Y and X values
  z<-cbind(as.numeric(rawY), x)
  
  #add a more descriptive name
  colnames(z)[1]<-"Activity"
  
  #add the subject labels
  z<-cbind(as.numeric(subjectLabels), z)
  colnames(z)[1]<-"SubjectLabel"
  
  #join on the activity labels
  z<-z %>% inner_join(activities, by = c("Activity"="idx"))
  
  #add on the source name so we know where the observation comes from
  z<-z %>% mutate(SourceName=sourceName)
  z
}

#place the working directory at the root of the file set extracted from the zip file

#get the training data
trainY<-readLines("train/y_train.txt")
trainX<-readLines("train/x_train.txt")
trainSubjectLabels<-readLines("train/subject_train.txt")

#perform the data tidying using the function above
trainSet<-tidyData(trainY, trainX,trainSubjectLabels, "Train")

#get the test data
testY<-readLines("test/y_test.txt")
testX<-readLines("test/x_test.txt")
testSubjectLabels<-readLines("test/subject_test.txt")

#perform the data tidying using the function above
testSet<-tidyData(testY, testX,testSubjectLabels, "Test")

#merge the tidy training and test data sets
allData<-rbind(trainSet, testSet)

#select only the columns that we want
colsOfInterest<-allData[,c(
  "ActivityName","SubjectLabel","SourceName",
  colnames(allData)[grep("std|mean", colnames(allData))])]

#remove the source name column that we added in, as we don't want to use that in the group by
dt<-data.table(colsOfInterest)
dt[,SourceName:=NULL]

#get the means of values grouped at various levels
groupedByActivityAndSubjectLabel<-dt[, lapply(.SD, mean), by=c("ActivityName","SubjectLabel")]

noSubjectLevels<-copy(dt)
noSubjectLevels<-noSubjectLevels[,SubjectLabel:=NULL]
groupedByActivity<-noSubjectLevels[, lapply(.SD, mean), by=c("ActivityName")]
groupedByActivity[,SubjectLabel:="AllSubjects"]

noActivityNames<-copy(dt)
noActivityNames<-noActivityNames[,ActivityName:=NULL]
groupedBySubjectLabel<-noActivityNames[, lapply(.SD, mean), by=c("SubjectLabel")]
groupedBySubjectLabel[,ActivityName:="AllActivities"]

#merge all the grouped values back together
tidyDataSet<-rbind(groupedByActivityAndSubjectLabel, groupedByActivity, groupedBySubjectLabel)

write.table(tidyDataSet, file="TidyDataSet")

#do some clean up
rm(allData, colsOfInterest, dt, testSet, trainSet, 
   testSubjectLabels, testX, testY, 
   trainSubjectLabels, trainX, trainY, 
   tidyData, tidyDataSet, groupedByActivity, groupedBySubjectLabel, groupedByActivityAndSubjectLabel,
   noActivityNames, noSubjectLevels)

#use the following snippet to read the file in if you want to view it in R

# data<-read.table("TidyDataSet", header = TRUE, check.names = FALSE)
# View(data)
