
#Load the pallet for the map 
pal <- colorFactor(rainbow(3), data$Program)

data%>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lng=~BRLong, lat= ~BRLat, color=~pal(Program), 
             popup= ~paste0("<b>",  Program, "</b>", 
                            "<br>", "<b>", "ReachID ", "</b>",  ReachID, "</br>",
                            "<br>", "<b>", "SiteID ", "</b>",SiteID,  "</br>",
                            "<br>", "<b>", "Year ", "</b>", Year,    "</br>",
                            "<br>", "<b>", "Date ", "</b>", Date,    "</br>", 
                            "<br>")) %>%
  addLegend("topright", pal=pal, values= ~Program, opacity =1)

