# Codebook
## Subject - Course Project - Coursera "Getting and Cleaning Data" course, session "getdata-013" April 2015 
## Author - Brian Berry (brian.a.berry@protonmail.ch) 

### Input Files 
The input is read from URL "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
The component files are described in the Readme files included with the data.

### Description 
All analysis is done without altering the original data. The output of the analysis is "tidy_data.txt"

### Reading Data
Once the data has been unzipped, all the necessary files are read into R data frames.

### Variable Name Cleanup 
The names of the variables are in the file "features.txt". The script cleans these by --
* dropping all illegal characters ( left and right brackets, commas and periods );
* dropping  the dash;
* putting all variable names into lower case;
* converting leading "t" character is converted to "time";
* converting leading "f" converted to "frequency";
* correcting the string "BodyBody" (apparently a typo) to "Body".

### Data combining 
The data frames for "test" are combined together. The data frames for "train" are combined together.
In each case the Subject and Activity become columns to the left of the data.
Then the two data frames are row combined.

The activity names replace the activity numbers.

### Data Reduction
The dplyr package is use to --
* select the columns for mean and std (as well as Subject and Activity), dropping all the others;
* group the data by Subject, then Activity;
* summarise all variables with the mean function.

### Data Output
The resulting  tidy data is written to the file "tidy_data.txt" in the working directory. The separator is " ".
Row.names is set to FALSE.


	