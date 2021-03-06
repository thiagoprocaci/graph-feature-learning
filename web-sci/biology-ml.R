library(caret)
library(ggplot2)
library(pROC)


fileToSave = "biology-directed-node2vec-bfs-1-auc"

dataNode2Vec = read.csv("biology-directed-bfs-1.emd", header = FALSE, sep = " ", dec = ".")
colnames(dataNode2Vec)[1] <- "id"


dataUser = read.csv("biology.class.csv", header = TRUE, sep = ";", dec = ".")

data = merge(dataNode2Vec, dataUser, by = "id")



set.seed(825)
trainIndex <- createDataPartition(data$class2, p = .6, 
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
  
  
  
  modelFit <- train(class2 ~ V2 + V3 + V4 + V5 + V6, data = dataTrain, 
                    method = "gbm",  
                    trControl = fitControl,
                    #tuneGrid = grid,
                    metric = "ROC",
                    verbose = FALSE)
  print(modelFit)
  
print(head(data))
  
  
  
  print("Prediction")
  predictions <- predict(modelFit, newdata = dataTest)
  
  cm = confusionMatrix(predictions, dataTest$class2)
  
  print(cm)
  
  precision <- cm$byClass['Pos Pred Value']    
  recall <- cm$byClass['Sensitivity']
  
  print("F-measure")
  print((2 * precision * recall)/(precision + recall))
  
  #trellis.par.set(caretTheme())
  # print(plot(modelFit, metric = "ROC"))
  
  # print(plot(modelFit, metric = "ROC", plotType = "level",
  #            scales = list(x = list(rot = 90))))
  
  predictions <- predict(modelFit, newdata = dataTest, type = "prob")
  r = roc(dataTest$class2, predictions[[2]])
  print(r$auc)
  
  
  write(r$auc, file = fileToSave, append = FALSE)
  
}