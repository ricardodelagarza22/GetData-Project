# GetData-Project

The dataset includes the following files:
=========================================

- **README.md** : This file, it summarizes dataset files and purpose.
- **CodeBook.md** : Describes the variables, data, and transformations performed to clean up the data
- **run_analysis.R** : This script preprocesses Test and Train datates from the "Human Activity Recognition Using Smartphones Dataset" Version 1.0.  It merges activity logs (`y_*.txt`), subjects performing the activities (`subject_*.txt`) with the corresponding measurements (`X_*.txt`). It also filters out measurements leaving only mean and standard deviation. Finally, it averages measurements per activity and subject and stores the generated data into a new dataset. NOTICE that it is required that `run_analysis.R` is located in the same directory as the origin datasets. 
- **tidy.txt** : The data set resulting from the `run_analysis.R` preprocessing.
