
require(hgu95av2.db)
require(affy)
require(Biobase)
require(gahgu95av2.db)
require(annotate)


normalization=function(normaliz_met, dane){
  
if (normaliz_met=='MAS'){
  normalizacja= expresso(
    dane,
    # background correction
    bg.correct = FALSE,
    bgcorrect.method = "mas",
    # normalize
    normalize = FALSE,
    normalize.method = "constant",
    # pm correction
    pmcorrect.method = "mas",
    # expression values
    summary.method = "mas")
}


if (normaliz_met=='RMA'){
  normalizacja=expresso(
    dane,
    # background correction
    bg.correct = TRUE,
    bgcorrect.method = "rma",
    # normalize
    normalize = TRUE,
    normalize.method = "quantiles",
    # pm correction
    pmcorrect.method = "pmonly",
    # expression values
    summary.method = "medianpolish"
)
}
dataRMA=exprs(normalizacja)
return(dataRMA)

}

CreateExprSet=function(dataRMA, namefile){
  names<-read.AnnotatedDataFrame(namefile,header=TRUE,sep="\t",row.names=4,stringsAsFactors=F)
  cels<-names[c(1:17,211:227),]
  sampleNames(cels)<-paste(sampleNames(cels),'.CEL',sep="")
  
  experiment= new("MIAME", name="Dane mikromacierzowe", lab="WSP", title="Dane testowe")
  ExprSet = new("ExpressionSet", expr = dataRMA, phenoData = cels, experimentData=experiment, annotation = "gahgu95av2.db")
  return(ExprSet)
}


#  plots=function(dataRMA, dane){
# ########### adeno ##############
# 
# hist1adeno= hist(dane[c(1:17),],main="Histogram przedstawiaj¹cy dane nieznormalizowane dla adeno")
# box1adeno = boxplot(dane[c(1:17),], main="Wykres pude³kowy dla danych nieznormalizowanych  adeno")
# 
# ######### NORMAL ##########################
# 
# hist1normal= hist(dane[c(18:34),],main="Histogram przedstawiaj¹cy dane nieznormalizowane dla NORMAL")
# box1normal = boxplot(dane[c(18:34),], main="Wykres pude³kowy dla danych nieznormalizowanych NORMAL")
# 
# ################################### wyrysowanie Wykresu degradacji #############################
# deg_normal = plotAffyRNAdeg(AffyRNAdeg(dane[c(18:34),]));
# deg_adeno = plotAffyRNAdeg(AffyRNAdeg(dane[c(1:17),]));
# 
# 
# ########################## wyrysowanie plotow danych po normalizacji ##########
# 
# hist2adeno = plotDensity(dataRMA[,c(1:17)], main='Histogram z danymi znormalizowanymi dla ADENO')
# box2adeno = boxplot(dataRMA[,c(1:17)], main="Wykres pude³kowy dla danych znormalizowanych Adeno")
# hist2normal = plotDensity(dataRMA[,c(18:34)], main='Histogram z danymi znormalizowanymi dla NORMAL')
# box2normal = boxplot(dataRMA[,c(18:34)], main="Wykres pude³kowy dla danych znormalizowanych Normal")
# 
# 
# plotList=list(hist1adeno, box1adeno, hist1normal, box1normal, hist2adeno, box2adeno, hist2normal, box2normal)
# return(hist1adeno)
# 
# }


