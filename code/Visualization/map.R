#Create a map of all the programs data collection events 

#install.packages("leaflet")
#install.packages("sp")
#install.packages("sf")
#library(leaflet)
#library(sp)
#library(sf)
#library(tidyverse)
#library(rgdal)
library(htmlwidgets)


data<- read.csv("Data/All_Data.csv") 
  
map_DCE<- function(){
  pal <- colorFactor(rainbow(3), data$Program)
  data <-data %>% drop_na(BRLong) %>% drop_na(BRLat)
  m <-data %>% 
      leaflet() %>%
      addTiles() %>%
      addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
                            popup= ~paste0("<b>",  Program, "</b>", 
                             "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
                             "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
                             "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
                             "<br>", "<b>", "Date ", "</b>", Date,    "</br>")) %>%
                              addLegend("topright", pal=pal, values= ~Program, opacity =1)
  
return(m)
} 

map_filename = paste0(getwd(),"Map/map.html")

saveWidget(widget=m, file=paste0(getwd(),"/Map/map.html"), selfcontained=T) 

