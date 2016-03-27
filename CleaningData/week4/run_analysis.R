library(dplyr)
library(reshape2)
library(data.table)

initAnalysis <- function() {
    oldWorkingDirectory <- getwd()
    newWorkingDirectory <- "~/work/datasciencecoursera/CleaningData/week4/Dataset/"
    
    #Set new working directory
    setwd(newWorkingDirectory)
    
    oldWorkingDirectory
}

deinitAnalysis <- function(workingDirectory) {
    #Restore old working directory
    setwd(workingDirectory)
}

loadData <- function(fileName) {
    data <- read.table(fileName, header = F)
    data 
}

prepareTidyData <- function() {
    print("Initializing working directory...")
    oldWorkingDirectory <- initAnalysis()
    
    print("Loading and preparing activities...")
    activities <- loadData("activity_labels.txt")
    
    #Appropriately label the data set with descriptive variable names.
    colnames(activities) <- c("activityid", "activityname")

    activities$activityname <- tolower(activities$activityname)
    activities$activityname <- gsub("_", "", activities$activityname)

    print("Loading and preparing features")
    features <- loadData("features.txt")
    
    #Taking second column with column names for samples
    featureHeaders <- features[, 2]
    
    rm(features)
    
    print("Loading and preparing test data...")
    
    testXdata <- loadData("test/X_test.txt")
    testYdata <- loadData("test/y_test.txt")
    testSubjectData <- loadData("test/subject_test.txt")
    
    print("Loading and preparing traing data...")
    trainXdata <- loadData("train/X_train.txt")
    trainYdata <- loadData("train/y_train.txt")
    trainSubjectData <- loadData("train/subject_train.txt")
    
    print("Merging test and train data sets...")
    #Merge test and train data sets
    xData <- rbind(testXdata, trainXdata)
    yData <- rbind(testYdata, trainYdata)
    subjectData <- rbind(testSubjectData, trainSubjectData)
    
    rm(testXdata)
    rm(testYdata)
    rm(trainXdata)
    rm(trainYdata)
    
    colnames(xData) <- featureHeaders
    colnames(yData) <- c("activity")
    colnames(subjectData) <- c("subject")
    
    print("Extracting mean and std measurements...")
    #Extract only the measurements on the mean and standard deviation for each measurement.
    xDataColumnNames <- names(xData)
    tidyData <- xData[, grepl("mean()", xDataColumnNames) | grepl("std()", xDataColumnNames)]
    
    rm(xData)
    rm(xDataColumnNames)
    
    print("Pretifying column names...")
    #Appropriately label the data set with descriptive variable names.
    tidyDataColumnNames <- names(tidyData)
    
    tidyDataColumnNames <- gsub("mean", "MeanValue", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("std", "StandardDeviation", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("tBody", "timeBody", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("tGravity", "timeGravity", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("fBody", "frequencyBody", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("Acc", "Acceleration", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("Mag", "Magnitude", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("-", "", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("\\(\\)", "", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("Freq", "Frequency", tidyDataColumnNames)
    tidyDataColumnNames <- gsub("BodyBody", "", tidyDataColumnNames)
    
    colnames(tidyData) <- tidyDataColumnNames

    rm(tidyDataColumnNames)

    print("Adding activity and subject data into tidy data set...")
    #Clip all data pieces before merging because merge causes rows reordering
    #Give descriptive activity names in the data set
    tidyData$activity <-yData$activity
    tidyData$subject  <-subjectData$subject
    
    print("Merging tidy data set with activities...")
    tidyData <- merge(tidyData, activities, by.x = "activity", by.y = "activityid", all.x = TRUE, all.y = FALSE)
    
    print("Removing extra columns...")
    #Filter one extra field ("activityId")
    tidyData <- tidyData[, 2:ncol(tidyData)]
    tidyData <- rename(tidyData, activity = activityname)
    
    rm(yData)
    
    print("Aggregating tidy data set...")
    #Prepare all columns except "activity" and "subject"
    endColumn <- ncol(tidyData) - 2
    tidyDataSummary <- aggregate(tidyData[, 1:endColumn], list(activity = tidyData$activity, subject = tidyData$subject), mean)

    print("Saving tidy data and tidy data summary...")
    write.table(tidyData, file = "tidyData.txt", row.name=FALSE)
    write.table(tidyDataSummary, file = "tidyDataSummary.txt", row.name=FALSE)
    
    rm(tidyData)
    rm(tidyDataSummary)
    
    deinitAnalysis(oldWorkingDirectory)
    
    rm(list = ls())
    
    print("All done!")
}