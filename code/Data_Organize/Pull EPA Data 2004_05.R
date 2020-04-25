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


Pull_EPA<- function(user_url) { 
# Pull the data set for NRSA 0809 Physical Habitat Larger Set of Metrics - Data (CSV)(1 pg, 4 MB) from  WEBPAGE https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys

#download and create a dataframe of the site information 
site_file <- getURL('https://www.epa.gov/sites/production/files/2014-10/wsa_siteinfo_ts_final.csv')
locations <- tbl_df(read.csv(text=site_file))

#download and create a dataframe of the macroinvertebrate data  
macro_url <- getURL("https://www.epa.gov/sites/production/files/2014-10/wsa_benmet300_ts_final.csv")
macro <- tbl_df(read.csv (text=macro_url))

# First join the location data to the macroinvertebrate because there are multiple macroinvertebrate visits 
macro_location <- full_join(locations, macro, by=c('SITE_ID', 'DATE_COL', "YEAR"))

#Remove columens with .y 
macro_habitat <- select(macro_location, -contains(".y"))
#Rename columens with .x 
names(macro_location) <- str_remove(names(macro_location), ".x")

#download and create a dataframe of the EPA physical habitat data 
habitatbest       <- getURL("https://www.epa.gov/sites/production/files/2014-10/phabbest.csv")
habitat_best      <- tbl_df(read.csv (text=habitatbest))

#load the two habitat files 
habitat1url   <- getURL("https://www.epa.gov/sites/production/files/2014-10/phabmet_part1.csv")
habitat1       <- tbl_df(read.csv (text=habitat1url))
habitat2url   <- getURL("https://www.epa.gov/sites/production/files/2014-10/phabmet_part2.csv")
habitat2       <- tbl_df(read.csv (text=habitat2url))

habitat <- left_join(habitat1, habitat2, b= c("SITE_ID", "YEAR", "VISIT_NO"))

#join the habitat data to the macroinverterbrate data 
macro_habitat <- left_join(macro_location, habitat, by =c("SITE_ID","YEAR"))

#Remove columens with .y 
macro_habitat <- select(macro_habitat, -contains(".y"))

#Rename columens with .x 
names(macro_habitat) <- str_remove(names(macro_habitat), ".x")

#Save the dataset in the repository data file 
wd <- "C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019_2020/Code/tributary-habitat-data-sharing-"
write.csv(macro_habitat, file=paste0(wd,"/Data/EPA_Subset_2004.csv"), row.names=FALSE)
} 

