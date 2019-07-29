install.packages("rgeos") 
install.packages("rgdal") 
install.packages("downloader")
install.packages("plyr") 
install.packages("dplyr") 
install.packages("ggplot2") 
install.packages("readxl")

library(rgeos)
library(rgdal)
library(downloader)
library(plyr)
library(dplyr)
library(ggplot2)
library(xlsx)


metadata=read.xlsx2("Data/Metadata.xlsx", 2, header=TRUE)
SN= select(metadata, c(ShortName,AREMPColumn., BLMColumn, EPAColumn, PIBOColumn))
#Covnert blaks to missing values 
SN=mutate_all(SN, funs(na_if(.,"")))

# Add a coumen to count the number of programs who calculate the metric 
subSN<- SN %>%
    mutate(count=rowSums(!is.na(SN))) %>%
    filter(count>=4)
 
###################################CLEAN UP ALL CODE AFTER THIS 


#Read in data from PIBO 
PIBO = read.csv(file='Projects/Habitat Data Sharing/PIBO/PIBO_Summ_2013.csv',header=TRUE)
PIBO_sub_names<- c("Lat", "Long","Stream", "i..SiteID", "Yr", "LWFrq", "PoolDp", "D50", "Bf", "Grad")
PIBO_sub<-select(PIBO, PIBO_sub_names)

#Create a file to store the data in
file_name=
variables <-c("Lat", "Long", "Name", "Site_ID","Date", "LWFreq", "RPD", "D50", "Bf", "Grad")

#Download the BLM file from the internet 

download.file("https://gis.blm.gov/AIMDownload/LayerPackages/BLM_AIM_AquADat.zip", "~/data/AquADat_Data.zip") 
unzip('/data/AquADat_Data.zip')
#Replace with filename
BLM	=	readOGR('data/AquADat_Data/BLM_AIM_AquADat/v104/AquADat_Data.gdb')

#For my computer 
#BLM = readOGR('Projects/USGS/Detail/Data/BLM_AIM_AquADat/BLM_AIM_AquADat/v104/AquADat_Data.gdb')
BLM =  as.data.frame(BLM)

#data<-data.frame(matrix(ncol=12, nrow=0))
#header <-c("Lat", "Long", "Name", "Site_ID","RchID", "Yr", "Date", "LWFreq", "RPD", "D50", "Bf", "Grad")
header <-c("Lat", "Long", "Name", "Site_ID","Date", "LWFreq", "RPD", "D50", "Bf", "Grad")
colnames(data)=header

#Create a subset of BLM data to be used in this anaysis 
BLM_sub_names<-c("BTMLAT", "BTMLONG","STRM_NM", "SITE_CD","DT","LWD_FREQ",  "RES_PL_DEP", "D50", "BNKFLL_WT", "SLPE")
BLM_sub<-select(BLM,BLM_sub_names)

#Add a columen defining the program
BLM_sub$program= "BLM" 

#rename the BLM_sub columen headers to the standard format for the anaysis package 
names(BLM_sub)[names(BLM_sub) == BLM_sub_names] <- header  

#while I don't have PIBO data
l=length(BLM_sub$program)
BLM_sub$program[(l/4):(l/2)]="AEM"
BLM_sub$program[(l/2)+1:(l/3)]="EPA"



data=BLM_sub
#figure out a way to add PIBO, EPA and AREMP to the data file 


data %>%
  group_by(program) %>% 
  summarize(RPD= sum(RPD))

#add a columen 
df %>%
	mutate(NEW_COL_NAME= variable) 



ggplot(data, aes(x=Date, y=RPD))+ geom_point()+facet_wrap(~program)
ggplot(data, aes(x=program, y=LWFreq))+geom_boxplot()



# Summarize the median GDP and median life expectancy per continent in 2007
by_continent_2007<- gapminder %>%
  filter(year==2007) %>%
  group_by(continent) %>%
  summarize(medianLifeExp=median(lifeExp), medianGdpPercap=median(gdpPercap))


# Use a scatter plot to compare the median GDP and median life expectancy
ggplot(by_continent_2007, aes(x=medianGdpPercap, y=medianLifeExp, color= continent))+
  geom_point()



# Summarize the median gdpPercap by year & continent, save as by_year_continent
by_year_continent <-gapminder %>%
              group_by(year, continent) %>%
              summarize(medianGdpPercap=median(gdpPercap))
                      


# Create a line plot showing the change in medianGdpPercap by continent over time
ggplot(by_year_continent, aes(x=year, y=medianGdpPercap, color=continent))+
      geom_line()+expand_limits(y=0)

