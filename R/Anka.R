#preprocessing = function(data, normalize_met=NULL) {
  
source("http://www.bioconductor.org/biocLite.R")
biocLite('affy')
library(affy);
biocLite('Biostrings')
library(Biostrings)

setwd('C:/Users/Anka2/Desktop/Studia_s1_s2/WSP/wsp')

data=data[c(1:17,211:227),]
opis=read.AnnotatedDataFrame("datasetA_scans.txt",header=T,sep="\t",row.names=4,stringsAsFactors=F)

opis=opis[c(1:17,211:227)]
sampleNames(opis)=paste(sampleNames(opis),".CEL",sep="")

data_Affy=ReadAffy(filenames=sampleNames(opis),verbose=T)

data_Affy@cdfName=paste("ga",data_Affy@cdfName,sep="")
data_Affy@annotation=paste("ga",data_Affy@annotation,sep="")

#####wykresy#####

attach(mtcars)
par(mfrow=c(2,2))
hist(data_Affy, main='skala logarytmiczna, przed normalizacja')
hist(data_Affy, main='skala liniowa, przed normalizacja',log=F)
boxplot(data_Affy)
data_Affy_deg=AffyRNAdeg(data_Affy)
plotAffyRNAdeg(data_Affy_deg)

if (normaliz_met=='MAS'){
  normalizacja= expresso(
    data_Affy,
    # background correction
    bg.correct = TRUE,
    bgcorrect.method = "mas",
    # normalize
    normalize = TRUE,
    normalize.method = "constant",
    # pm correction
    pmcorrect.method = "mas",
    # expression values
    summary.method = "mas")
 }

if (normaliz_met='RMA'){
  normalizacja=expresso(
    data_Affy,
    # background correction
    bg.correct = TRUE,
    bgcorrect.method = "rma",
    # normalize
    normalize = TRUE,
    normalize.method = "quantiles",
    # pm correction
    pmcorrect.method = "pmonly",
    # expression values
    summary.method = "medianpolish")
}

dataRMA=exprs(normalizacja)

biocLite('gahgu95av2.db')
require(gahgu95av2.db)

class=data$CLASS
class=as.data.frame(class)
class=AnnotatedDataFrame(class)
ExprSet=new("ExpressionSet", expr=dataRMA,phenoData=opis, annotation="gahgu95av2.db")
#names=as.data.frame(dataRMA)

entrez<- gahgu95av2ENTREZID
mapped_probes <- mappedkeys(entrez)
entrez_ID <- as.list(entrez[mapped_probes])
names=data.frame(row.names=mapped_probes) 

entrez <- gahgu95av2GENENAME
mapped_probes <- mappedkeys(entrez)
# Convert to a list
entrez_genename <- as.data.frame(as.list(entrez[mapped_probes]))
names[,1]=entrez_genename




names=AnnotatedDataFrame(names)
ExprSet@featureData=names
ExprSet@protocolData=class
#}
