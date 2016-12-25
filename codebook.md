# Code Book

This code book details the variables and steps used to produce the tidy data set `TidyData.txt`, using the run_analysis.R script included in this repo.


# Variables

* `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test` contain the data from the downloaded files.
* 'features_names' contains the 561 column names of the feature data that was collected in the x_train and x_test data files
* 'activity_labels' contains the 6 types of activities and the numeric ID associated with each activity type
* 'train_data', 'test_data' are variables used to column bind the above data sets together
* 'onedata_full' is the row binded full data set including test and training data sets.
* 'allcolumn_chr' is a character vector of all the variable/column names
* 'allcolumn_names' is a data frame created from 'allcolumn_chr', and the column name is VARIABLES
* 'mean_stdev_logicalsub' is a logical vector including the column that have mean and standard deviation data
* 'meanFreq_logical' is a logical vector including the column that has mean-frequency data. this is not desired, so we subtracct this logical vector from 'mean_stdev_logicalsub' to give the logical vector 'mean_stdev_logicalsub2'
* 'mean_stdev_logicalsub2' is a logical vector including all the columns we wish to keep in our subset
* 'onedata_sub_mean_stdev' is the combined data set that is subset on the logical vector 'mean_stdev_logicalsub2'
* 'onedata' is the same as 'onedata_sub_mean_stdev'.  I just added this to shorten the variable name
* 'tidydata1' and 'tidydata2' are manipulations of 'onedata' to group by Subject and order by activity the mean of each variable, as was the objective of the project. 
`


## General information on the data set

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

### Objectives
The script `run_analysis.R` in this repo is used to achieve the following objectives.

* Read in and combine the test and training data sets into one data set.
* Extract only the measurements on the mean and standard deviation for each measurement.
* Use descriptive activity names to name the activities in the data set
* Appropriately label the data set with descriptive variable names.
* From the previousstep, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




### Details of the output file i.e the Tidy Data Set
## Variables 

* `Subject` - The ID of the test subject - 30 individuals were tested and measurement for the above features were recorded
* `Activity` - The type of activity performed when the corresponding measurements were taken.  There were 6 classes or types of activity that feature data were recorded for

## Activity Labels

* `WALKING` (value `1`): subject was walking during the test
* `WALKING_UPSTAIRS` (value `2`): subject was walking up a staircase during the test
* `WALKING_DOWNSTAIRS` (value `3`): subject was walking down a staircase during the test
* `SITTING` (value `4`): subject was sitting during the test
* `STANDING` (value `5`): subject was standing during the test
* `LAYING` (value `6`): subject was laying down during the test
