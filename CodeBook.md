---
title: "CodeBook for Tidy dataset"
output: html_document
---

This file describes the variables, data, and transformations performed to clean up the data

###Data origin

The data for `tidy.txt` represent data collected from the accelerometers of the Samsung Galaxy S smartphone obtained from the UCI Machine Learning Repository ([link here] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). It records the activity of 30 subjects performing daily living activities while carrying a waist-mounted smartphone with embedded inertial sensors, on 2012. It included 10.299 instances, 561 attributes, whithout missing values. 

The original data contained three txt files storing the list of all dataset features (`features.txt`), information about such features (`features_info.txt`), activity names and labels (`activity_labels.txt`). The dataset contained also two directories `test` and `train` each containing a training set (`X_*.txt`), a training labels file (`y_*.txt`), and a subject activity log (`subject_*.txt`), plus a directory comprehending a set of txt files describing Inertial Signals. 

###Dataset
The tidy dataset comprehend the list of files described in the README.md file. The data itself is stored into a `tidy.txt` file. It comprehends 180 observations on 82 variables, whithout missing values, representing the average value for the orignal measurements related to Mean value and Standard deviation. The feature list is as follows: 

- SubjectId
- ActivityType
- Description
- tBodyAcc-mean()-X
- tBodyAcc-mean()-Y
- tBodyAcc-mean()-Z
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tGravityAcc-mean()-X
- tGravityAcc-mean()-Y
- tGravityAcc-mean()-Z
- tGravityAcc-std()-X
- tGravityAcc-std()-Y
- tGravityAcc-std()-Z
- tBodyAccJerk-mean()-X
- tBodyAccJerk-mean()-Y
- tBodyAccJerk-mean()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-mean()-X
- tBodyGyro-mean()-Y
- tBodyGyro-mean()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyGyroJerk-mean()-X
- tBodyGyroJerk-mean()-Y
- tBodyGyroJerk-mean()-Z
- tBodyGyroJerk-std()-X
- tBodyGyroJerk-std()-Y
- tBodyGyroJerk-std()-Z
- tBodyAccMag-mean()
- tBodyAccMag-std()
- tGravityAccMag-mean()
- tGravityAccMag-std()
- tBodyAccJerkMag-mean()
- tBodyAccJerkMag-std()
- tBodyGyroMag-mean()
- tBodyGyroMag-std()
- tBodyGyroJerkMag-mean()
- tBodyGyroJerkMag-std()
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAcc-std()-X
- fBodyAcc-std()-Y
- fBodyAcc-std()-Z
- fBodyAcc-meanFreq()-X
- fBodyAcc-meanFreq()-Y
- fBodyAcc-meanFreq()-Z
- fBodyAccJerk-mean()-X
- fBodyAccJerk-mean()-Y
- fBodyAccJerk-mean()-Z
- fBodyAccJerk-std()-X
- fBodyAccJerk-std()-Y
- fBodyAccJerk-std()-Z
- fBodyAccJerk-meanFreq()-X
- fBodyAccJerk-meanFreq()-Y
- fBodyAccJerk-meanFreq()-Z
- fBodyGyro-mean()-X
- fBodyGyro-mean()-Y
- fBodyGyro-mean()-Z
- fBodyGyro-std()-X
- fBodyGyro-std()-Y
- fBodyGyro-std()-Z
- fBodyGyro-meanFreq()-X
- fBodyGyro-meanFreq()-Y
- fBodyGyro-meanFreq()-Z
- fBodyAccMag-mean()
- fBodyAccMag-std()
- fBodyAccMag-meanFreq()
- fBodyBodyAccJerkMag-mean()
- fBodyBodyAccJerkMag-std()
- fBodyBodyAccJerkMag-meanFreq()
- fBodyBodyGyroMag-mean()
- fBodyBodyGyroMag-std()
- fBodyBodyGyroMag-meanFreq()
- fBodyBodyGyroJerkMag-mean()
- fBodyBodyGyroJerkMag-std()
- fBodyBodyGyroJerkMag-meanFreq()


##Processing

Data processing requires the `data.table` and `reshape2` libraries. Main data processing is performed by the `dataProcessing` function for both the test and training sets. It returns a txt file where measurements (X_*.txt), activities (y_*.txt) and subject (subject_*.txt) data is merged:

```{r}
#Processing a dataset
dataProcessing <- function(directory, X_fn, y_fn, s_fn, 
                     activity_labels, features) 

#dataProcessing invocation
test <- dataProcessing("UCI HAR Dataset/test/","X_test.txt",
                  "y_test.txt","subject_test.txt",
                  activity_labels,features)

train <- dataProcessing("UCI HAR Dataset/train/","X_train.txt",
                 "y_train.txt","subject_train.txt",
                 activity_labels,features)
```

It requires to pre-load common files (activity_labels and features) and include them as parameters. 
```{r}
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
```

Once files are processed, both **the test and training sets are merged**.
```{r}
#Merging test and train datasets
merged = rbind(test, train)
print(dim(merged))
```

And **mean values are calculated, the resulting tidy dataset contains only the averaged values for the measurements per subject and activity type**, reducing the original dataset from 10299 to 180 observations.

```{r}
#Calculating mean values for each Mean and Std features 
#per activity and subject 
tidy <- aggregate(. ~SubjectId + ActivityType, merged, mean)
print(dim(tidy))
```

**The resulting dataset is stored as a `tidy.txt` file.**

```{r}
write.table(tidy, file = "tidy.txt", row.name=FALSE)
```


---
### dataProcessing function detailed
The `dataProcessing` function loads the datasets main files: `X_*.txt` (e.g. `X_test.txt` or `X_train.txt`), `y_*.txt` files, and `subject_*.txt` files.

```{r}
  X_file <- read.table(file.path(directory,X_fn,fsep=.Platform$file.sep))
  y_file <- read.table(file.path(directory,y_fn,fsep=.Platform$file.sep))
  subject_file <- read.table(file.path(directory,s_fn,fsep=.Platform$file.sep
```

Then it associates the feature names with the data:
```{r}
  names(X_file) = features
```
  
**Extracts only the measurements on the mean and standard deviation for each measurement**. Notice that the number of rows are preserved (2.947 for test, 7.352 for training) whereas the number of variables is reduced from 561 measurements to 79. 
```{r}
  print(dim(X_file))
  mStd <- grepl("mean|std", features)
  X_file = X_file[,mStd]
  print(dim(X_file))
```
  
**Activity desriptive names are used to name the activities in the data set**
```{r}
  y_file[,2] = activity_labels[y_file[,1]]
```
  
**The data set is labeled with descriptive variable names**
```{r}
  names(y_file) = c("ActivityType", "Description")
  names(subject_file) = "SubjectId"
```

And the data from the three dataset files is merged so that the average can be calculated:

```{r}
  #Preparing data to get the average of each variable for each activity 
  #and each subject.
  return(cbind(as.data.table(subject_file), y_file, X_file))
}
```


