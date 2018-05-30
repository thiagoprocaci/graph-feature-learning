library(caret)
library(ggplot2)

dataNode2Vec = read.csv("bio-dfs-2-directed.emd", header = FALSE, sep = " ", dec = ".")
colnames(dataNode2Vec)[1] <- "id"

dataUser = read.csv("bio.users_profile_1", header = TRUE, sep = ";")

data = merge(dataNode2Vec, dataUser, by = "id")
index = 1
while(index <= nrow(data)) {
  row = data[index, ]
  if(row$profile_1 == 4) {
    data[index, "class"] = 'outstanding'
  } else {
    data[index, "class"] = 'ordinary'
  }
  index = index + 1
}


set.seed(825)
trainIndex <- createDataPartition(data$class, p = .6, 
                                  list = FALSE, 
                                  times = 1)
dataTrain <- data[ trainIndex,]
dataTest  <- data[-trainIndex,]



runModel = TRUE

if(runModel) {
  fitControl <- trainControl(## 5-fold CV
    method = "repeatedcv",
    number = 5, 
    classProbs = TRUE,
    summaryFunction = twoClassSummary,
    repeats = 10)  
  
  
  
  modelFit <- train(class ~ V2 + V3 + V4 + V5 + V6, data = dataTrain, 
                    method = "gbm",  
                    trControl = fitControl,
                    #tuneGrid = grid,
                    metric = "ROC",
                    verbose = FALSE)
  print(modelFit)
  
  print("Prediction")
  predictions <- predict(modelFit, newdata = dataTest)
  
  cm = confusionMatrix(predictions, dataTest$class)
  
  print(cm)
  
  precision <- cm$byClass['Pos Pred Value']    
  recall <- cm$byClass['Sensitivity']
  
  print("F-measure")
  print((2 * precision * recall)/(precision + recall))
  
  trellis.par.set(caretTheme())
  print(plot(modelFit, metric = "ROC"))
  
  print(plot(modelFit, metric = "ROC", plotType = "level",
             scales = list(x = list(rot = 90))))
  
  
}