bs=function(ExprSet,sel_params,c_method,arg){
  
  
  
  library(foreach)
  tidx<-foreach(i=1:arg) %do%
  {
    train_idx=sample(1:nrow(ExprSet@phenoData@data),replace=TRUE)
  }
  
  
  sel<-foreach(i=1:arg) %do%
{
  E=ExprSet[,as.numeric(tidx[[i]])]
  d_genes=sum_table(E,sel_params)
  sel=data_prep(E,d_genes)
}
   


TABS<-foreach(i=1:arg) %do%
{
do.call(c_method,list(sel[[i]],tidx[[i]]))
}


  
 # TABS=sapply(args, c_method)
  
 # rownames(TABS)=c('sensitivity','specificity','accuracy','error')
 
  return(TABS)
}