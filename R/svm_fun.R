svm_fun<- function(sel,train_idx){
  
  
  test=sel[-train_idx,]
  train=sel[train_idx,]

  require(e1071) 
  svm.data <- svm(class ~ ., data = train) 
  
  cl<-predict(svm.data, test)
  comp=table(cl,test[,ncol(test)])
  
  q=Q(comp)
  q=list(q,comp)
  
  return(q)
  
}