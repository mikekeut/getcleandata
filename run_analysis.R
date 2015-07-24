library(dplyr)
setwd("/Users/MikeKeut/Dropbox/coursera/getcleandata/courseproject")
train <- read.table("X_train.txt", header = FALSE)
test <- read.table("X_test.txt", header = FALSE)
activity_train <- read.table("train/y_train.txt", header = F)
activity_test <- read.table("test/y_test.txt", header = F)
subject_train <- read.table("train/subject_train.txt", header = F)
subject_test <- read.table("test/subject_test.txt", header = F)
train <- cbind(train, activity_train)
test <- cbind(test, activity_test)
train <- cbind(train, subject_train)
test <- cbind(test, subject_test)
merge <- rbind(train, test)
feature_names <- read.table("features.txt", header = F)
feature_names <- feature_names[,2]
colnames(merge) <- feature_names
mean_vars <- grep("mean", feature_names)
std_vars <- grep("std", feature_names)
keep_vars <- append(mean_vars, values=c(std_vars, 562, 563))
keep_data <- merge[,keep_vars]
colnames(keep_data)[80] <- "activity"
colnames(keep_data)[81] <- "subject"
keep_data$activity[keep_data$activity == 1] <- "walking"
keep_data$activity[keep_data$activity == 2] <- "walking upstairs"
keep_data$activity[keep_data$activity == 3] <- "walking downstairs"
keep_data$activity[keep_data$activity == 4] <- "sitting"
keep_data$activity[keep_data$activity == 5] <- "standing"
keep_data$activity[keep_data$activity == 6] <- "laying"
keep_data$activity <- as.factor(keep_data$activity)
keep_data <- tbl_df(keep_data)
grouped <- group_by(keep_data, activity, subject)
final_table <- grouped %>% summarise_each(funs(mean))
write.table(final_table, file = "tidy_data_set.txt", row.name = FALSE)
