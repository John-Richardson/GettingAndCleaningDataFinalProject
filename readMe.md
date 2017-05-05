# Tidy UCI HAR DataSet

John Richardson

## Summary

This project contains an R script that can be run against the UCI HAR DataSet (Human Activity Recognition Using Smartphones Dataset). This script creates a tidy form of the data in memory and outputs a file that contains the mean values of means and standard deviations found in the UCI HAR dataset.

Details of the original data and project can be found here

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original data can be obtained here

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This project and files were used as the final peer reviewed project of the coursera course "Getting and Cleaning Data" offered by John Hopkins University. 

https://www.coursera.org/learn/data-cleaning/home/welcome

## Some specific details:

The feature names are taken as they found in the orginal dataset. See the original dataset readme.txt, and features_info.txt files for specifics. Note that in some cases the exact names of the features are duplicated in the original dataset, so they have been prefixed by their ordinal position so as to avoid duplicates. 

## Instructions:

### Creating the tidy data file

Unzip the UCI data into a folder on your system.
Place the run_Analysis.R file in that folder
Set that folder as your working directory
The tidy data set will be produced into that folder in a file called "TidyDataSet"

### Reading in the tidy data file

You can read in the file directly using the following R snippet

data<-read.table("TidyDataSet", header = TRUE, check.names = FALSE)

View(data)
