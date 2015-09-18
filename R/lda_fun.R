lda_fun<- function(sel,train_idx){
  
  
  test=sel[-train_idx,]
  train=sel[train_idx,]
  
  require(MASS) 
  lda.data <- lda(class ~ ., data = train) 
  
  
  cl<-predict(lda.data, test)$class
  
  comp=table(cl,test[,ncol(test)])
  q=Q(comp)
  q=list(q,comp)
  
  return(q)
}