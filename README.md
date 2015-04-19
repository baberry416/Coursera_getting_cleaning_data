# README
## Subject - Course Project - Coursera "Getting and Cleaning Data" course, session "getdata-013" April 2015 
## Author - Brian Berry (brian.a.berry@protonmail.ch) 

## Repository Contents

### tidy_data.txt
The file contains the output of the analysis. The separator is set to " ". Row.names is set to FALSE.

### run_analysis.R
The R script to go from the raw dataset from the specified URL to the "tidy_data.txt" dataset.
The steps are described in the associated Codebook.md file.

### README.md
This file.

### Codebook.md
The description of the steps implemented in the R script to get from the input dataset to the "tidy_data.txt" dataset.

### Packages, Directories and Files changed
The R script "run_analysis.R"
* checks the package "dplyr". The package is installed if it is not already present;
* checks if the directory "./data" exists and if not it creates it. All input data is kept in this directory;
* checks if the input dataset zip file exists. If it does not, it is downloaded from the URL provided;
* unzips the input data, overwiting existing files;
* logs (appends) the data and time of the download to the file "download_log.txt" in the working directory. 
* writes the "tidy_data.txt" output dataset to the working directory. 

