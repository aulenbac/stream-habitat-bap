explore_data<-function(){ 

library(shiny)
library(tidyverse)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(DT)
library(ggplot2)

#Load the Data 
data <- read.csv("C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019 Work/Code/tributary-habitat-data-sharing-/Data/All_Data_with_NVCS.csv")
#remove the data collection points with out lat, long
data <-data %>% drop_na(BRLong) %>% drop_na(BRLat)
nvcs_list    <- levels(data$nvcs_subclass)

#Load the metric list 
metrics_list <- read.csv("C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019 Work/Code/tributary-habitat-data-sharing-/Data/SubSetOfMetricNames.csv")

#Load the pallet for the map 
pal <- colorFactor(rainbow(3), data$Program)



ui<- navbarPage(
            "Stream Habitat",
              # a tab for a map 
               tabPanel("Map", leafletOutput(outputId="map", width = "100%", height= 900), 
                      absolutePanel(
                        id = "controls", class = "panel panel-default", fixed = TRUE,
                        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                        width = 'auto', height = "auto",
                        #Create a drop down with the NVCS ecosystems 
                        selectInput(inputId ="e_id", label= "Choose a NVCS ecosystesm", 
                                    choices=(nvcs_list), selected ='' ), 
                        selectInput(inputId='metric', label="Select Metric", choices=metrics_list$ShortName[8:20], selected=''),
                        plotOutput("hist", height = 200), 
                        selectInput(inputId='metric_y', label="Select Metric Y", choices=metrics_list$ShortName[8:20], selected='Grad'),
                        plotOutput("plot", height = 200)
                                          )),
                #a tab for the metric descriptions 
                tabPanel("Metric Description", tableOutput("Metrics")), 
                # a tab for downloading data  
               tabPanel("Explore Data", 
                        sidebarLayout(
                          sidebarPanel(downloadButton("downloadData", "Download")),   
                          mainPanel(DT::dataTableOutput('table'))
                                      )
                
                ))


server <- function(input, output) { 
 # Create the map 

 # When a user starts the map show all the points, then filter to a subset of sites based on users seletion 
  

#   if (input$e_id=='') {
   
#   output$map <-  renderLeaflet({
#     data%>%
#       leaflet() %>%
#       addTiles() %>%
#       addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
#                  popup= ~paste0("<b>",  Program, "</b>", 
#                                 "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
#                                 "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
#                                 "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
#                                 "<br>", "<b>", "Date ", "</b>", Date,    "</br>", 
#                                 "<br>", "<b>", "NVCS Data ", "</b>", nvcs_subclass, "</br>")) %>%
#       addLegend("topleft", pal=pal, values= ~Program, opacity =1)
#   })
   
   
 #        } else {
           
           
#           output$map <-  renderLeaflet({
#             data%>%
#               filter(nvcs_subclass==input$e_id) %>%  
#               leaflet() %>%
#               addTiles() %>%
#               addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
#                         popup= ~paste0("<b>",  Program, "</b>", 
#                                         "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
#                                         "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
#                                         "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
#                                         "<br>", "<b>", "Date ", "</b>", Date,    "</br>", 
#                                         "<br>", "<b>", "NVCS Data ", "</b>", nvcs_subclass, "</br>")) %>%
#               addLegend("topleft", pal=pal, values= ~Program, opacity =1)
#           })
#    }
  
#filter(nvcs_subclass==input$e_id) %>%  

 # dataInput <- reactive({
  #  if(inpuet$e_id== "") {
   #   return(data) 
    #} else { 
#      return(data %>% filter(nvcs_subclass==input$e_id)) 
#    }
#  })

#dataInput<- reactive ({data %>% filter(nvcs_subclass==input$e_id)})  
  
output$map <-  renderLeaflet({
     data%>% 
     filter(nvcs_subclass==input$e_id) %>%
     leaflet() %>%
     addTiles() %>%
     addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
               popup= ~paste0("<b>",  Program, "</b>", 
                              "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
                              "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
                              "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
                               "<br>", "<b>", "Date ", "</b>", Date,    "</br>", 
                              "<br>", "<b>", "NVCS Data ", "</b>", nvcs_subclass, "</br>")) %>%
     addLegend("topleft", pal=pal, values= ~Program, opacity =1)
 })
  
  
       #create simple scatter plot 
       output$plot<- renderPlot({
              nvcs_ec = data %>% 
                   filter(nvcs_subclass==input$e_id)%>%
                   select(input$metric,input$metric_y, "Program")
              ggplot(nvcs_ec, aes(x=nvcs_ec[,1], y=nvcs_ec[,2], color=Program))+geom_point()
                 #plot(nvcs_ec)
         })
       
       #create a histogram 
        output$hist <- renderPlot({
                        nvcs_h = data %>% 
                         filter(nvcs_subclass==input$e_id)%>%
                         select(input$metric, "Program") 
                  #ggplot(nvcs_h, aes(nvcs_h[1]))+geom_histogram()+facet_wrap(~Program)
                #  ggplot(nvcs_h, aes(input$metric))+ geom_point()+facet_wrap(~Program)
                  qplot(nvcs_h[,1], geom='histogram')
                  })
       
# Create a table of metrics 
       # output$metrics <-renderTable { 
        
        #source("Code/data_organize/metric_documentation.R")
        #PctPoolMetadata <- metric_information(imput$metric)
        #print(PctPoolMetadata)
        
        #kable(PctPoolMetadata)%>%
        #  kable_styling(bootstrap_options = c("striped", "hover", fixed_header=TRUE ))
        #} 
        
        
          
        download_data<- reactive({return(download_data= data.frame(data%>% 
                                 filter(nvcs_subclass==input$e_id)))
                       })
        
         # create a table 
         #output$table<- renderDataTable({
          #            data %>% 
           #           filter(nvcs_subclass==input$e_id)%>%
            #          select(input$metric, input$metric_y) 
      
        # create a table 
        output$table<- renderDataTable({download_data}) 
        
        #output$table <- renderTable({download_data})
           
        # Downloadable csv of selected dataset ----
          output$downloadData <- downloadHandler(
            filename = function() {
              paste(input$metric, ".csv", sep = "")
             },
            content = function(file) {
               write.csv(download_data(), file, row.names = TRUE)
             })
       
      }



shinyApp(server = server, ui=ui)

} 
