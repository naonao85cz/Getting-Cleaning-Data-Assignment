## library the necessary packasges 
library(data.table)
library(dplyr)

## 1. Merges the training and the test sets to create one data set.
x_train <- fread("./train/X_train.txt")
x_test <- fread("./test/X_test.txt")
x_dataset <- rbind(x_train,x_test)
y_train <- fread("./train/y_train.txt")
y_test <- fread("./test/y_test.txt")
y_dataset <- rbind(y_train,y_test)
subject_train <- fread("./train/subject_train.txt")
subject_test <- fread("./test/subject_test.txt")
subject_dataset <- rbind(subject_train,subject_test)
dataset <- cbind(x_dataset,y_dataset,subject_dataset)

## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement.
features <- fread("./features.txt")
xnames <- features[[2]]
xmean <- grep("mean()",xnames) ##meanFreq() is included?
"mean()" %in% xnames
xdropmean <- grep("meanFreq()",xnames)
xremain <- xmean[!(xmean %in% xdropmean)]
xsd <- grep("std()",xnames)
xindex<-sort(c(xremain,xsd))
x_set <- select(x_dataset, ncol=xindex)

## 3.Uses descriptive activity names to name the activities in the data set
activity_labels <- fread("./activity_labels.txt")
names(activity_labels) <- c("labelnum", "activitylabel")
names(y_dataset) <- "labelnum"
yjoin <- left_join(y_dataset,activity_labels,by="labelnum")
dataset <- cbind(x_set,yjoin[,2],subject_dataset)

## 4.Appropriately labels the data set with descriptive variable names.
names(features) <- c("featurenum", "featurename")
features<-select(features,featurename)
xnames <- features[xindex][[1]]
names(dataset) <- c(xnames,"activitylabel","subject")
names(dataset)<- tolower(names(dataset))

## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
m <- ncol(dataset)
activity <- dataset$activitylabel
subject <- dataset$subject
gp <- paste(activity,subject)
dataset <- cbind(dataset,gp)
splitdata <- split(dataset,gp)
meandata <- t(sapply(splitdata,function(x) colMeans(x[,1:(m-3)])))
splitnames <- strsplit(rownames(meandata)," ")
n <- nrow(meandata)
activityname<- vector()
for(i in 1:n){
        activityname[i] <- splitnames[[i]][1]
}
subjectname <- vector()
for(i in 1:n){
        subjectname[i] <- splitnames[[i]][2]
}
dataset2 <- cbind(activityname,subjectname,meandata)

## use write.table() with row.name=FALSE, save dataset2 into a text in the working directory
write.table(dataset2,file="./dataset2.txt",row.name=FALSE,col.name=TRUE,sep="\t",quote=FALSE)
## check the output data : output <- fread("./dataset2.txt")
