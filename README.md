=============================================================================================
This markdown file has the summary message about assignment of class "Getting and cleaning data".
=============================================================================================

The steps of creating the dataset output in part 1:
1. At the beginning of the script, "library" the necessary R packages,"data.table" and "dplyr".

2. Merges the training and the test sets to create one data set. 
I use the "fread" fuction in package "data.table" to read the data file into R, including "./train/X_train.txt","./test/X_test.txt","./train/y_train.txt","./test/y_test.txt","./train/subject_train.txt","./test/subject_test.txt". With the function "rbind", I can merge these data files in to one dataset.

3. Extracts only the measurements on the mean and standard deviation for each measurement. 
We can get all the features in the text file "./features.txt", and use "grep" to find the index of features whose names contain "mean" or "std". However, "meanFreq()" is included in the "grep" result, so I modified the index. With the index vector, I can get only the corresponding features.

4. Uses descriptive activity names to name the activities in the data. 
Now, we find that the activity label in the dataset is not descriptible. Read the labels from file "./activity_labels.txt", and substitute the values in the dataset to be descriptive.

5. Appropriately labels the data set with descriptive variable names.
Still in the "./features.txt", we can find the feature names corresponding to the features selected in the previous steps. But as a tidy data, the variable names must satisfy some important points. Make the names be the lower case, descriptive, and not have underscores or dots or white spaces. 

6. From the data set in the previous step, creates a second, independent tidy data set  with the average of each variable for each activity and each subject.
Split the dataset over the activity label and subject label, and use "sapply" function to get the average of each column. To be a second tidy data, modify the varibale names to be nice. The dataset result in this step is named "dataset2".

7. For the uoload assignment, use "write.table()" with"row.name=FALSE" to save dataset2 into a text in the working directory.
