options(shiny.maxRequestSize = 60*1024^2)
shinyServer(function(input, output, session) {
  options(warn=-1)
  
  
  setwd("C:/Users/Justyna/Documents/PoziomkiNinja/R")
  source("wsp.R")
  source("Mariusz_WSP.R")
  source("klasyfikuj.R")
  source("Mariusz_Wiecha_PCA.R")
  source("Koterba_klasteryzacja.R")
  #load("var.RData")
#   load("C:/Users/Justyna/Documents/PoziomkiNinja/R/ExprSet.RData")


raw_data <- reactive({
  dataAffy<-input$finput
  if(is.null(dataAffy) && is.null(input$nameinput))
  {
    return()
  }
  else
    {
  load(dataAffy$datapath)
    }
  
  return(dane)
   
  
})


norm<- reactive({
  
  return(normalization(input$selectBackground, raw_data()))
})
norm3<-reactive({
  namefile<-input$nameinput
  return(CreateExprSet(norm(), namefile$datapath))
})
norm4<-reactive({
  sel_params=list(input$selectclussmethod, input$clusscriterion, input$clusscutoffval, input$clussnumOfres)
  return(klasyfikuj(sel_params, norm3(), input$clussmethod, input$validmethod, input$repeats))
  })
norm5<-reactive({
  return(sum_table1(norm3(), input$selectmethod, input$criterion, input$cutoffval, input$numOfres)$TAB)
})
#norm6<-reactive({
 # return(pca_klasteryzacja(norm3()))})
  
output$ewalist<-renderTable({norm4()})
output$stattable<-renderDataTable({norm5()})
################Adeno plots##########

output$AdenoHistBefore <-renderPlot({hist(raw_data()[c(1:17),], main='Histogram z danymi nieznormalizowanymi dla ADENO')})
output$AdenoBoxBefore <-renderPlot({boxplot(raw_data()[c(1:17),], main='Wykres pude?kowy dla danych nieznormalizowanych Adeno')})
output$AdenoHistAfter <-renderPlot({plotDensity(norm()[,c(1:17)], main='Histogram z danymi znormalizowanymi dla ADENO')})
output$AdenoBoxAfter<- renderPlot({boxplot(norm()[,c(1:17)], main="Wykres pude?kowy dla danych znormalizowanych Adeno")})  

################Normal plots##########
output$NormalHistBefore <- renderPlot({
 
      hist(raw_data()[c(18:34),], main='Histogram z danymi nieznormalizowanymi dla NORMAL')
  })

output$NormalBoxBefore <-renderPlot({boxplot(raw_data()[c(18:34),], main='Wykres pude?kowy dla danych nieznormalizowanych NORMAL')})
output$NormalHistAfter <-renderPlot({plotDensity(norm()[,c(18:34)], main='Histogram z danymi znormalizowanymi dla NORMAL')})
output$NormalBoxAfter<- renderPlot({boxplot(norm()[,c(18:34)], main="Wykres pude?kowy dla danych znormalizowanych NORMAL")})  

###############RNA deg plots##########

output$AdenoRNA_deg<-renderPlot({plotAffyRNAdeg(AffyRNAdeg(raw_data()[c(1:17),]))});
output$NormalRNA_deg<-renderPlot({plotAffyRNAdeg(AffyRNAdeg(raw_data()[c(18:34),]))});

output$hierOptions <-renderUI({if(input$clustmethod=="hierarchical") {selectInput("hier", label="choose method of hierarchical clustering", choices=c("average", "complete","centroid"))}})
clust1 <- reactive({
  return(klasteryzacja_hierarchiczna(norm3(), input$hier))
})
output$PCA<-renderUI({if(input$clustmethod == "PCA") {return(pca_klasteryzacja(norm3()))}})
output$plots<- renderPlot({plot(clust1())})

})