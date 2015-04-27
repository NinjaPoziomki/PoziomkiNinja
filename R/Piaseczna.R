source("http://bioconductor.org/biocLite.R")
biocLite()
library('affy')
library('Biobase')
library()

data=read.table("datasetA_scans.txt",sep="\t",header=TRUE)
data=data[c(1:16,211:227),]
opis=read.AnnotatedDataFrame("datasetA_scans.txt",sep="\t",header=TRUE,row.names=4,stringsAsFactors=FALSE)
opis=opis[c(1:16,211:227),]
sampleNames(opis)=paste(sampleNames(opis),".CEL",sep="")
data_Affy=ReadAffy(filenames=sampleNames(opis),verbose=TRUE)
data_Affy@cdfName=paste("ga",data_Affy@cdfName,sep="")
data_Affy@annotation=paste("ga",data_Affy@annotation,sep="")

#Normalizacja metoda RMA
RMA=rma(data_Affy)
dataRMA=exprs(RMA)


experiment=new("MIAME",name="Dane mikromacierzowe WSP",lab="IO",title="dane testowe WSP",contact="grupa1",
               abstract="Przyklad",url="http://bioconductor.org",preprocessing=list(norm="RMA"),other=list(notes="inne",drugiepole="inne3"))

FeatureData=RMA@featureData
varMetadata(FeatureData)="nazwa"

ExprSet=new("ExpressionSet",exprs=dataRMA,featureData=AnnotatedDataFrame(as.data.frame(dataRMA)),phenoData=opis,experimentData=experiment,annotation="gahgu95av2.db",protocolData=opis)




