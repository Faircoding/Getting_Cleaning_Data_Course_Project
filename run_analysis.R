##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Jairo Calderon
## 2016-04-11

# runAnalysis.R File Description:

# This script does the following: 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#creates a second independent tidy data set with the average of each variable for each activity and each subject.

##########################################################################################################


# 1. Merge the training and the test sets to create one data set.

#set working directory to the location where the files will be unzipped
setwd("C:\\Users\\jairo.calderon\\Documents\\Coursera\\week4\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset");

# Read data from files
features     = read.table('./features.txt',header=FALSE);#561
activityLabels = read.table('./activity_labels.txt',header=FALSE);
subjectTrain = read.table('./train/subject_train.txt',header=FALSE);
xTrain       = read.table('./train/x_train.txt',header=FALSE);
yTrain       = read.table('./train/y_train.txt',header=FALSE);
subjectTest = read.table('./test/subject_test.txt',header=FALSE);
xTest       = read.table('./test/x_test.txt',header=FALSE);
yTest       = read.table('./test/y_test.txt',header=FALSE);

# Create training merge between data tables train
trainingData = cbind(yTrain,subjectTrain,xTrain);#563

# Create the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);#563

# Combine training and test data to create a final data set
bindData = rbind(trainingData,testData);#563

# Set column names
colnames(bindData)  = c('activityId','subjectId', features[,2]);

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

features[,2] <- as.character(features[,2])
featuresToDisplay <- grep(".*mean.*|.*std.*", features[,2])
featuresToDisplay.names <- features[featuresWanted,2]
featuresToDisplay.names = gsub('-mean', 'Mean', featuresToDisplay.names)
featuresToDisplay.names = gsub('-std', 'Std', featuresToDisplay.names)
featuresToDisplay.names <- gsub('[-()]', '', featuresToDisplay.names)
dataWanted <- bindData [featuresToDisplay]

# 3. Use descriptive activity names to name the activities in the data set

colnames(activityLabels)  = c('activityId','activityType');
dataWithNames = merge(activityLabels,dataWanted, by='activityId',all.x=TRUE);

# 4. Appropriately labels the data set with descriptive variable names.

names(dataWithNames) <- gsub("Acc", "Accelerator", names(dataWithNames))
names(dataWithNames) <- gsub("Mag", "Magnitude", names(dataWithNames))
names(dataWithNames) <- gsub("Gyro", "Gyroscope", names(dataWithNames))
names(dataWithNames) <- gsub("^t", "time", names(dataWithNames))
names(dataWithNames) <- gsub("^f", "frequency", names(dataWithNames))

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(data.table)
tidyDt <- data.table(dataWithNames)
tidyData <- tidyDt[, lapply(.SD, mean), by = 'subjectId,activityId']
write.table(tidyData, file = "TidyFile.txt", row.names = FALSE)