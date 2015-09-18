r_prep=function(temp_results){
  
  
  sum_t=temp_results[[1]][[2]]
  sum_c=temp_results[[1]][[1]]
  
  if(sum(sum_t)==1)
  {
    for (i in 2:length(temp_results))
    {
    sum_t=sum_t+temp_results[[i]][[2]]
    }
  
     results=Q(sum_t)
  }
  
  if(length(temp_results[[2]])==4)
    results=temp_results[[1]]
    
  
  if (sum(sum_t)!=1 && length(temp_results[[2]])!=4)
      {
        for (i in 2:length(temp_results))
        {
        sum_c=sum_c+temp_results[[i]][[1]]
        }
        
    results=sum_c/length(temp_results)
    
  }
  
  results=as.data.frame(results)
  rownames(results)=c("sensitivity","specificity","accuracy","error")
  
  return(results)
}