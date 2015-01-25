#read 'features.txt': List of all features
features <- read.table("UCI HAR Dataset/features.txt")

#we only want the measurements on the mean and standard deviation
#let's create an index of columns to keep/discard when calling read.table on X data
importIndex <- grepl("*mean|*std", features[,2], ignore.case = TRUE)
importIndex <- ifelse(importIndex==TRUE,"numeric","NULL")

#read in X data and merge
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses=importIndex)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses=importIndex)
x_merged <- rbind(x_train,x_test)

#vector of column names of mean and standard deviation measurements only
columnNames <- as.vector(features[grep("*mean|*std", features[,2], ignore.case=T),2])
#set column names
colnames(x_merged) <- columnNames

#read in Y data and merge
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_merged <- rbind(y_train,y_test)

#read in activity labels
y_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
#match and replace numeric codes with activity labels
y_merged[,1] <- as.character(y_labels[match(y_merged[,1], y_labels[,1]), 2])

#read in subjects and merge
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
sub_merged <- rbind(subject_train,subject_test)

#almost there, let's bind the merged sets
almostThere <- cbind(y_merged, sub_merged, x_merged)
#rename first two columns
names(almostThere)[1:2] <- c("activity", "subject")

#a little cleanup
rm(list=setdiff(ls(), "almostThere"))

#independent tidy data set with the average of each variable for each activity and each subject
tidyData <- aggregate(. ~ activity+subject, almostThere, mean)

#export
write.table(tidyData, "tidyData.txt", row.name=FALSE)