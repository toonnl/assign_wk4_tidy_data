# load libraries
library(dplyr)
library(tidyr)

# load ZIP file
if(!file.exists("./Data")){dir.create("./Data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Data/UCI_HAR_Dataset.zip",method="curl")
unzip("./Data/UCI_HAR_Dataset.zip", overwrite = TRUE)

# read training files
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE ,stringsAsFactors = FALSE)
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt",sep = "", header = FALSE ,stringsAsFactors = FALSE, strip.white = TRUE)
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE, header = FALSE)
features<-read.fwf("./UCI HAR Dataset/features.txt",widths = 35 ,header = FALSE , stringsAsFactors = FALSE)
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, header = FALSE)

# Unique ID and training labels in first column and replace for names
ID<-seq(1, length(y_train[,1]))
type<-rep("train",length(y_train[,1]))
train_data<-cbind(ID,subject_train ,type, y_train, X_train)

# make features column names in X_train
features<-c(substring(features$V1[1:9],3),substring(features$V1[10:99],4),substring(features$V1[100:length(features$V1)],5))
features<-gsub("\\.","_",features)
features<-gsub("\\,","_",features)
features<-gsub("\\-","_",features)
features<-make.unique(features,sep = "_")
colnames(train_data)<-c("ID","subject","type","activity",features)

# replace label numbers for activity names in train_data
colnames(activity_labels)<-c("activity","label_name")
train_data<-merge(train_data,activity_labels) 
train_data<-train_data %>% mutate(activity=label_name) %>% select(-label_name) %>% arrange(ID)

# read test files
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE ,stringsAsFactors = FALSE)
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt",sep = "", header = FALSE ,stringsAsFactors = FALSE, strip.white = TRUE)
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE, header = FALSE)

# Unique ID and test labels in first column and replace for names
ID<-seq((length(y_train[,1])+1), (length(y_train[,1])+length(y_test[,1])))
type<-rep("test",length(y_test[,1]))
test_data<-cbind(ID,subject_test ,type, y_test, X_test)

# make features column names in X_test
colnames(test_data)<-c("ID","subject","type","activity",features)

# replace label numbers for activity names in test_data
test_data<-merge(test_data,activity_labels) 
test_data<-test_data %>% mutate(activity=label_name) %>% select(-label_name) %>% arrange(ID)

# merge train en test data as rows
total_data<-rbind(train_data,test_data)

# select only first columns and columns with std() or mean() or meanFreq()
stdmean_data<-select(total_data, c("ID","activity","subject","type",contains("std()"),contains("mean()"),contains("meanFreq()")))

# create tidy_data set with avarage of every variable, grouped by activity and subject and save tidy_data in file
tidy_data<-stdmean_data %>% group_by(activity,subject) %>% summarise_at(vars(c(contains("std()"),contains("mean()"),contains("meanFreq()"))),mean, na.rm = TRUE)
colnames(tidy_data)<-gsub("[()]","",names(tidy_data))
write.table(tidy_data, file = "tidy_data_assignmentwk4.txt", row.names = FALSE)