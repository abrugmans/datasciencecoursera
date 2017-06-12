
#1.Download and unzip dataset

filename <- "./getting-and-cleaning-data-project/getdata_projectfiles_UCI HAR Dataset.zip"


##Download the dataset
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, destfile=filename, method="curl")
}  


##If not exist the folder dataset it will unzip
if (!file.exists("./getting-and-cleaning-data-project/getdata_projectfiles_UCI HAR Dataset")){ 
        unzip(filename, exdir="./getting-and-cleaning-data-project/") 
}


#2.Merges the training and the test sets to create one data set.

##Read training tables
x_train <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/train/subject_train.txt")


##Read testing tables:
x_test <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/test/subject_test.txt")


##Reading feature table:
features <- read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/features.txt")

##Reading activity labels:
activityLabels = read.table("./getting-and-cleaning-data-project/UCI HAR Dataset/activity_labels.txt")

##Assign column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')


##Merging data in one dataset
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_train, merge_test)


#3.Extracting only the measurements on the mean and standard deviation for each measurement

##Reading column names
column_names <- colnames(setAllInOne)

##Create vector for defining ID, mean and SD
mean_sd <- (grepl("activityId", column_names)|
            grepl("subjectId", column_names)|
            grepl("mean..", column_names)|
            grepl("std..", column_names)
            )

##Subsetting setAllInOne
subset_mean_sd <- setAllInOne[, mean_sd==TRUE]


#4.Using descriptive activity names to name the activities in the data set
setActivityNames <- merge(subset_mean_sd, activityLabels,
                          by="activityId",
                          all.x=TRUE)


#5.Creating a second independent tidy data set with the average of each variable for each activity and each subject.

##Making the second tidy data set
secondTidySet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

##Writing second tidy data set in a txt file
write.table(secondTidySet, "./getting-and-cleaning-data-project/secondTidySet.txt", row.names=FALSE)


