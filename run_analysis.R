# Install dplyr package
library(dplyr)

# Download dataset
zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "UCI HAR Dataset.zip"
if (!file.exists(zipfile)){download.file(zipurl, zipfile)}  
datapath <- "UCI HAR Dataset"
if (!file.exists(datapath)) {unzip(zipfile)}

# Read data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merge data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
mergedata <- cbind(Subject, Y, X)

tidy <- mergedata %>% select(subject, code, contains("mean"), contains("std"))
tidy$code <- activities[tidy$code, 2]
names(tidy)[2] = "activity"

answer <- tidy %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(answer, "answer.txt", row.name=FALSE)
