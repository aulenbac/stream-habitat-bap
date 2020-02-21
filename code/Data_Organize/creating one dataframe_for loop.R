install.packages("dplyr") 
install.packages("openxlsx")
install.packages("tidyverse")
install.packages("readxl")

# Create one dataframe of a subset of metrcs across the four prorams 
one_data_frame <- function() {
    library(dplyr)
    library(readxl)
    library(tidyverse)
    library(openxlsx)
    library(sf)
    library(tmap)
    library(httr)
    library(data.table)
    library(sp)
        
        #open the the metadata file 
        metadata <- as_tibble(read_xlsx("Data/Metadata.xlsx", 3))
        SN <- select(metadata, c(Category, Name, ShortName, DataType ,AREMPColumn, BLMColumn, EPAColumn, PIBOColumn, Subset_of_Metrics))
        SN <- as_tibble(lapply(SN, as.character))
        
        
        #Covnert blankes to missing values 
        SN<-mutate_all(SN, funs(na_if(.,"")))
  
        # Extract the subset of metrics we are focusing on in this work 
        subset_metrics <- SN %>% 
                        filter(Subset_of_Metrics== "x")
        
        #save the list of the subset of metrics
        write.csv(subset_metrics, file="Data/SubSetOfMetricNames.csv", row.names=FALSE)
        
       # return(subset_metrics)
      
        #Create a variable holding the short names 
        short_names <- subset_metrics$ShortName
        data_types  <- subset_metrics$DataType
       
        #list of unique data types 
        unique_data_types <- unique(data_types)
        
        
        #Create a empty dataframe with the short names 
        all_data <- data.frame(matrix(ncol = length(short_names), nrow = 0))
        colnames(all_data) <- short_names
       #set the data types of the dataframe 
       # all_data[data_types== "Double"] <- sapply(all_data[data_types== "Double"], as.double)
        all_data[data_types== "Character"] <- sapply(all_data[data_types=="Character"], as.character)
        all_data[data_types== "Date"] <- sapply(all_data[data_types=="Date"], as.character)
        all_data[data_types== "Interger"] <- sapply(all_data[data_types=="Interger"], as.character)
        
       
program <-c('EPA', 'PIBO', 'BLM','AREMP')
        
        #For loop to add data from each program to one data set 
        for(i in 1:length(program)) {
          i
                
                #Load the data 
                  if (program[i]=="EPA"){
                    EPA <-read.csv("Data/EPA_subset.csv")
                    data <- as_tibble(EPA)
                  } else if (program[i]=="BLM") { 
                    url <- list(hostname = "gis.blm.gov/arcgis/rest/services",
                                scheme = "https",
                                path = "hydrography/BLM_Natl_AIM_AquADat/MapServer/0/query",
                                query = list(
                                  where = "1=1",
                                  outFields = "*",
                                  returnGeometry = "true",
                                  f = "geojson")) %>% 
                      setattr("class", "url")
                    request <- build_url(url)
                    BLM <- st_read(request)#Load the file from the Data file 
                    data <- as_tibble(BLM)
                  } else if (program[i]=="PIBO"){ 
                    PIBO <- read_xlsx("Data/PIBO_2013.xlsx", 2)
                    data <- as_tibble(PIBO)
                  } else if (program[i]== "AREMP") {
                    AREMP <- read.csv("Data/AREMP.csv")
                    data <- as_tibble(AREMP)
                  }
          
          #create a column name to reference 
          column <- paste0(program[i],"Column")
          c <- ((names(subset_metrics)==column)==TRUE)
          
          # Create a subset of metrics  
          program_metric_names <- as.data.frame(subset_metrics[c])
          
          #index of the locations where there is a column name 
          index = !is.na(program_metric_names)
          
          #Clear SubSetData variable 
          SubSetData <- 0
          
          #Subset the data from the master dataframe 
          SubSetData <- data %>%
            select(program_metric_names[index])
          
          #Rename to the standard columen names 
          colnames(SubSetData) <- short_names[index]
          
      
          #Use index to sub set the data_types to the set of metrics that are in the proram dataset
          p_data_types = data_types[index]
          
          #Assign a datatypes to each metric so it mactches the data frame   
          SubSetData[p_data_types== "Double"] <- sapply(SubSetData[p_data_types== "Double"], as.double)
          SubSetData[p_data_types== "Character"] <- sapply(SubSetData[p_data_types=="Character"], as.character)
          SubSetData[p_data_types== "Date"] <- sapply(SubSetData[p_data_types=="Date"], as.character)
          SubSetData[p_data_types== "Interger"] <- sapply(SubSetData[p_data_types=="Interger"], as.character)
          
          #add a columen for a UID in this dataset 
          #add a columen to id Program 
          SubSetData$Program <- program[i]
          #Add the program data to the full data set 
          all_data=bind_rows(all_data, SubSetData)
  }
          
        plot(all_data$BRLong, all_data$BRLat)
        
        all_data2 = all_data %>%
                        filter(!is.na(BRLat) & !is.na(BRLong))
                        
        return(all_data2)
        
        #Write data to a .csv
        write.csv(all_data, file="Data/All_Data.csv", row.names=FALSE)
        
        #Save to GEOJason 
        #locations <- data.frame(select(all_data2, one_of(c("BRLong", "BRLat"))))
                            
         #locations<-data.frame(c(all_data2$BRLong, all_data2$BRLat))
         #data<- select(all_data2, -contains("BR"))
         #spatial_data = SpatialPointsDataFrame(locations, data, proj4string = BLM_projection)
        
        #writeOGR(spatial_data,'Data/data_all.geojson', layer="data" , driver="GeoJSON")
        
        
}


