source("http://bioconductor.org/biocLite.R")
biocLite(c("Biobase"))
library("Biobase")
library('affy')
biocLite('affy')
biocLite('gahgu95av2.db')
library('gahgu95av2.db')

exampleFile=system.file("extadata","pData",package="Biobase")
data=read.table("dataSetA_scans.txt", header=TRUE, sep="\t")
data=data[c(1:17,211:227),]
opis=read.AnnotatedDataFrame("dataSetA_scans.txt",sep="\t",header=TRUE, 
                             row.names=4, stringsAsFactors=F)
opis=opis[c(1:17,211:227),]
sampleNames(opis)=paste(sampleNames(opis),".CEL",sep="")
data_Affy=ReadAffy(filenames=sampleNames(opis),verbose=T)
data_Affy@cdfName=paste("ga",data_Affy@cdfName,sep="")
data_Affy@annotation=paste("ga",data_Affy@annotation,sep="")
RMA=rma(data_Affy)
dataRMA=exprs(RMA)
experiment=new("MIAME",name="Dane mikromacierzowe",lab="IO",title="dane testowe",
               abstract="Przyklad",url="http://bioconductor.org",other=list(notes="inne"))
data_frame=as.data.frame(dataRMA)
d=AnnotatedDataFrame(data_frame)
ExprSet=new("ExpressionSet",expr=dataRMA,phenoData=opis,
            experimentData=experiment,annotation="gahgu95av2.db")
expr_sort=sort(rowMeans(exprs(ExprSet)),index.return=T)
feat_num=dim(ExprSet)[1]
cutoff=round(dim(ExprSet)[1]*0.025)
ind_clear=expr_sort$ix[c(1:cutoff,(feat_num-cutoff):feat_num)]
ExprSet=ExprSet[-ind_clear]

PCA_model=prcomp(t(exprs(ExprSet)))
summary(PCA_model)
PCA_model$x
barplot(PCA_model$sdev[1:5]/sum(PCA_model$sde),main="PCA")
