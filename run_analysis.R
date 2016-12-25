#Course Project - Getting and Cleaning Data - Winter 2016
#Jason Mestrits - mestrits@gmail.com

#You should create one R script called run_analysis.R that does the following.

#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement.
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names.
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



setwd("C:/Users/joson.mestrits/Desktop/1 - a Version Control/1 Training/1-edx Classes/Johns Hopkins  Data Science/3  - Getting and Cleaning Data/Course Project")

rm(list = ls())

###Load required packages  
#not all of these are needed, but i played around with a few of them in the process
library(data.table)
library(tidyr)
library(tibble)
library(lubridate)
library(readr)
library(dplyr)

#create a directory and download the data file
if(!file.exists("./project_data")){dir.create("./project_data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project_data/smartphone_dataset.zip")

#unpack the files and view the files in the folder
unzip(zipfile="./project_data/smartphone_dataset.zip",exdir="./project_data")
unzipped_path <- file.path("./project_data" , "UCI HAR Dataset")
unzipped_files <- list.files(unzipped_path, recursive=TRUE)
unzipped_files


#read in the data and create tables

#read in suject files
subject_train <- read.table("./project_data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./project_data/UCI HAR Dataset/test/subject_test.txt")

#read in activities aka y_files
y_train <- read.table("./project_data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./project_data/UCI HAR Dataset/test/y_test.txt")

#read in the feature data aka x_files
x_train <- read.table("./project_data/UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./project_data/UCI HAR Dataset/test/X_test.txt")

#read in the feature names
features_names <- read.table("./project_data/UCI HAR Dataset/features.txt")

#read in the activity names
activity_labels <- read.table("./project_data/UCI HAR Dataset/activity_labels.txt")


#assign column names
colnames(x_train) <- features_names[,2] 
colnames(y_train) <-"Activity"
colnames(subject_train) <- "Subject"

colnames(x_test) <- features_names[,2] 
colnames(y_test) <-"Activity"
colnames(subject_test) <- "Subject"

colnames(activity_labels) <- c('activity_num','activity_name')


#1 Merges the training and the test sets to create one data set.
#merge all the data into one table. 
    #make sure to put them in the correct(same) order!

train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)

onedata_full <- rbind(train_data, test_data)   #puts the training data on top


#2 Extract only the measurements on the mean and stdev for each measurement.

#create a character vector of all the column names
allcolumn_chr <- colnames(onedata_full)  

#create a data.frame from the charater vector of column feature names
allcolumn_names <- data.frame(VARIALBLES=allcolumn_chr) #names the column VARIABLES

#run grepl to create a logical vector including the terms we want to keep
mean_stdev_logicalsub <- 
  grepl("mean()", allcolumn_names$VARIALBLES) |
  grepl("std()", allcolumn_names$VARIALBLES) |
  grepl("Activity", allcolumn_names$VARIALBLES) |   
  grepl("Subject", allcolumn_names$VARIALBLES)  


# We do not want to include values for meanFreq() i.e. Weighted average of the frequency components to obtain a mean frequency
# I am not considering meanFreq as a Mean or StDev calculations for estimated variable set
#however the above grepl command identified this along with other mean estimations

#create a logical vector for meaurements with meanFreq
meanFreq_logical <- grepl("meanFreq", allcolumn_names$VARIALBLES)

#subract meanFreq logical vector from the larger set, so as to remove these columns
mean_stdev_logicalsub2 <- (mean_stdev_logicalsub - meanFreq_logical)

#Create subset with only mean and Stdev measurements
onedata_sub_mean_stdev <- onedata_full[,mean_stdev_logicalsub2 == TRUE]


#3 Uses descriptive activity names to name the activities in the data set
#I know there is a more efficient and elegant way to accomplish this
#... but i have a "hacking" cough this weekend and my inlaws just arrived for Christmas eve
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 1] <- "WALKING"
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 2] <- "WALKING_UPSTAIRS"
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 3] <- "WALKING_DOWNSTAIRS"
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 4] <- "SITTING"
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 5] <- "STANDING"
onedata_sub_mean_stdev$Activity[onedata_sub_mean_stdev$Activity == 6] <- "LAYING"


#4 Appropriately labels the data set with descriptive variable names.
#view the names of the feature variables
str(onedata_sub_mean_stdev)

#rename "onedata_sub_mean_stdev" to shorten the name
onedata <- onedata_sub_mean_stdev


names(onedata)<-gsub("std()", "StDev", names(onedata))
names(onedata)<-gsub("mean()", "Mean", names(onedata))
names(onedata)<-gsub("^t", "Time", names(onedata))
names(onedata)<-gsub("^f", "Frequency", names(onedata))
names(onedata)<-gsub("Acc", "Accelerometer", names(onedata))
names(onedata)<-gsub("Gyro", "Gyroscope", names(onedata))
names(onedata)<-gsub("Mag", "Magnitude", names(onedata))
names(onedata)<-gsub("BodyBody", "Body", names(onedata))

#the ^ carrot keeps gsub from changing every single letter 
# i.e. ^t takes only the leading t and not every "t"

#view your data to make sure the changes make sense
str(onedata)


#5 From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.


#create a mean for each variable for each subject by activity
tidydata1 <- aggregate(. ~Subject + Activity, onedata, mean)
#order by Subject (aka participant ID)
tidydata2 <- tidydata1[order(tidydata1$Subject,tidydata1$Activity),]

write.table(tidydata2, file = "tidydata.txt",row.name=FALSE)

