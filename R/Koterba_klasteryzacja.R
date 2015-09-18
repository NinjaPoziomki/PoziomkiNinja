##################################Klasteryzacja hierarchiczna#####################
klasteryzacja_hierarchiczna=function(ExprSet, c_method) {
  x=ExprSet@assayData$exprs
  distance = dist(t(x))
  image(as.matrix(distance))
  
  if(c_method == 'average')
    hc = hclust(distance, method = 'average')
  else if(c_method =='complete')
    hc = hclust(distance, method = 'complete')
  else if(c_method =='centroid')
    hc = hclust(distance, method = 'centroid')
    
   return(hc)

  
}


#################################### Heatmap ####################################
# library(estrogen)
# rsd=apply(exprs(ExprSet), 1, sd)
# sel=order(rsd, decreasing = TRUE)[1:50]
# 
# heatmap(exprs(normRMA_NORMAL)[sel, ], col = gentlecol(256))
# dev.off()

