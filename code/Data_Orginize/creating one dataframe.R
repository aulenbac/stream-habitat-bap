install.packages("dplyr") 
install.packages("readxl")

library(xlsx)
library(dplyr)


metadata<-as_tibble(read.xlsx2("Data/Metadata.xlsx", 2, header=TRUE))
SN <-select(metadata, c(ShortName,AREMPColumn., BLMColumn, EPAColumn, PIBOColumn))
SN <- as_tibble(lapply(SN, as.character))

#Covnert blankes to missing values 
SN<-mutate_all(SN, funs(na_if(.,"")))

# Return a sub set of metrics that all 3 programs calculate 
subSN<-SN %>%
    mutate(count=rowSums(!is.na(SN))) %>%
    filter(count>4)

#Create a variable holding the short names 
CN= subSN$ShortName

#Read in data from PIBO 
PIBO <- read.xlsx("Data/PIBO_Summ_2013.xlsx",2, header=TRUE)
PIBO <-as_tibble(PIBO)
# Create a subset of PIBO metrics for all of the programs 
PIBO_names<- subSN$PIBOColumn
PIBO_sub<-PIBO %>%
      select(PIBO_names)

#Rename to the standard columen names 
colnames(PIBO_sub)<-CN

#add a columen to id Program 
PIBO_sub$Program<-"PIBO"

#change data type of the ReachID and SiteID 
PIBO_sub$ReachID <- as.character(PIBO_sub$ReachID)
PIBO_sub$SiteID <- as.character(PIBO_sub$SiteID)

#Load the file from the Data file 
BLM <- read.csv("Data/BLM.csv")
BLM <- as_tibble(BLM)

#Subset out the columens that all programs calculate 
BLM_names <- subSN$BLMColumn
BLM_sub <- BLM %>%
      select(BLM_names)

#Rename BLM subset to the standard columen names 
colnames(BLM_sub)<-CN

#add a columen to id Program 
BLM_sub$Program<-"BLM"

BLM_sub$ReachID <- as.character(BLM_sub$ReachID)
BLM_sub$SiteID <- as.character(BLM_sub$SiteID)

# Create one dataset 
data <- as_tibble(rbind(BLM_sub, PIBO_sub))

#Write data to a .csv
write.csv(data, file="Data/All_Data.csv", row.names=FALSE)

