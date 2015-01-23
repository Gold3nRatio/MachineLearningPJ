---
title: "Predicting Exercise Class"
output: html_document
---


## Summary
With modern technology, large amount of data regarding personal activity are now available for analytic.  This report analyzed a set of data from [Groupware's Human Activity Recognition project](http://groupware.les.inf.puc-rio.br/har).  The project had each participant perform various dumbbell exercise, primary to test how well they perform the exercise.  There are five classes captured: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).  The goal is to create a machine learning model to correct predict the class base on a set of variables.

For the prediction model, the Random Forest algorithm was used.  The model was picked due to its plethora features.  Not surprisingly, the model produced very good results.  In the class test cases, it produced 100% accuracy.

## Data Cleaning
The data was partition into two datasets: [training](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv) and [test](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv).  The analysis will focus primarily on the training dataset.  

First glance on the training data, it contains many columns.  Additionally, many of the columns contained no data.  Due to the dataset's size, it is wise to remove these columns before performing the train.  

```{r, eval=FALSE}
fileLoc <- '/home/Codes/machLearnPJ/'
data <- read.csv(paste0(fileLoc, 'data/pml-training.csv'))
# create data frame to show the number of NA's each column has
nadf <- data.frame(nacount = colSums(is.na(data)))
# find the columns with at least half of its entries are NA's
nacol <- row.names(nadf)[c(nadf$nacount > nrow(data)/2)]
# remove those columns and create a new data frame
dt <- data[!names(data) %in% nacol]
```

Also removing time/date variables, assuming work out is independent of the time performed, then changed the variables to numeric.  Secondly, add the class variable back into the data frame.  Finally, the data frame is ready for model training.
```{r, eval=FALSE}
dt <- dt[, c(-1:-7, -(ncol(dt)))]
a <- data.frame(lapply(dt, as.character), stringsAsFactors=FALSE)
b <- data.frame(lapply(a, as.numeric))
nadf <- data.frame(nacount = colSums(is.na(b)))
nacol <- row.names(nadf)[c(nadf$nacount > nrow(data)/2)]
b <- b[!names(b) %in% nacol]
dt <- cbind(b, classe=data$classe)
```

## Model Training
One R packages were used to train the model: [randomForest](http://cran.r-project.org/web/packages/randomForest/index.html).  The randomForest package was used to train the dataset due to its speed of operation.
```{r, eval=FALSE}
library(randomForest)
set.seed(11235)
# train the dataset using Random Forest
rf1 <- randomForest(classe ~ ., data=dt)
# save the prediction model object
save(rf1, file=paste0(fileLoc, 'data/wgtliftRF.RData'))
```

### Out-of-bag Error Estimate
There is no need to perform cross-validation on a separate test set to get an estimate on the error rate while performing random forest.  This is due to the feature in random forest.  While constructing each tree, random forest automatically set aside one-third of the cases.  Random forest then use those left outs to calculate the out-of-bag error estimate.  According to Breiman and Cutler, the estimate is also proven to be bias.

``` {r, echo=FALSE}
## remove all the files and objects
rm(list=ls())
fileLoc <- '/home/eric/Documents/Codes/machLearnPJ/'
setwd(fileLoc)
load(paste0(fileLoc,'data/wgtliftRF.rdata'))
```
From the random forest result, the expected error rate is `r round(100*mean(rf1$err.rate), 2)`%, which is obtain from `mean(rf1$err.rate)`.

For additional information on how the random forest works, please visit the [Berkeley.edu](https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr) website.

## Appendix
### Codes for Analysis
```{r, eval=FALSE}
## Machine Learning Project
## This project's goal is to predict how each participant perform the excercise.
fileLoc <- '/home/Codes/machLearnPJ/'
data <- read.csv(paste0(fileLoc, 'data/pml-training.csv'))

# find columns with all NA's and remove
nadf <- data.frame(nacount = colSums(is.na(data)))
nacol <- row.names(nadf)[c(nadf$nacount > nrow(data)/2)]
dt <- data[!names(data) %in% nacol]

# remove some variables (timestamps) not needed, assume work out is independent
# of time performed, then change the variables to numeric.  Finally, add the 
# classe variable back in
dt <- dt[, c(-1:-7, -(ncol(dt)))]
a <- data.frame(lapply(dt, as.character), stringsAsFactors=FALSE)
b <- data.frame(lapply(a, as.numeric))
nadf <- data.frame(nacount = colSums(is.na(b)))
nacol <- row.names(nadf)[c(nadf$nacount > nrow(data)/2)]
b <- b[!names(b) %in% nacol]
dt <- cbind(b, classe=data$classe)

# remove the not needed variables
rm(list =setdiff(ls(), c('fileLoc', 'data', 'dt')))

# load the require libraries
# library(caret)
library(randomForest)

set.seed(11235)
# train the dataset using Random Forest
rf1 <- randomForest(classe ~ ., data=dt)

# oob sample error
mean(rf1$err.rate)

# save the object
save(rf1, file=paste0(fileLoc, 'data/wgtliftRF.RData'))
```

## Reference
Breiman, Leo, and Adele Cutler. "Random Forests Leo Breiman and Adele Cutler." Random Forests. N.p., n.d. Web. 21 Jan. 2015.

Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.