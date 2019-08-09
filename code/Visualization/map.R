#Create a map of all the programs 

install.packages("leaflet")
install.packages("sp")
install.packages("sf")

library(leaflet)
library(sp)
library(sf)

data<- read.csv("Data/All_Data.csv") 

pal <- colorFactor(rainbow(3), data$Program)


m <- leaflet() %>%
  addTiles() %>% 
  addCircles(lng=data$BRLong, lat=data$BRLat, color= pal(data$Program), popup=(data$Program)) 

m
mapshot(m, )

leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=data$BRLong, lat=data$BRLat)


m 

