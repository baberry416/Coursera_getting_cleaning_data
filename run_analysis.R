####################################
# Coursera - Getting and Cleaning Data - Class project
# Brian Berry (brian.a.berry@protonmail.ch) April 2015
#
# Problem description from --
# https://class.coursera.org/getdata-013/human_grading/view/courses/973500/assessments/3/submissions
#
# Purpose - get and clean experimental data from the UCI Human Activities Recognition project.
# ---------
#
# Input - multiple (messy) datasets from UCI HAR; A "readme" file from UCI HCR that partially explains the data.
# ------
#
# Output 
# ------
# - combined, tidied up dataset "tidy_data.txt" with the means by subject and activity, with usable labels. 
# - R script to get the tidy dataset from the raw data.
# Also included - a README.MD and a Codebook and explains the steps.
# 
####################################
#
#-------------check that package (dplyr) is installed ----------

if (!require ("dplyr")) {install.packages ("dplyr"); library ("dplyr")}

#--------- Getting the Data-----------------
#  Check if the data directory (download destination) exists and if not, create it.
#  Check if the zip file exists. If not - download from the source 
#  and record the date / time as a trace of what version of the data was used.

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists ("./data")) {dir.create ("./data")} 

if (!file.exists ("./data/data.zip")) {
        download.file(data_url, destfile="./data/data.zip", method="curl")
        download_date <- date()
        write (c("UCI HAR Data Downloaded at", download_date), file="./download_log.txt", append=TRUE)      # record download date, time 
}

# unzip data. Goes to dir "./data/UCI HAR Dataset"
unzip ("./data/data.zip", exdir="./data", overwrite=TRUE)

# read the "features" table, then clean it up to use as variable names for the data.
# cleanup consists of -
#       -eliminate "(" and ")" which are illegal in variable names.
#       -drop "-" 
#       - drop "."
#       - drop ","
#       -convert all text to lower case
#       -change leading "t" to "time"
#       -change leading "f" to "frequency"
#       

features <- read.table("./data/UCI HAR Dataset/features.txt", col.names=c("id", "var_name"))

#                    
features$var_name <-    gsub ("\\(", "",                               # drop "("
                        gsub ("\\)", "",                               # drop ")"
                        gsub ("-", "",                                 # drop "-"
                        gsub ("\\.", "",                               # drop "."
                        gsub ("\\,", "",                               # drop ","
                        tolower(features$var_name ) ) ) ) ) )          # lower case

features$var_name <-    gsub ("^t", "time",                            # "t" to "time"
                        gsub ("^f", "frequency", features$var_name))   # "f" to "frequency"

features$var_name <-    gsub ("BodyBody", "Body", features$var_name)   # change "BodyBody" to "Body"

        
# read test data to R data frames. Use "features" as col.names for the data.
test_subject  <- read.table ("./data/UCI HAR Dataset/test/subject_test.txt", col.names ="Subject")
test_activity  <- read.table ("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
test_data      <- read.table ("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$var_name)

# read train data to R data frames. Use "features" as col.names for the data.
train_subject  <- read.table ("./data/UCI HAR Dataset/train/subject_train.txt", col.names ="Subject")
train_activity  <- read.table ("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
train_data      <- read.table ("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$var_name)

# read the activity number-to-description table.
activity_labels <- read.table ("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("Number", "Description") )


# ---------------------Combining the data ----------------
# combine test data into one data frame
test_combined <- cbind (test_subject, test_activity, test_data)

# combine train data into one data frame
train_combined <- cbind (train_subject, train_activity, train_data)

# combine test and train data frames into a dplyr data frame.
combined_data <- tbl_df( rbind (test_combined, train_combined) )


#------------------- Use descriptive activity names ----------
combined_data ["Activity"] <- activity_labels [ combined_data$Activity, "Description" ]

#------------------- Reduce to only "mean" and "std" variables ----
# select (dplyr) the columns whose names contain strings "mean" and "std", plus Subject and Activity
combined_data <- select ( combined_data, Subject, Activity, contains ("mean"), contains ("std") ) 

#-------------------Summarize data into a separate "tidy" dataset ---------------
# summarize (dplyr) data average for each variable, for each subject and activity
tidy_data <- combined_data                          # create a separate dataset.
tidy_data <- tidy_data  %>%
	        group_by(Subject, Activity)  %>%    # group (dplyr) the rows by Subject then Activity 
                summarise_each (funs(mean))         # summarise (dplyr) all variables


# write out tidy dataset. Note - using " " as separator.

write.table(tidy_data, file="tidy_data.txt", sep=" ", row.name=FALSE)

#
