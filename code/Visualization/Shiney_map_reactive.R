library(shiny)
library(tidyverse)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(DT)


#data            <- read.csv("Data/All_Data_with_NVCS.csv")
nvcs_ecosystems <- levels(data$nvcs_ecosystem)
#nvcs_ecosystems <- as.list(unique(data$nvcs_ecosystem)) 
#test_count<- count(data, nvcs_ecosystem)
#list_of_choices= d %>%
 # filter(test_count[2]>30)
pal <- colorFactor(rainbow(3), data$Program)
data <-data %>% drop_na(BRLong) %>% drop_na(BRLat)


ui<-pageWithSidebar(
      headerPanel('Variables'), 
      sidebarPanel(
          #Create a drop down with the NVCS ecosystems 
          selectInput(inputId ="e_id", label= "Choose a NVCS ecosystesm", 
                      choices=(nvcs_ecosystems), selected ='' )), 
      mainPanel(    
          #Create a space for us to display our map 
          leafletOutput(outputId="map", width="100%", height="100%"), 
          plotOutput(outputId='plot'), 
          DT::dataTableOutput('table')
          )
      
)


server <- function(input, output) { 
            # select the subset of data based on the user's selected ecoregion 
              #create plot 
                output$plot<- renderPlot({
                      nvcs_es = data %>% 
                          filter(nvcs_ecosystem==input$e_id)
                      plot(nvcs_es$PctPool, nvcs_es$BFWidth, main=input$e_id)})
             # create a table 
                output$table<- renderDataTable({data %>% 
                                                    filter(nvcs_ecosystem==input$e_id)})
  
              # Create the map 
                     output$map <-  renderLeaflet({
                       data%>%
                          filter(nvcs_ecosystem==input$e_id)%>%
                           leaflet() %>%
                           addTiles() %>%
                           addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
                           popup= ~paste0("<b>",  Program, "</b>", 
                              "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
                              "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
                              "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
                              "<br>", "<b>", "Date ", "</b>", Date,    "</br>")) %>%
                             addLegend("topright", pal=pal, values= ~Program, opacity =1)
                    })
} 
 
  

shinyApp(server = server, ui=ui)