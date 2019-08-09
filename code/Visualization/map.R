#Create a map of all the programs 

install.packages("leaflet")
library(leaflet)

data<- read.csv("Data/All_Data.csv") 

m = leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=data$BRLat, lat=data$BRLong) 

m 

