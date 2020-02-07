#Script to pull EPA data
install.packages('RCurl')
library(RCurl)
install.packages('tidyverse')
library(tidyverse)
library(dplyr)



Pull_EPA<- function(user_url) { 
  # Pull the data set for NRSA 0809 Physical Habitat Larger Set of Metrics - Data (CSV)(1 pg, 4 MB) from
  # WEBPAGE https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys
  
  ld_download <- getURL(user_url)
  
  large_data  <- tbl_df(read.csv (text=ld_download))
  
  #Load the list of metric names create from the metadata 
  subSN<- read.csv("Data/SubSetOfMetricNames.csv") 
  
  #A vector of metric names from the EPA data 
  EPA<-subSN$EPAColumn
  EPA<-as.character(EPA[!is.na(EPA)])
  
  # Include the protocol variable because the dataset contains both Wadeable and Boat streams, we are only intrested in wadeable streams 
  EPA<- c(EPA, "PROTOCOL")
  
  #Create a subset of the EPA data sets with only the metrics that overlap between the programs 
  sub= large_data[c(EPA)]
  
  #Remove all botable data, creating a subset of data that only contains the wadable stream data protocol 
  EPA_Wadeable= filter(sub, sub$PROTOCOL=="WADEABLE")
  
  #Save the dataset in the repository data file 
    write.csv(EPA_Wadeable, file="Data/EPA_Subset.csv", row.names=FALSE)
    return(EPA_Wadeable)
} 

