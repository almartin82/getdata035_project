# getdata035_project
repo for Coursera 035 Getting and Cleaning Data course project

# how run_analysis.R works
From the helpful [writeup](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/) linked to (and suggested by course TAs), we can ignore the `Inertial Signals` folders.

Before doing any data cleaning, I pulled in the data from the zip archive and unzipped it to a temp directory.

I read in the `test` and `train` data, and added the labels and subject files to the main data set.  I used the `features.txt` file to label all of the 565 variables per observation.

I combined them using `rbind()`.

Then I used text processing functions to create a logical vector of variables that were means or standard deviations.  I subsetted to only include those columns, and the activity / subject names.

I converted the activity labels into names by using a dplyr::inner_join, and converted the variable names into descriptive names, using  information from `features.txt`.  To convert the abbreviations into descriptive names, I wrote processing functions and applied them to the `names()` of the data frame using `lapply()`.

To tidy the data set, I used dplyr to group the data into subject/activity groups, and then summarized each of the variables using `summarize_each()`.  This created a wide tidy data set; to make the wide data set long, I used `tidyr::gather().`