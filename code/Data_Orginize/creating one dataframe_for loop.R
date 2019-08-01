#install.packages("dplyr") 
#install.packages('openxlsx')

library(dplyr)
library(openxlsx)

#Pull in the metadata file 
metadata <-as_tibble(read.xlsx("Data/Metadata.xlsx", 2))
SN <-select(metadata, c(ShortName,AREMPColumn, BLMColumn, EPAColumn, PIBOColumn))
SN <- as_tibble(lapply(SN, as.character))
program <-c('PIBO', 'BLM')

#Covnert blankes to missing values 
SN<-mutate_all(SN, funs(na_if(.,"")))

# Return a sub set of metrics that all 3 programs calculate 
subSN<-SN %>%
    mutate(count=rowSums(!is.na(SN))) %>%
    filter(count>=4)

#Create a variable holding the short names 
CN= subSN$ShortName

#Create a empty dataframe with the short names 
all_data <- data.frame(matrix(ncol = length(CN), nrow = 0))
colnames(all_data) <- CN


#For loop to add program data to one data set 
for(i in 1:length(program)) {
#Load the data 
  if (program[i]=="PIBO"){
    #Read in data from PIBO 
    PIBO <- read.xlsx("Data/PIBO_Summ_2013.xlsx",2)
    data <-as_tibble(PIBO)
  } else{ 
    #Load the file from the Data file 
    BLM <- read.csv("Data/BLM.csv")
    data <- as_tibble(BLM)
  }
  
  #create a column name to reference 
  column <- paste(program[i],"Column", sep='')
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

 }
  
#Write data to a .csv
write.csv(all_data, file="Data/All_Data.csv", row.names=FALSE)

