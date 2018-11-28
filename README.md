# assign_wk4_tidy_data
Assignment of Getting and Cleaning Data Course Project week 4

# Main function
Main function of "run_analysis.R" is to deliver a tidy dataset with the avarage of the mean and standard deviation values of train en test data, obtained from movement measurements recorded with a Samsung smartphone.

# Detailed function of the "run_analysis.R" script:
- load needed libraries and load ZIP file with datasets
- unpack all files
- read training files
- Create column with unique ID (for sorting and normilization) and combine train data with labels and subjects
- make features-names the column names in train_data
- replace label numbers for descriptive label names in train_data
- read test files
- Create column with unique ID (for sorting and normilization) and combine test data with labels and subjects
- make features-names the column names in test_data
- replace label numbers for descriptive label names in test_data
- merge train and test data as rows and create variable with value "train" and "test"
- select only first columns for ID, label/activity, subject, type and columns with std() or mean() or meanFreq()
- create tidy_data set with avarage of every variable, grouped by label/activity and subject
- save tidy_data in file "tidy_data_assignmentwk4.txt"
