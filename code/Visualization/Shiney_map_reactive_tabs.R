map_download<-function(){ 

#install.packages('shiny', dependencies = TRUE)
library(shiny)

#install.packages('tidyverse')
library(tidyverse)

#install.packages('leaflet')
library(leaflet)

#install.packages('dplyr')
library(dplyr)

#install.packages('leaflet.extras')
library(leaflet.extras)

#install.packages('DT')
library(DT)

#install.packages('ggplot2')
library(ggplot2)

# This should work, but for some reason I can't figure it out
#wd<- getwd()
#file<- paste0(wd,"/Data/All_Data_with_NVCS.csv")

# Can't figure out how to retreive WD and paste into a R file name?
wd <- "C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019 Work/Code/tributary-habitat-data-sharing-/"
file<- paste(wd,"Data/All_Data_with_NVCS.csv", sep='')
data <- read.csv(file)
#data <- read.csv("C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019 Work/Code/tributary-habitat-data-sharing-/Data/All_Data_with_NVCS.csv")


#remove the data collection points with blanks lat, long
data         <-data %>% drop_na(BRLong) %>% drop_na(BRLat)
nvcs_list    <- levels(data$nvcs_subclass)

#Load the metric list
metrics_file  <- paste0(wd,"/Data/SubSetOfMetricNames.csv")
metrics_list  <- as_tibble(read.csv(metrics_file))


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
                        selectInput(inputId='metric', label="Select Metric", choices=metrics_list$ShortName[c(13,17,18)], selected='PctPool'),
                        plotOutput("hist", height = 200), 
                        selectInput(inputId='metric_y', label="Select Stream Power", choices=metrics_list$ShortName[8:11], selected='Grad'),
                        plotOutput("plot", height = 200)
                                          )),
                #a tab for the metric descriptions 
                tabPanel("Method Description", dataTableOutput("Methods")), 
                # a tab for downloading data  
                tabPanel("Explore Data", 
                        sidebarLayout(
                            sidebarPanel(downloadButton("downloadData", "Download")),   
                            mainPanel(DT::dataTableOutput('table'))
                                      )
                
                ))


server <- function(input, output) { 
 # Create the map 

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
  
  
 # When a user starts the map show all the points, then filter to a subset of sites based on users seletion, I can't figure out how to make this work. Below is my attempt 
  
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

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
       
#Second Tab to pull method data from MR.org using the APIs 
        file<- paste(wd,"Code/data_organize/metric_documentation.R", sep='')
        source(file)
    
  #Need help formating the html table 
    output$Methods <- DT:: renderDataTable (DT::datatable({ 
        method <- metric_information(input$metric)
        method
        }))

        
# Third tab table and data download 
        
         # create a table to output on the thrid tab 
         output$table<- renderDataTable({
                   data %>% 
                    filter(nvcs_subclass==input$e_id)
            })
      
         # Downloadable csv of selected dataset ----
         download_data<- reactive({
                        return(download_data= data.frame(data%>% 
                                 filter(nvcs_subclass==input$e_id)))
                      })
         
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

