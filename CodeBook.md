## Data Set Code Book: Human Activity Recognition Dataset


December 26, 2015
Codebook prepared by Andrew Martin, based on data set he obtained from the Coursera `Human Activity Recognition Using Smartphones Dataset` [files](
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The data file contains records for 10299 observations from 30 distinct subjects.

Field label: subject
Variable: Subject Number
Variable type: Integer
Allowable values: 1-30
Comments: Represents the unique subject who generated the data.

Field label: ActivityName
Variable: Activity Name
Variable type: Character
Allowable values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
Comments: Represents the activity state reported by the subject when the data was obtained.

Field label: measurement
Variable: Measurement
Variable type: Character
Allowable values: see `features.txt` for the 561 possible measurements.
Comments: This is a tidy dataset, where each variable is recorded in one row.  The 561 measurements represent different data points from the accelerometer and gyroscope.

Field label: mean_value
Variable: Mean Value
Variable type: Numeric
Allowable values: Features are normalized and bounded within (-1,1)
Comments: Each of these values represents the mean value for the measurement for the subject/activity pairing shown.  

 