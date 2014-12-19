
#1. Merge the training and the test sets to create one data set.
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_merged <- rbind(subject_train, subject_test)
names(subject_merged) <- "subject"

X_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
X_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
X_merged  <- rbind(X_train, X_test)

y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y_merged  <- rbind(y_train, y_test)
names(y_merged) <- "activity"

#2. Extract only the measurements on the mean and standard deviation for each measurement. 
features <- read.table('./UCI HAR Dataset/features.txt', header=FALSE, col.names=c('id', 'name'))
feature_selected_columns <- grep('mean\\(\\)|std\\(\\)', features$name)
X_filtered_dataset <- X_merged[, feature_selected_columns]
names(X_filtered_dataset) <- features[features$id %in% feature_selected_columns, 2]

#3. Use descriptive activity names to name the activities in the data set
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header=FALSE, col.names=c('id', 'name'))

#4. Appropriately label the data set with descriptive activity names.
y_merged[, 1] = activity_labels[y_merged[, 1], 2]

#5.1 Create an dataset with all required measurements.
all_dataset <- cbind(subject_merged, y_merged, X_filtered_dataset)
write.csv(all_dataset, "./output/all_dataset_with_descriptive_activity_names.csv")

#5.2 Create the final, independent tidy data set with the average of each variable for each activity and each subject.
measurements <- all_dataset[, 3:dim(all_dataset)[2]]
tidy_dataset <- aggregate(measurements, list(all_dataset$subject, all_dataset$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.table(tidy_dataset, "./output/final_tidy_dataset.txt", row.name=FALSE)
