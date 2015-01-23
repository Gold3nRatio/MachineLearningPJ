## Machine Learning Project
## This project's goal is to predict how each participant perform the excercise.

fileLoc <- '/home/eric/Documents/Codes/machLearnPJ/'
data <- read.csv(paste0(fileLoc, 'data/pml-training.csv'))

# see the structure of the data
# str(data)
# dim(data)

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

# partition the data into training and testing set for cross-validatoin
set.seed(11235)
# inTrain = createDataPartition(dt$classe, p = 3/4)[[1]]
# training = dt[ inTrain,]
# testing = dt[-inTrain,]
# 
# # size of each
# dim(training)
# dim(testing)

# train the dataset using Random Forest
rf1 <- randomForest(classe ~ ., data=dt)

# oob sample error
mean(rf1$err.rate)

# #### testing the variables #### 
# vrImp <- data.frame(importance(rf1))
# sl <- sort(vrImp$MeanDecreaseAccuracy, decreasing=TRUE, index.return=TRUE)
# top10 <- head(row.names(vrImp[sl$ix,]), 10)
# top20 <- head(row.names(vrImp[sl$ix,]), 20)
# top30 <- head(row.names(vrImp[sl$ix,]), 30)
# top35 <- head(row.names(vrImp[sl$ix,]), 35)

# result <- rfcv(dt[,-ncol(dt)], dt[,ncol(dt)], cv.fold=3)

# #### train a different levels of variables ####
# dt10 <- cbind(dt[names(dt) %in% top10], classe=data$classe)
# dt20 <- cbind(dt[names(dt) %in% top20], classe=data$classe)
# dt30 <- cbind(dt[names(dt) %in% top30], classe=data$classe)
# dt35 <- cbind(dt[names(dt) %in% top35], classe=data$classe)
# 
# rf10 <- randomForest(classe ~ ., data=dt10)
# rf20 <- randomForest(classe ~ ., data=dt20)
# rf30 <- randomForest(classe ~ ., data=dt30)
# rf35 <- randomForest(classe ~ ., data=dt35)
# 
# # predit on the test set
# pre1 <- predict(rf1, testing)
# pre2 <- predict(rf2, testing)
# pre3 <- predict(rf3, testing)
# data.frame(pre1 = sum(testing$classe == pre1) / length(testing)
#            , pre2 = sum(testing$classe == pre2) / length(testing)
#            , pre3 = sum(testing$classe == pre3) / length(testing))


# save the object
save(rf1, file=paste0(fileLoc, 'data/wgtliftRF.RData'))






