source("http://www.bioconductor.org/biocLite.R")
require("gahgu95av2.db")
require('affy')
# 
# #create expressionSet
# setwd("C:/Users/Justyna/Documents/PoziomkiNinja/R")

# 
# cels<-names[c(1:17,211:227),]
# sampleNames(cels)<-paste(sampleNames(cels),'.CEL',sep="")
# dane<-ReadAffy(filenames=sampleNames(cels),verbose=TRUE)
# dane@cdfName<-paste("ga",dane@cdfName,sep="")
# dane@annotation<-paste("ga",dane@annotation,sep="")
# Rma<-rma(dane)
# exp<-exprs(Rma)
# 
# experiment=new("MIAME",name="Dane",lab="131",title="DANE",other=list(notes="inne"))
# # 
#  ExprSet1=new("ExpressionSet",expr=exp1,phenoData=cels,
#              experimentData=experiment,annotation="gahgu95av2.db")
# expr_sort<-sort(rowMeans(exprs(ExprSet)),index.return=T) # sortowanie według średniej dla wiersza
# feat_num<-dim(Rma)[1]
# cutoff<-round(dim(Rma)[1]*0.025)
# ind_clear<-expr_sort$ix[c(1:cutoff,(feat_num-cutoff):feat_num)]
# ExprSet<-ExprSet[-ind_clear,] #dane po odcięciu 5% sond o najmniejszej i największej ekspresji
# #######################################################################



sum_table1=function(ExprSet,method,kryterium,wartosc,liczba_wynikow){
  adeno=which(pData(ExprSet)$CLASS=='ADENO')
  normal=which(pData(ExprSet)$CLASS=='NORMAL')


expr<-exprs(ExprSet)
sr_adeno<-rowMeans(expr[,adeno])
sr_normal<-rowMeans(expr[,normal])

adeno=which(pData(ExprSet)$CLASS=='ADENO')
normal=which(pData(ExprSet)$CLASS=='NORMAL')


if (typ_danych=='log')
{
  FC<-sr_adeno-sr_normal
}
else if (typ_danych=='norm')
{
  FC<-sr_adeno/sr_normal
}
else stop ("Typ_danych: log/norm")

statistic<-apply(expr,1,function(x) t.test(x[adeno],x[normal])$statistic)
pval<-apply(expr,1,function(x) t.test(x[adeno],x[normal])$p.val)
p_val_kor<-p.adjust(pval,method=method)
symbol<-unlist(mget(featureNames(ExprSet),env=gahgu95av2SYMBOL))
genNames<-unlist(mget(featureNames(ExprSet),env=gahgu95av2GENENAME))
TAB=array(dim=c(dim(expr)[1],9))
colnames(TAB)=c("FerrariID","Symbol","description","fold change",
                "sr_adeno","sr_normal","statystyka t","p-value",
                "corrected p-value")
TAB[,1]=featureNames(ExprSet)
TAB[,2]=symbol
TAB[,3]=genNames
TAB[,4]=FC
TAB[,5]=sr_adeno
TAB[,6]=sr_normal
TAB[,7]=statistic
TAB[,8]=pval
TAB[,9]=p_val_kor

TAB_ALL=TAB

if (kryterium=='p_val_kor')
{
  if (wartosc<1){
    ind_sort=which(p_val_kor<wartosc)
    TAB=TAB[ind_sort,]
    ind_sort=sort(TAB[,9],index=T)$ix
  }
  else stop('Zla wartosc')
}
else if (kryterium=='p_val')
{
  if (wartosc<1){
    ind_sort=which(pval<wartosc)
    TAB=TAB[ind_sort,]
    ind_sort=sort(TAB[,8],index=T)$ix
  }
  else stop('zla wartosc')
}

else if (kryterium=='FC')
{
  ind_sort=which(FC<wartosc)
  TAB=TAB[ind_sort,]
  ind_sort=sort(TAB[,4],index=T)$ix
  
}

else stop('Zle kryterium')

if(liczba_wynikow>1){
  
  TAB=TAB[ind_sort[1:liczba_wynikow],]
}

else stop('Podaj wartosc liczba_wynikow>=1')


write.table(TAB,file='tab.txt',sep=',',row.names=F)
newList <- list("TAB_ALL" = TAB_ALL, "TAB" = TAB)
return(newList)
}



#do funkcji podajemy ExpressionSet, metodę korekcji("holm", "hochberg", "hommel", 
#"bonferroni", "BH", "BY","fdr", "none"), według czego wybieramy wyniki 
#(skorygowane p-value, p-value, fold change),jaki chcemy próg odcięcia
# i ile chcemy wyników
# Lista: TAB- tabela zawierająca posortowane dane, zgodnie z podanymi kryterium i liczbą wyników
#TAB_ALL- wszystkie wyniki

