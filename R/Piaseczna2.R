
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
AffyID <- mappedkeys(entrez)
gene_list <- as.list(entrez[AffyID])


x <- gahgu95av2DESCRIPTIONS
# Get the probe identifiers that are mapped to a gene description
AffyID <- mappedkeys(x)
# Convert to a list
xx <- as.list(x[AffyID])

names=as.data.frame(gene_list)
names=AnnotatedDataFrame(names)
ExprSet@featureData=names
ExprSet@protocolData=class



EntrezID=c()
for (i in 1:length(gene_list))
{EntrezID[i]=gene_list[[i]]
}


GeneDESCRIPTIONS=c()
for (i in 1:length(xx))
{GeneDESCRIPTIONS[i]=xx[[i]]
}


eall=cbind(AffyID,EntrezID,GeneDESCRIPTIONS)
  feature=as.data.frame(eall,stringsAsFactors=F)
feature=AnnotatedDataFrame(feature)
ExprSet@featureData=feature

save(ExprSet,file='ExprSet.RData')

