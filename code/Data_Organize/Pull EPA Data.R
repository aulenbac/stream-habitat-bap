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
  
#Download the habitat date file  
  user_url <- "https://www.epa.gov/sites/production/files/2015-09/phabmed.csv"
  ld_download <- getURL(user_url)
  
#create a data frame of the EPA physical habitat data 
  habitat  <- tbl_df(read.csv (text=ld_download))
  
#Download locations 
  locations_URL <-getURL('https://www.epa.gov/sites/production/files/2015-09/siteinfo_0.csv')
  locations  <- tbl_df(read.csv(text=locations_URL))

#Join locations and habitat 
  large_data<-right_join(locations, habitat, by=c("UID","SITE_ID","VISIT_NO", "YEAR"))
  
#Remove columens with .y 
  macro_habitat <- select(large_data, -contains(".y"))
#Rename columens with .x 
  names(large_data) <- str_remove(names(large_data), ".x")
  
#Download the the macrointerverbrate data from the EPA website 
  macro_url <- getURL("https://www.epa.gov/sites/production/files/2015-09/extbenthicrefcond.csv")
  macro_data <- tbl_df(read.csv (text=macro_url))
  
#join the habitat data to the macroinverterbrate data 
   macro_habitat <- full_join(large_data, macro_data, by =c("SITE_ID", 'VISIT_NO', 'YEAR', 'UID'))

#Remove columens with .y 
   macro_habitat <- select(macro_habitat, -contains(".y"))
   
#Rename columens with .x 
  names(macro_habitat) <- str_remove(names(macro_habitat), ".x")

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
  wd <- "C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019_2020/Code/tributary-habitat-data-sharing-"
  write.csv(EPA_Wadeable, file=paste0(wd,"/Data/EPA_Subset.csv"), row.names=FALSE)

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

