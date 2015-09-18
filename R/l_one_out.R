l_one_out=function(ExprSet,sel_params,c_method){
  
  
  
  require(foreach)
  
N=nrow(ExprSet@phenoData@data)

tidx<-foreach(i=1:N) %do%
{
  train_idx=1:N
  train_idx=train_idx[-i]
}


sel<-foreach(i=1:N) %do%
{
  E=ExprSet[,as.numeric(tidx[[i]])]
  d_genes=sum_table(E,sel_params)
  sel=data_prep(ExprSet,d_genes)
}



TABS<-foreach(i=1:N) %do%
{
  do.call(c_method,list(sel[[i]],tidx[[i]]))
}



# TABS=sapply(args, c_method)

# rownames(TABS)=c('sensitivity','specificity','accuracy','error')

return(TABS)
}