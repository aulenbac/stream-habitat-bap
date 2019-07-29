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

library(ggplot2)


library(xlsx)
library(dplyr)


metadata<-as_tibble(read.xlsx2("Data/Metadata.xlsx", 2, header=TRUE))
SN <-select(metadata, c(ShortName,AREMPColumn., BLMColumn, EPAColumn, PIBOColumn))
SN <- as_tibble(lapply(SN, as.character))

#Covnert blaks to missing values 
SN<-mutate_all(SN, funs(na_if(.,"")))

# Return a sub set of metrics that all 3 programs calculate 
subSN<-SN %>%
    mutate(count=rowSums(!is.na(SN))) %>%
    filter(count>=4)

#Create a variable holding the short names 
CN= subSN$ShortName


###################################CLEAN UP ALL CODE AFTER THIS 


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
PIBO_sub$Program="PIBO"

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
BLM_sub$Program="BLM"

# Create one dataset 
data <- rbind(BLM_sub, PIBO_sub)

data %>%
  group_by(Program) %>% 
  summarize(mean(Grad, na.rm = TRUE))

#add a columen 
df %>%
	mutate(NEW_COL_NAME= variable) 



ggplot(data, aes(x=RchLen, y=Grad))+ geom_point()+facet_wrap(~Program)
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

