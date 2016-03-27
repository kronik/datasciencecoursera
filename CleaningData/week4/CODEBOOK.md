#Course Project: tidy data codebook
##Version 1.0
###Getting and Cleaning Data course.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data for the project was downloaded from:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The values in original data set come from the accelerometer and gyroscope 3-axial raw signals. The acceleration signal was then separated into body and gravity acceleration signals. Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. 

NOTE: No unit of measures is reported. All features were normalized and bounded within -1,1.

#Data transformation

There is only one script called run_analysis.R that transform the data. The libraries dplyr, data.table and reshape3 are required to run and is loaded at the beginning of the script.

#In general our scope of work looks like following:

 1. Merge the training and the test sets to create one data set.
 2. Extract only the measurements on the mean and standard deviation for each measurement.
 3. Use descriptive activity names to name the activities in the data set.
 4. Appropriately label the data set with descriptive variable names.
 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
 
##Loading data. 

We're going to use generic function to load data set into the data.table:

```R
loadData <- function(fileName) {
    data <- read.table(fileName, header = F)
    data 
}
``` 

##In order to process, cleanup and reshape our original data sets we need to take a look on data itself

```R
activities <- loadData("activity_labels.txt")
features <- loadData("features.txt")

testXdata <- loadData("test/X_test.txt")
testYdata <- loadData("test/y_test.txt")
testSubjectData <- loadData("test/subject_test.txt")
    
trainXdata <- loadData("train/X_train.txt")
trainYdata <- loadData("train/y_train.txt")
trainSubjectData <- loadData("train/subject_train.txt")
``` 

Let's check dimensions of data sets which we need to glue together:

```R
> dim(testXdata)
[1] 2947  561
> dim(trainXdata)
[1] 7352  561

> dim(testYdata)
[1] 2947    1
> dim(trainYdata)
[1] 7352    1

> dim(testSubjectData)
[1] 2947    1
> dim(trainSubjectData)
[1] 7352    1

> dim(features)
[1] 561   2
``` 

Luckily we see that number of columns in pairs testXdata vs trainXdata , testYdata vs trainYdata and testSubjectData vs trainSubjectData match each other. Moreover number of experiments in each data set also matches each other. So that means we can combine (append) them without extra data transformations:

```R
xData <- rbind(testXdata, trainXdata)
yData <- rbind(testYdata, trainYdata)
subjectData <- rbind(testSubjectData, trainSubjectData)
``` 

Note: here rbind operation doesn't introduce rows reordering (likewise merge operation).

In features data set entire second column contains meaningful column names for test and train data sets. So let's extract it and use for our xData set:

```R
featureHeaders <- features[, 2]
colnames(xData) <- featureHeaders
``` 

In yData set now we have activity ids for all our experiments. In subjectData - ids for all subjects in all experiments. Let's make this data tidy too and rename columns properly:

```R
colnames(yData) <- c("activity")
colnames(subjectData) <- c("subject")
```

##Extracting only required measurements

Taking into consideration information from "features_info.txt" file to extract only the measurements on the mean and standard deviation for each measurement we are going to find "std()" and "mean()" strings in column names and keep new data in tidyData variable:

```R
xDataColumnNames <- names(xData)
tidyData <- xData[, grepl("mean()", xDataColumnNames) | grepl("std()", xDataColumnNames)]
```

##Labeling data set with descriptive variable names

To make all variable names more descriptive we need to use all possible information from "features_info.txt" file to unwrap all abbreviations. We are going to use "gsub" function to replace substrings in label names. 

