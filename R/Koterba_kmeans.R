##################################Klasteryzacja k-means#####################
klasteryzacja_kmeans=function(ExprSet) {

  x=ExprSet@assayData$exprs
  dat1=x
  k <- 8
  withinss <- Inf
  for (i in 1:10) {
    kmeans.run = kmeans(t(dat1), k)
    print(sum(kmeans.run$withinss))
    print(table(kmeans.run$cluster))
    cat("----\n")
    if (sum(kmeans.run$withinss) < withinss) {
      result <- kmeans.run
      withinss <- sum(result$withinss)
    }
  }
  table_normal=table(result$cluster)

}