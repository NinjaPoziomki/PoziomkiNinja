shinyUI(navbarPage("Microarrays data analysis",position="static-top" , inverse=T,
  
                
                tabPanel("choose files", 
                         sidebarLayout(
                           sidebarPanel(
                         helpText("Please choose AffyBatch object"),
                         fileInput("finput", "AffyBatch", multiple = FALSE, accept = NULL),
                         fileInput("nameinput", "Txt", multiple = FALSE, accept = NULL),
                         h2("Preprocessing"),
                         
                         selectInput("selectBackground", "Select method of background correction", 
                                     choices<- c("RMA", "MAS"))),
                         mainPanel(
                           tabsetPanel(type="tabs",
                                       tabPanel("ADENO data",
                                                plotOutput("AdenoHistBefore"),
                                                plotOutput("AdenoBoxBefore"),
                                                plotOutput("AdenoHistAfter"),
                                                plotOutput("AdenoBoxAfter")),
                                       tabPanel("NORMAL data",
                                                plotOutput("NormalHistBefore"),
                                                plotOutput("NormalBoxBefore"),
                                                plotOutput("NormalHistAfter"),
                                                plotOutput("NormalBoxAfter")),
                                       tabPanel("RNA degradation",
                                                plotOutput("AdenoRNA_deg"),
                                                plotOutput("NormalRNA_deg"))
                         )))),
                tabPanel("clustering",
                         sidebarLayout(
                           sidebarPanel(
                             
                             selectInput("clustmethod", label= "Choose method of clustering", choices <- c("hierarchical","PCA","k-means")),
                             uiOutput("hierOptions")),
                          mainPanel(
                           tabsetPanel(type="tabs",
                                       
                                       tabPanel("",
                                                plotOutput("plots")),
                                       tabPanel("summary",
                                                uiOutput("PCA"))
                                       
                           )))),
                tabPanel("clasification",
                         sidebarLayout(
                           sidebarPanel(
                             selectInput("clussmethod",label="Choose method of classification", choices<- c("lda_fun","svm_fun")),
                             selectInput("validmethod", label= "Choose method of validation", choices <- c("bs","simple", "l_one_out")),
                             numericInput("repeats", label="Type amount of repeats", 2, min=0.1, max=5),
                             selectInput("selectclussmethod", label = ("Select correction method"), 
                                         choices <- c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY","fdr", "none" )),
                             selectInput("clusscriterion", label=("Select cut-off criterion"), 
                                         choices <- c("p_val", 'p_val_kor', "FC")),
                             sliderInput("clusscutoffval", label=("Select cut-off value"), min=0, max=1, value=0.5, step=0.05), 
                             numericInput("clussnumOfres", label=("Select number of results"), value = 2))
                             ,
                           mainPanel(
                             tableOutput("ewalist")
                           )
                         )),
                         
                tabPanel("statistics",
                         sidebarLayout(
                           sidebarPanel(
                         selectInput("selectmethod", label = ("Select correction method"), 
                                     choices <- c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY","fdr", "none" )),
                         selectInput("criterion", label=("Select cut-off criterion"), 
                                     choices <- c("p_val", 'p_val_kor', "FC")),
                         sliderInput("cutoffval", label=("Select cut-off value"), min=0, max=1, value=0.5, step=0.05), 
                         numericInput("numOfres", label=("Select number of results"), value = 2)),
                         mainPanel(
                         dataTableOutput("stattable"))
                         )
                )
               
))

  


