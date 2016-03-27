#Course Project tidy data README file
##Version 1.0
###Getting and Cleaning Data course.

#Human Activity Recognition Using Smartphones Dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

##For each record it is provided:

 +Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
 +Triaxial Angular velocity from the gyroscope. 
 +A 561-feature vector with time and frequency domain variables. 
 +Its activity label. 
 +An identifier of the subject who carried out the experiment.

##Original dataset includes the following files:

 +'features_info.txt': Shows information about the variables used on the feature vector.
 +'features.txt': List of all features.
 +'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
 +'activity_labels.txt': Links the class labels with their activity name.
 +'train/X_train.txt': Training set.
 +'train/y_train.txt': Training labels.
 +'test/X_test.txt': Test set.
 +'test/y_test.txt': Test labels.

##The purpose of my work is to cleanup and prepare original data for a further processing and analysis includes following steps:

 +Merge the training and the test sets to create one data set.
 +Extract only the measurements on the mean and standard deviation for each measurement.
 +Use descriptive activity names to name the activities in the data set.
 +Appropriately label the data set with descriptive variable names.
 +From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
 
##Results of my study and work:

 +'README.md' file describes what this repository is about.
 +'CODEBOOK.md' file describes how to convert original data sets into one resulting tidy data set.
 +'run_analysis.R' R script file to convert original data sets into one resulting tidy data set.
 +'Dataset/tidyData.txt' tidy data set saved on step 4 of my study and processing.
 +'Dataset/tidyDataSummary.txt' aggregated tidy data set saved on step 5 of my study and processing.