Note: gsub function takes regular expression as first argument so in case when we need to find and replace substring which includes reserved / specific characters (like ".", "(", "), etc) we need to add extra "\\" in front of this string to specify your intentions.

```R
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
```

##Merging with activities and subjects

Now we can add activities and subjects into our tidyData. And finally we merge tidyData with activities data set to get activity names instead activity ids. This step will reorder our tidyData. 

Note: in merge function we need to include all values from "tidyData" and only matched values from "activities". That's why we specify: all.x = TRUE, all.y = FALSE 

```R
tidyData$activity <-yData$activity
tidyData$subject  <-subjectData$subject
    
tidyData <- merge(tidyData, activities, by.x = "activity", by.y = "activityid", all.x = TRUE, all.y = FALSE)
```
Last merge operation added two more columns (activityid and activityname) into our tidyData set but we need only activity name. Let's remove activityId and rename "activityname" to just "activity":

```R
tidyData <- tidyData[, 2:ncol(tidyData)]
tidyData <- rename(tidyData, activity = activityname)
```

##Aggregating data

To create another tidy data set with the average of each variable for each activity and each subject "aggregate" function is a perfect match:

```R
#Prepare all columns except "activity" and "subject"
endColumn <- ncol(tidyData) - 2
tidyDataSummary <- aggregate(tidyData[, 1:endColumn], list(activity = tidyData$activity, subject = tidyData$subject), mean)
```

##Saving all results

To save our results let's just write them to the hard drive:
 
```R
write.table(tidyData, file = "tidyData.txt", row.name = FALSE)
write.table(tidyDataSummary, file = "tidyDataSummary.txt", row.name = FALSE)
```

You can easily load them using read.table function later:

```R
tidyData <- read.table("tidyData.txt", header = F)
tidyDataSummary <- read.table("tidyDataSummary.txt", header = F)
```

##Cleanup your workspace

Finally to cleanup our busy workspace:
```R
rm(list = ls())
```

Note: of course it's better to delete (rm()) unused variables as soon as possible to reduce pressure on RAM memory. 

#Resulting tidy data set

* subject

	An identifier of the subject who carried out the experiment.
* activity

 An identifier of the activity is observed in the experiment:
 - walking
 - walkingupstairs
 - walkingdownstairs
 - sitting
 - standing
 - laying
* timeBodyAccelerationMeanValueX

 Time domain body acceleration Mean value of X axis

* timeBodyAccelerationMeanValueY

 Time domain body acceleration Mean value of Y axis

* timeBodyAccelerationMeanValueZ

 Time domain body acceleration Mean value of Z axis

* timeBodyAccelerationStandardDeviationX

 Time domain body acceleration Standard Deviation of X axis

* timeBodyAccelerationStandardDeviationY

 Time domain body acceleration Standard Deviation of Y axis

* timeBodyAccelerationStandardDeviationZ

 Time domain body acceleration Standard Deviation of Z axis

* timeGravityAccelerationMeanValueX

 Time domain gravity acceleration Mean value of X axis
 
* timeGravityAccelerationMeanValueY

 Time domain gravity acceleration Mean value of Y axis
 
* timeGravityAccelerationMeanValueZ

 Time domain gravity acceleration Mean value of Z axis

* timeGravityAccelerationStandardDeviationX

 Time domain gravity acceleration Standard Deviation of X axis

* timeGravityAccelerationStandardDeviationY

 Time domain gravity acceleration Standard Deviation of Y axis

* timeGravityAccelerationStandardDeviationZ

 Time domain gravity acceleration Standard Deviation of Z axis

* timeBodyAccelerationJerkMeanValueX

 Time domain body acceleration Jerk Mean value of X axis
 
* timeBodyAccelerationJerkMeanValueY

 Time domain body acceleration Jerk Mean value of Y axis
 
* timeBodyAccelerationJerkMeanValueZ

 Time domain body acceleration Jerk Mean value of Z axis

* timeBodyAccelerationJerkStandardDeviationX

 Time domain body acceleration Jerk Standard Deviation of X axis

* timeBodyAccelerationJerkStandardDeviationY

 Time domain body acceleration Jerk Standard Deviation of Y axis

* timeBodyAccelerationJerkStandardDeviationZ

 Time domain body acceleration Jerk Standard Deviation of Z axis

* timeBodyGyroMeanValueX

 Time domain body gyroscope Mean value of X axis
 
* timeBodyGyroMeanValueY

 Time domain body gyroscope Mean value of Y axis
 
* timeBodyGyroMeanValueZ

 Time domain body gyroscope Mean value of Z axis
 
* timeBodyGyroStandardDeviationX

 Time domain body gyroscope Standard Deviation of X axis

* timeBodyGyroStandardDeviationY

 Time domain body gyroscope Standard Deviation of Y axis

* timeBodyGyroStandardDeviationZ

 Time domain body gyroscope Standard Deviation of Z axis

* timeBodyGyroJerkMeanValueX

 Time domain body gyroscope Jerk Mean value of X axis
 
* timeBodyGyroJerkMeanValueY

 Time domain body gyroscope Jerk Mean value of Y axis
 
* timeBodyGyroJerkMeanValueZ

 Time domain body gyroscope Jerk Mean value of Z axis
 
* timeBodyGyroJerkStandardDeviationX

 Time domain body gyroscope Jerk Standard Deviation of X axis

* timeBodyGyroJerkStandardDeviationY

 Time domain body gyroscope Jerk Standard Deviation of Y axis

* timeBodyGyroJerkStandardDeviationZ

 Time domain body gyroscope Jerk Standard Deviation of Z axis

* timeBodyAccelerationMagnitudeMeanValue

 Time domain body acceleration magnitude Mean value
 
* timeBodyAccelerationMagnitudeStandardDeviation

 Time domain body acceleration magnitude Standard Deviation

* timeGravityAccelerationMagnitudeMeanValue

 Time domain gravity acceleration magnitude Mean value
 
* timeGravityAccelerationMagnitudeStandardDeviation

 Time domain gravity acceleration magnitude Standard Deviation

* timeBodyAccelerationJerkMagnitudeMeanValue

 Time domain body acceleration magnitude Jerk Mean value
 
* timeBodyAccelerationJerkMagnitudeStandardDeviation

  Time domain body acceleration magnitude Jerk Standard Deviation
 
* timeBodyGyroMagnitudeMeanValue

 Time domain body gyroscope magnitude Mean value
 
* timeBodyGyroMagnitudeStandardDeviation

 Time domain body gyroscope magnitude Standard Deviation

* timeBodyGyroJerkMagnitudeMeanValue

 Time domain body gyroscope magnitude Jerk Mean value

* timeBodyGyroJerkMagnitudeStandardDeviation

 Time domain body gyroscope magnitude Jerk Standard Deviation

* frequencyBodyAccelerationMeanValueX

 Frequency domain body acceleration Mean value of X axis

* frequencyBodyAccelerationMeanValueY

 Frequency domain body acceleration Mean value of Y axis

* frequencyBodyAccelerationMeanValueZ

 Frequency domain body acceleration Mean value of Z axis

* frequencyBodyAccelerationStandardDeviationX

 Frequency domain body acceleration Standard Deviation of X axis

* frequencyBodyAccelerationStandardDeviationY

 Frequency domain body acceleration Standard Deviation of Y axis

* frequencyBodyAccelerationStandardDeviationZ

 Frequency domain body acceleration Standard Deviation of Z axis

* frequencyBodyAccelerationMeanValueFrequencyX

 Frequency domain body acceleration Mean value of X axis

* frequencyBodyAccelerationMeanValueFrequencyY

 Frequency domain body acceleration Mean value of Y axis
 
* frequencyBodyAccelerationMeanValueFrequencyZ

  Frequency domain body acceleration Mean value of Z axis

* frequencyBodyAccelerationJerkMeanValueX

 Frequency domain body acceleration Jerk Mean value of X axis

* frequencyBodyAccelerationJerkMeanValueY

 Frequency domain body acceleration Jerk Mean value of Y axis

* frequencyBodyAccelerationJerkMeanValueZ

 Frequency domain body acceleration Jerk Mean value of Z axis

* frequencyBodyAccelerationJerkStandardDeviationX

 Frequency domain body acceleration Jerk Standard Deviation of X axis

* frequencyBodyAccelerationJerkStandardDeviationY

 Frequency domain body acceleration Jerk Standard Deviation of Y axis

* frequencyBodyAccelerationJerkStandardDeviationZ

 Frequency domain body acceleration Jerk Standard Deviation of Z axis

* frequencyBodyAccelerationJerkMeanValueFrequencyX

 Frequency domain body acceleration Jerk Mean value of X axis

* frequencyBodyAccelerationJerkMeanValueFrequencyY

 Frequency domain body acceleration Jerk Mean value of Y axis

* frequencyBodyAccelerationJerkMeanValueFrequencyZ

 Frequency domain body acceleration Jerk Mean value of Z axis

* frequencyBodyGyroMeanValueX

 Frequency domain body gyroscope Mean value of X axis

* frequencyBodyGyroMeanValueY

 Frequency domain body gyroscope Mean value of Y axis

* frequencyBodyGyroMeanValueZ

 Frequency domain body gyroscope Mean value of Z axis

* frequencyBodyGyroStandardDeviationX

 Frequency domain body gyroscope Standard Deviation of X axis

* frequencyBodyGyroStandardDeviationY

 Frequency domain body gyroscope Standard Deviation of Y axis

* frequencyBodyGyroStandardDeviationZ

 Frequency domain body gyroscope Standard Deviation of Z axis

* frequencyBodyGyroMeanValueFrequencyX

 Frequency domain body gyroscope Mean value of X axis

* frequencyBodyGyroMeanValueFrequencyY

 Frequency domain body gyroscope Mean value of Y axis

* frequencyBodyGyroMeanValueFrequencyZ

 Frequency domain body gyroscope Mean value of Z axis

* frequencyBodyAccelerationMagnitudeMeanValue

 Frequency domain body acceleration magnitude Mean value

* frequencyBodyAccelerationMagnitudeStandardDeviation

 Frequency domain body acceleration magnitude Standard Deviation

* frequencyBodyAccelerationMagnitudeMeanValueFrequency

 Frequency domain body acceleration magnitude Mean value

* frequencyAccelerationJerkMagnitudeMeanValue

 Frequency domain acceleration magnitude Jerk Mean value

* frequencyAccelerationJerkMagnitudeStandardDeviation

 Frequency domain acceleration magnitude Jerk Standard Deviation

* frequencyAccelerationJerkMagnitudeMeanValueFrequency

 Frequency domain acceleration magnitude Jerk Mean value

* frequencyGyroMagnitudeMeanValue

 Frequency domain gyroscope magnitude Mean value

* frequencyGyroMagnitudeStandardDeviation

 Frequency domain gyroscope magnitude Standard Deviation

* frequencyGyroMagnitudeMeanValueFrequency

 Frequency domain gyroscope magnitude Mean value

* frequencyGyroJerkMagnitudeMeanValue

 Frequency domain gyroscope magnitude Jerk Mean value

* frequencyGyroJerkMagnitudeStandardDeviation

 Frequency domain gyroscope magnitude Jerk Standard Deviation

* frequencyGyroJerkMagnitudeMeanValueFrequency

 Frequency domain gyroscope magnitude Jerk Mean value
