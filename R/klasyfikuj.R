#to jest lista przykladowych parametrow z funkcji Agaty
#sel_params=data.frame('BH','p_val',0.05,10,stringsAsFactors=F)

#arg : dla 'bs'- liczba powtorzen, dla 'simple' odstek w zbiorze uczacym (0-1)
##v_method bs- BOOTSTRAP, 'simple'- pojedynczy k fold, 'l_one_out' leave one out

#c_method : svm_fun, lda_fun
#wszystko idzie na parametrach domyslnych 
#WYWoLANIE FUNKCJI DO TESTOW:
#zaimportuj "var.RData" i wywolaj na przyklad:
#klasyfikuj(sel_params,ExprSet,'lda_fun','bs',2)





klasyfikuj=function(sel_params,ExprSet,c_method,v_method,arg){

#sel_params:wektor: method,kryterium,wartosc,liczba_wynikow 
  
  

  source("sum_table.R")
  source("data_prep.R")
  
  source("lda_fun.R")
  source("svm_fun.R")
  
  source("l_one_out.R")
  source("simple.R")
  source("bs.R")

  
  source("Q.R")
  source("r_prep.R")
  
if (v_method=='l_one_out')
  temp_results=do.call(v_method, list(ExprSet,sel_params,c_method))
else
  temp_results=do.call(v_method, list(ExprSet,sel_params,c_method,arg))

results=r_prep(temp_results)

 
return(results)
}
