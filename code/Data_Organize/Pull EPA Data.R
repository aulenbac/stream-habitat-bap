#Script to pull EPA data
install.packages('RCurl')
install.packages('tidyverse')
install.packages('dplyr')
library(RCurl)
library(tidyverse)
library(dplyr)
library(sp)
library(leaflet)
library(sf)

#Pull_EPA<- function(user_url) { 
  # Pull the data set for NRSA 0809 Physical Habitat Larger Set of Metrics - Data (CSV)(1 pg, 4 MB) from
  # WEBPAGE https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys
  
  #user_url<-"https://www.epa.gov/sites/production/files/2014-10/phabbest.csv"
  user_url <- "https://www.epa.gov/sites/production/files/2015-09/phabmed.csv"
  
  ld_download <- getURL(user_url)
  
  #create a data frame of the EPA data 
  large_data  <- tbl_df(read.csv (text=ld_download))
  
  #Pull the 20x macrointerverbrate data 
  macro_url <- getURL("https://www.epa.gov/sites/production/files/2015-09/bentcond.csv")
  macro_data <- tbl_df(read.csv (text=macro_url))
  
#join the habitat data to the macroinverterbrate data 
   macro_habitat <- full_join(large_data, macro_data, by ="UID")
   setnames(macro_habitat, "SITE_ID.x", "SITE_ID") 

#rename column heads in the joined file so the columns match the metadata in the metadata file 
   names(macro_habitat)[names(macro_habitat) == "SITE_ID.x"] <- "SITE_ID"
   names(macro_habitat)[names(macro_habitat) == "VISIT_NO.x"] <- "VISIT_NO"
   names(macro_habitat)[names(macro_habitat) == "DATE_COL.x"] <- "DATE_COL"
   names(macro_habitat)[names(macro_habitat) == "YEAR.x"] <- "YEAR"
   
   
  #Load the list of metric names create from the metadata 
 # subSN<- read.csv("Data/SubSetOfMetricNames.csv") 
  
  #A vector of metric names from the EPA data 
  #EPA<-subSN$EPAColumn
  #EPA<-as.character(EPA[!is.na(EPA)])
  
  # Include the protocol variable because the dataset contains both Wadeable and Boat streams, we are only intrested in wadeable streams 
 # EPA<- c(EPA, "PROTOCOL")
  
  #Create a subset of the EPA data sets with only the metrics that overlap between the programs 
  #sub= large_data[c(EPA)]

#Remove all botable data, creating a subset of data that only contains the wadable stream data protocol 
 EPA_Wadeable <- macro_habitat %>% 
              filter(PROTOCOL=="WADEABLE")
  
#Save the dataset in the repository data file 
   write.csv(EPA_Wadeable, file="Data/EPA_Subset.csv", row.names=FALSE)

 #create a geoJSON file of the EPA data 


   # The projection is Albers (according to the EPA )
  EPA_proj <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
   
   #Save to GEOJason 
   locations <- select(EPA_Wadeable,one_of("LON_DD83", "LAT_DD83"))
   data <- select(EPA_Wadeable, -contains("DD83"))
   EPA_spatial_data <- SpatialPointsDataFrame(locations, data, proj4string = CRS(EPA_proj))
   EPA_GeoJson <- geojson_json(EPA_spatial_data)
   EPA_WGS84 <- spTransform(EPA_spatial_data, CRS("+proj=longlat +datum=WGS84 +no_defs"))
 
#Write EPA data as GeoJSON 
   writeOGR(EPA_WGS84,'Data/EPA.geojson', layer="EPA_data" , driver="GeoJSON", verbose=TRUE)
   
   EPA <- readOGR(dsn = "Data/EPA.geojson")
   
   #return(EPA_Wadeable)
#} 

