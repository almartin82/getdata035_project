library(httr)
library(dplyr)
library(magrittr)
library(tidyr)

########
## 0. Reads in the data set.
#######

#get zip file and read
accel_url <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
tdir <- tempdir()
tname <- tempfile(pattern = "accel", tmpdir = tdir, fileext = ".zip")
httr::GET(url = accel_url, httr::write_disk(tname))
utils::unzip(tname, exdir = tdir)
accel_files = utils::unzip(tname, exdir = ".", list = TRUE)

########
## 1. Merges the training and the test sets to create one data set.
#######

#read in features
features <- read.table(file = paste0(tdir, '/UCI HAR Dataset/features.txt'), stringsAsFactors = FALSE)

#read in training data
train <- read.table(file = paste0(tdir, '/UCI HAR Dataset/train/X_train.txt'), stringsAsFactors = FALSE)
train_labels <- read.table(file = paste0(tdir, '/UCI HAR Dataset/train/Y_train.txt'), stringsAsFactors = FALSE)
train_subjects <- read.table(file = paste0(tdir, '/UCI HAR Dataset/train/subject_train.txt'), stringsAsFactors = FALSE)
names(train) <- features$V2
#put labels and subjects on training data
train$label <- train_labels$V1
train$subject <- train_subjects$V1
train$DataType <- 'train'

#read in test data
test <- read.table(file = paste0(tdir, '/UCI HAR Dataset/test/X_test.txt'), stringsAsFactors = FALSE)
test_labels <- read.table(file = paste0(tdir, '/UCI HAR Dataset/test/Y_test.txt'), stringsAsFactors = FALSE)
test_subjects <- read.table(file = paste0(tdir, '/UCI HAR Dataset/test/subject_test.txt'), stringsAsFactors = FALSE)
#label features
names(test) <- features$V2
#put labels and subjects on test data
test$label <- test_labels$V1
test$subject <- test_subjects$V1
test$DataType <- 'test'

#combine
combined <- rbind(test, train)

########
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#######

mask <-  grepl('mean()', features$V2, fixed = TRUE) | 
  grepl('std()', features$V2, fixed = TRUE) 
mask <- c(mask, TRUE, TRUE, TRUE)

combined_extracted <- combined[ ,mask]

########
## 3. Uses descriptive activity names to name the activities in the data set.
#######

act_names <- read.table(file = paste0(tdir, '/UCI HAR Dataset/activity_labels.txt'), stringsAsFactors = FALSE)
names(act_names) <- c('label', 'ActivityName')

ce_labeled <- combined_extracted %>%
  dplyr::inner_join(act_names, by = 'label')

########
## 4. Appropriately labels the data set with descriptive variable names.
#######

#identify time vs frequency variables
time_freq <- function(x) {
  fc <- substring(x, 1, 1)
  if (fc == 't') {
    out <-  paste0('Time_', substring(x, 2))
  } else if (fc == 'f') {
    out <-  paste0('Frequency_', substring(x, 2))
  } else {
    out <- x
  }

  out  
}

accel_gyro <- function(x) {
  x <- gsub('Acc', '_Accelerometer', x, fixed = TRUE)
  x <- gsub('Gyro', '_Gyroscope', x, fixed = TRUE)
  x <- gsub('Mag-', '_Magnitude-', x, fixed = TRUE)
  x <- gsub('-', '_', x, fixed = TRUE)
  
  x
}

names(ce_labeled) <- lapply(X = names(ce_labeled), FUN = time_freq) %>% unlist()
names(ce_labeled) <- lapply(X = names(ce_labeled), FUN = accel_gyro) %>% unlist()

########
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#######
final_data <- ce_labeled %>%
  dplyr::group_by(subject, ActivityName) %>%
  dplyr::summarize_each(funs(mean), matches('_'))

final_data_long <- tidyr::gather(
  data = final_data,
  subject, ActivityName, 
  `Time_Body_Accelerometer_mean()_X`:`Frequency_BodyBody_GyroscopeJerk_Magnitude_std()`
)

names(final_data_long)[3:4] <- c('measurement', 'mean_value')

## write the final text file
write.table(x = final_data, file = 'tidy_data_wide.txt', row.name=FALSE) 
write.table(x = final_data_long, file = 'tidy_data_long.txt', row.name=FALSE) 