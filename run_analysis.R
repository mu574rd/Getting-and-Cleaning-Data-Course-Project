## Read the files.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(activities) <- c('id', 'name')
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(features) <- c('id', 'name')

trainx <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
names(trainx) <- features$name
trainy <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
names(trainy) <- c("activity")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
names(trainsubject) <- c('subject')
testx <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
names(testx) <- features$name
testy <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
names(testy) <- c('activity')
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
names(testsubject) <- c('subject')

## Merges the training and the test sets to create one data set.
x <- rbind(trainx, testx)
y <- rbind(trainy, testy)
subject <- rbind(trainsubject, testsubject)

## Extracts only the measurements on the mean and standard deviation for each measurement.
x <- x[, grep('mean|std', features$name)]

## Uses descriptive activity names to name the activities in the data set
y$activity <- activities[y$activity,]$name
tidydataset <- cbind(subject, y, x)

## Appropriately labels the data set with descriptive variable names.
names(tidydataset)<-gsub("^t", "Time", names(tidydataset))
names(tidydataset)<-gsub("^f", "Frequency", names(tidydataset))
names(tidydataset)<-gsub("Acc", "Accelerometer", names(tidydataset))
names(tidydataset)<-gsub("Gyro", "Gyroscope", names(tidydataset))
names(tidydataset)<-gsub("Mag", "Magnitude", names(tidydataset))
names(tidydataset)<-gsub("BodyBody", "Body", names(tidydataset))
names(tidydataset)<-gsub("mean\\(\\)", "Mean", names(tidydataset))
names(tidydataset)<-gsub("meanFreq\\(\\)", "Mean", names(tidydataset))
names(tidydataset)<-gsub("std\\(\\)", "Std", names(tidydataset))

## Creates a second, independent tidy data set with the average of each 
## variable for each activity and each subject.
averagestidydataset <- aggregate(tidydataset[, 3:dim(tidydataset)[2]],
                                list(tidydataset$subject,
                                     tidydataset$activity),
                                mean)
names(averagestidydataset)[1:2] <- c('Subject', 'Activity')

write.table(averagestidydataset, "tidy_dataset.txt")
