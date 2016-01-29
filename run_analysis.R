library(data.table)
## Load test data
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")

## Load train data
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")

## Load labels for activities and features
activities <- read.table("./activity_labels.txt", col.names = c("activityCode", "activityName"))
features <- read.table("./features.txt", col.names = c("featureCode", "featureName"))

## Clean activityName
activities$activityName <- gsub("_", " ", as.character(activities$activityName))

## Gather featureCode for mean and standard dev.
featuresFunc <- grep("-mean\\(\\)|-std\\(\\)", features$featureName)

## Merge the train and test data sets
subject <- rbind(subject_test, subject_train)
names(subject) <- "subjectCode"
x <- rbind(x_test, x_train)
x <- x[, featuresFunc]
names(x) <- gsub("\\(|\\)", "", features$featureName[featuresFunc])

y <- rbind(y_test, y_train)
names(y) = "activityCode"
activity <- merge(y, activities, by="activityCode")$activityName

tidyData <- cbind(subject, x, activity)
write.table(tidyData, "tidyData.txt")

# Standard deviation and mean grouped by subject and activity 
tidyDataDT <- data.table(tidyData)
tidyDataFunctions<- tidyDataDT[, lapply(.SD, mean), by=c("subjectCode", "activity")]
write.table(tidyDataFunctions, "tidyDataFunctions.txt")

