library(reshape2)
X <- rbind(read.table("test/X_test.txt"), read.table("train/X_train.txt"))
y <- rbind(read.table("test/y_test.txt"), read.table("train/y_train.txt"))
y[, 2] <- seq(1:nrow(y))
subject <- rbind( read.table("test/subject_test.txt"),
                  read.table("train/subject_train.txt"))
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
colnames(X) = features[, 2]
colnames(y) = c("Activityid", "id")
colnames(subject) = "Subject"
colnames(activities) = c("key", "Activity")
X <- X[, read.table(text = as.character(features[, 2]),
                     sep = "-", fill = T)[, 2] %in% c("mean()", "std()")]
y <- merge(y, activities, by.x = "Activityid", by.y="key")
X <- cbind(X, Activity = y[order(merged$id), 3], Subject = subject)
meltedX <- melt(X, id = c("Subject", "Activity"))
castedX <- dcast(meltedX, Subject + Activity ~ variable, mean)
write.table(castedX, file = "tidydata.txt", row.name=F)