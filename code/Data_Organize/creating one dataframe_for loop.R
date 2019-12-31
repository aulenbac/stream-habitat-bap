#install.packages("dplyr") 
#install.packages('openxlsx')

one_data_frame <- function() {
        library(dplyr)
        library(openxlsx)
        
        
        #Load the list of metric names create from the metadata 
        subSN<- read.csv(path.expand("Data/SubSetOfMetricNames.csv")) 
        
        #Create a variable holding the short names 
        CN= subSN$ShortName
        
        #Create a empty dataframe with the short names 
        all_data <- data.frame(matrix(ncol = length(CN), nrow = 0))
        colnames(all_data) <- CN
        
        program <-c('PIBO', 'BLM', 'EPA')
        
        #For loop to add data from each program to one data set 
        for(i in 1:length(program)) {
          i 
        #Load the data 
          if (program[i]=="PIBO"){
            #Read in data from PIBO 
            PIBO <- read.xlsx("Data/PIBO_Summ_2013.xlsx",2)
            data <-as_tibble(PIBO)
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
          c<-((names(subSN)==column)==TRUE)
          
          # Create a subset of metrics  
          program_names<- as.data.frame(subSN[c])
          
          #index of the locations where there is a column name 
          index= !is.na(program_names)
          
          #Subset the data from the master dataframe 
          SubSetData<-data %>%
            select(program_names[index])
          
          #Rename to the standard columen names 
          colnames(SubSetData)<-CN[index]
          
          #add a columen to id Program 
          SubSetData$Program<-program[i]
          
          #change data type of the ReachID and SiteID 
          SubSetData$ReachID <- as.character(SubSetData$ReachID)
          SubSetData$SiteID <- as.character(SubSetData$SiteID)
          
          #Add the program data to the full data set 
          all_data=bind_rows(all_data, SubSetData)
          
          program[i]
        
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


