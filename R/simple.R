simple=function(ExprSet,sel_params,c_method,arg){
  
  #arg- odsetek w zbiorze uczacym 0-1
  N<-nrow(ExprSet@phenoData@data)
  N_train=round(N*arg)
  
  
  
  tidx<-sample(1:N,N_train,replace=T)


  E=ExprSet[,as.numeric(tidx)]
  d_genes=sum_table(E,sel_params)
  sel=data_prep(ExprSet,d_genes)




  TABS<-do.call(c_method,list(sel,tidx))


return(TABS)
}