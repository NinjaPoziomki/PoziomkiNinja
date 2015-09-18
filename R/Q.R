
Q=function(comp)
{
  
  TP=comp[1,1]
  TN=comp[2,2]
  FN=comp[2,1]
  FP=comp[1,2]
  N=sum(comp)
  
  sensitivity = 100*(TP/(TP+FN))
  specificity =100*(TN/(TN+FP))
  accuracy =100*((TP+TN)/N)
  error = 100*((FP+FN)/N)
  
  q=c(sensitivity,specificity,accuracy,error)
  return(q)
}