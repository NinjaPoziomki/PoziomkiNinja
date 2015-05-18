
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


x <- gahgu95av2DESCRIPTIONS
# Get the probe identifiers that are mapped to a gene description
mapped_probes <- mappedkeys(x)
# Convert to a list
xx <- as.list(x[mapped_probes])

names=as.data.frame(gene_list)
names=AnnotatedDataFrame(names)
ExprSet@featureData=names
ExprSet@protocolData=class



g_l=c()
for (i in 1:length(gene_list))
{g_l[i]=gene_list[[i]]
}


g_d=c()
for (i in 1:length(xx))
{g_d[i]=xx[[i]]
}


eall=cbind(mapped_probes,g_l,g_d)
  feature=as.data.frame(eall,st)



