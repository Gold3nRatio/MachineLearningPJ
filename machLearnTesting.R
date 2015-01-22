## Data Science Machine Learning

## This script uses the RF object from the training data to
## test the testing files.

## remove all the files and objects
rm(list=ls())

## change the working directory
fileLoc <- '/home/eric/Documents/Codes/machLearnPJ/'
setwd(fileLoc)

## load the random forest object from the training data
load(paste0(fileLoc,'data/wgtliftRF.rdata'))

## read the testing files
data <- read.csv(paste0(fileLoc, 'pml-testing.csv'))

## predit the test files
pre1 <- predict(rf1, data)

## function to write the files
pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0(fileLoc, 'output/', "problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}

pml_write_files(pre1)

