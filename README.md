# Getting and Cleaning Data Course Project
The purpose of this project is to collect, work with, and clean a data set. 

#Transformation of the data
The raw data was transformed in the following way:
1. The feature vector X, the subject vector and the activity vector Y for the training and test sets are loaded
2. The training and test vectors are merged
3. The subjects, the activities and their related feature vectors are merged into a single data table
4. The featur vector columns are renamed
5. The columns are filtered based on their name. They are kept only if they contain mean() or std()
6. The values of the activities are replaced by their description
7. The columns are renamed to be more explicit
8. A smaller dataset is created by aggregating the data by subjet and activity. Each couple subjet, activity has a single feature vector
9. The result table is exported in the export.txt file