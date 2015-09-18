data_prep=function(ExprSet,d_genes)
{
  
names=d_genes[,1]
adeno=which(pData(ExprSet)$CLASS=='ADENO')
normal=which(pData(ExprSet)$CLASS=='NORMAL')
E=exprs(ExprSet)
sel=E[names,]

class=c()
class[adeno]='adeno'
class[normal]='normal'
class=as.data.frame(class,stringsAsFactor=T)

sel=cbind(as.data.frame(t(sel)),class)

return(sel)
}