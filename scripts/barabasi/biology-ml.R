args <- commandArgs(TRUE)

library(caret)
library(ggplot2)
library(pROC)


fileToSave = args[1] #auc-file
#args[1] tranning file



dataNode2Vec = read.csv(args[2], header = FALSE, sep = " ", dec = ".")
colnames(dataNode2Vec)[1] <- "id"
print(head(dataNode2Vec))


#args[3] class file

dataUser = read.csv(args[3], header = TRUE, sep = ";", dec = ".")

print(head(dataUser))

data = merge(dataNode2Vec, dataUser, by = "id")



set.seed(825)
trainIndex <- createDataPartition(data$class2, p = .6, 
                                  list = FALSE, 
                                  times = 1)
dataTrain <- data[ trainIndex,]
dataTest  <- data[-trainIndex,]

print(head(data))
totalAttr = as.integer(args[4]) #dimensions
i = 2
form = "class2 ~ "
while(i <= (totalAttr + 1) ){
  v = paste("V", as.character(i), sep = "")
  form = paste(form, v)
  i = i + 1
  if(i <= (totalAttr + 1)) {
    form = paste(form, "+")
  }
}

print(form)

runModel = TRUE

if(runModel) {
  fitControl <- trainControl(## 5-fold CV
    method = "repeatedcv",
    number = 5, 
    classProbs = TRUE,
    summaryFunction = twoClassSummary,
    repeats = 10)  
  
  
  
  modelFit <- train(as.formula(form), data = dataTrain, 
                    method = "gbm",  
                    trControl = fitControl,
                    #tuneGrid = grid,
                    metric = "ROC",
                    verbose = FALSE)
  print(modelFit)
  
  
  
  
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