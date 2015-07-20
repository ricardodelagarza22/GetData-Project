library(data.table)
library(reshape2)

#Processing a dataset
dataProcessing <- function(directory, X_fn, y_fn, s_fn, 
                     activity_labels, features) {
  #Loading X_file,
  X_file <- read.table(file.path(directory,X_fn,fsep=.Platform$file.sep))
  
  #Loading file labels  
  y_file <- read.table(file.path(directory,y_fn,fsep=.Platform$file.sep))
  
  #Loading subjects activity
  subject_file <- read.table(file.path(directory,s_fn,fsep=.Platform$file.sep))
  
  #naming X_file columns
  names(X_file) = features
  
  #Extracts only the measurements on the mean and standard deviation 
  #for each measurement. 
  print(dim(X_file))
  mStd <- grepl("mean|std", features)
  X_file = X_file[,mStd]
  print(dim(X_file))
  
  #Use descriptive activity names to name the activities in the data set
  y_file[,2] = activity_labels[y_file[,1]]
  
  #Labels the data set with descriptive variable names. 
  names(y_file) = c("ActivityType", "Description")
  names(subject_file) = "SubjectId"
  
  #Preparing data to get the average of each variable for each activity 
  #and each subject.
  return(cbind(as.data.table(subject_file), y_file, X_file))
}

# Loading activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]

# Loading data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

test <- dataProcessing("UCI HAR Dataset/test/","X_test.txt",
                  "y_test.txt","subject_test.txt",
                  activity_labels,features)

train <- dataProcessing("UCI HAR Dataset/train/","X_train.txt",
                 "y_train.txt","subject_train.txt",
                 activity_labels,features)

#Merging test and train datasets
merged = rbind(test, train)
print(dim(merged))

#Calculating mean values for each Mean and Std features 
#per activity and subject 
tidy <- aggregate(. ~SubjectId + ActivityType, merged, mean)
print(dim(tidy))

write.table(tidy, file = "tidy.txt", row.name=FALSE)