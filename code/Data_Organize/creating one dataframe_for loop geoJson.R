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
        
        #open the the metadata file 
        metadata <- as_tibble(read_xlsx("Data/Metadata.xlsx", 3))
        SN <- select(metadata, c(Category, Name, ShortName,AREMPColumn, BLMColumn, EPAColumn, PIBOColumn, Subset_of_Metrics))
        SN <- as_tibble(lapply(SN, as.character))
        
        
        #Covnert blankes to missing values 
        SN<-mutate_all(SN, funs(na_if(.,"")))
  
        # Extract the subset of metrics we are focusing on in this work 
        subset_metrics <- SN %>% 
                        filter(Subset_of_Metrics== "x")
        
        #save the list of the subset of metrics
        write.csv(subset_metrics, file="Data/SubSetOfMetricNames.csv", row.names=FALSE)
        
        #Create a variable holding the short names 
        short_names= subset_metrics$ShortName
        
        #Create a empty dataframe with the short names 
        all_data <- data.frame(matrix(ncol = length(short_names), nrow = 0))
        colnames(all_data) <- short_names
        
        program <-c('PIBO', 'BLM', 'EPA')
        
        #For loop to add data from each program to one data set 
        for(i in 1:length(program)) {
          print(i) 
                
                #Load the data 
                  if (program[i]=="PIBO"){
                    #Read in data from PIBO 
                    PIBO <- read_xlsx("Data/PIBO_2013.xlsx", 2)
                    data <- as_tibble(PIBO)
                  } else if (program[i]=="BLM") { 
                    #Load the file from the Data file 
                    BLM <- read.csv("Data/BLM.csv")
                    data <- as_tibble(BLM)
                  } else { 
                    EPA<-read.csv("Data/EPA_subset.csv")
                    data<- as_tibble(EPA)
                    }
          
          #create a column name to reference 
          column <- paste0(program[i],"Column")
          c <- ((names(subset_metrics)==column)==TRUE)
          
          # Create a subset of metrics  
          program_names <- as.data.frame(subset_metrics[c])
          
          #index of the locations where there is a column name 
          index = !is.na(program_names)
          
          #Subset the data from the master dataframe 
          SubSetData <- data %>%
            select(program_names[index])
          
          #Rename to the standard columen names 
          colnames(SubSetData) <- short_names[index]
          
          #add a columen to id Program 
          SubSetData$Program <- program[i]
          
          #change data type of the ReachID and SiteID 
          SubSetData$ReachID <- as.character(SubSetData$ReachID)
          SubSetData$SiteID <- as.character(SubSetData$SiteID)
          
          #Add the program data to the full data set 
          all_data=bind_rows(all_data, SubSetData)
         
         
         }
          
        all_data2 = all_data %>%
                        filter(!is.na(BRLat) & !is.na(BRLong))
                        
        return(all_data2)
        
        #Write data to a .csv
        write.csv(all_data2, file="Data/All_Data.csv", row.names=FALSE)
        
        #Save to GEOJason 
        #locations <- data.frame(select(all_data2, one_of(c("BRLong", "BRLat"))))
                            
         #locations<-data.frame(c(all_data2$BRLong, all_data2$BRLat))
         #data<- select(all_data2, -contains("BR"))
         #spatial_data = SpatialPointsDataFrame(locations, data, proj4string = BLM_projection)
        
        #writeOGR(spatial_data,'Data/data_all.geojson', layer="data" , driver="GeoJSON")
        
        
}


