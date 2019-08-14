#Create a subset of the metrics from the 4 programs to use in creating a dataframe and pulling data from the datasets to create one dataframe 

install.packages('tidyverse')
library(tidyverse)
library(openxlsx)

metrics<- function() {
    #Pull in the metadata file 
    metadata <-as_tibble(read.xlsx("Data/Metadata.xlsx", 2))
    SN <-select(metadata, c(ShortName,AREMPColumn, BLMColumn, EPAColumn, PIBOColumn))
    SN <- as_tibble(lapply(SN, as.character))
    
    #Covnert blankes to missing values 
    SN<-mutate_all(SN, funs(na_if(.,"")))
    
    # Return a sub set of metrics that all 3 programs calculate 
    subSN<-SN %>%
      mutate(count=rowSums(!is.na(SN))) %>%
      filter(count>=4)
    
    #save the list of variables 
    write.csv(subSN, file="Data/SubSetOfMetricNames.csv", row.names=FALSE)
  
    print(subSN)
    
    
} 

    