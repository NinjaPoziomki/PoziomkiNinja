
source("http://bioconductor.org/biocLite.R")
biocLite(c("Biobase"))
require("Biobase")

data<-read.table("datasetA_scans.txt",header=T,sep="\t")
require("affy")

data=data[c(1:17,211:227),]
opis=read.AnnotatedDataFrame("datasetA_scans.txt",header=T,sep="\t",row.names=4,stringsAsFactors=F)

opis=opis[c(1:17,211:227)]
sampleNames(opis)=paste(sampleNames(opis),".CEL",sep="")

data_Affy=ReadAffy(filenames=sampleNames(opis),verbose=T)

data_Affy@cdfName=paste("ga",data_Affy@cdfName,sep="")
data_Affy@annotation=paste("ga",data_Affy@annotation,sep="")

RMA=rma(data_Affy)
dataRMA=exprs(RMA)

biocLite('gahgu95av2.db')
require(gahgu95av2.db)

class=data$CLASS
class=as.data.frame(class)
class=AnnotatedDataFrame(class)
ExprSet=new("ExpressionSet", expr=dataRMA,phenoData=opis, annotation="gahgu95av2.db")
#names=as.data.frame(dataRMA)
entrez<- gahgu95av2ENTREZID
mapped_probes <- mappedkeys(entrez)
gene_list <- as.list(entrez[mapped_probes])
names=as.data.frame(gene_list)
names=AnnotatedDataFrame(names)
ExprSet@featureData=names
ExprSet@protocolData=class
