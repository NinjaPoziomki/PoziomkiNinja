#library(R.matlab)
source("http://bioconductor.org/biocLite.R")

require(hgu95av2.db)
require(affy)
require(Biobase)
require(gahgu95av2.db)
require(annotate)
library(ggplot2)


#do Center i Scale dodajemy opcje: FALSE i TRUE
pca_klasteryzacja=function(newExprSet){

  exprSetPCA1 <- prcomp(t(newExprSet@assayData$exprs),center = F, scale. = T)
  
  #wykres punktowy
  
  # o? x
  x=exprSetPCA1[[1]]
  # o? y
  y=exprSetPCA1[[2]][1,]

  min_x=min(x)
  max_x=max(x)
  min_y=min(y)
  max_y=max(y)
  min_xy=min(min_y,min_x)
  max_xy=max(max_x,max_y)
  
  plot(min_xy:max_xy,min_xy:max_xy, xlab =  "X", ylab = "Y",type = "n", ylim=c(0,1))
  points(x[1:17],y[1:17],col="red")
  points(x[18:34],y[18:34],col="blue")
  color=c('red','blue')
  legend=c("ADENO","NORMAL")
  legend("topleft", legend, text.col="black",fill=color)
  title(main="Wykres przedstawiaj?cy analizowane pr?bki. Osie opisane s? przez 2 pierwsze sk?adowe.") 
  
  

  require("stats")
  require("graphics")
  require("vcd")
  require("convert")
  require("apply")
  require('heatmap.plus')
  require('vcd')
  require("genefilter")
  require("RColorBrewer")
  
  
  #przedstawi? w postaci wykresu s?upkowego udzia? 5 pierwszych sk?adowych g??wnych w zmienno?ci 
  #analizowanych danych. Na wykresie powinny znale?? si? warto?ci liczbowe odpowiadaj?ce kolejnym udzia?om.
  windows();
  barplot(exprSetPCA1$sdev[1:5], names.arg = colnames(exprSetPCA1$rotation)[1:5], xlab = "Principal Components")
  
  #Ord plot
  #The Ord plot plots the number of occurrences against a certain frequency ratio 
  #and should give a straight line if the data 
  #comes from a poisson, binomial, negative binomial or log-series distribution. 
  #The intercept and slope of this straight line conveys information about the 
  #underlying distribution.

  #wszystkie kombinacje wykres?w 2D sk?adowych g??wnych 
  #dla pierwszych 2 komponent?w na jednej figurze.
  
  obj_all=exprSetPCA1$x
  size=dim(obj_all)
  
  for (i in 1 : 2)
  {
    for (j in 1 : 2)
    {   
      obj_2 = matrix(nrow = 2, ncol = 34)
      obj_2[1,] = obj_all[i,]
      obj_2[2,] = obj_all[j,]
      windows();
      Ord_plot(t(obj_2), legend = TRUE, estimate = TRUE, tol = 0.1, type = NULL, main = "Wykres przedstawiaj?cy przyk?adow? kombinacje sk?adowych g??wnych dla pierwszych 2 komponent?w opartych o dyskretny rozk?ad prawdopodobie?stwa")
      Ord_estimate(obj_all, type = NULL, tol = 0.1)
    }
  }
 
}
