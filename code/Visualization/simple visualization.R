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

data<- read.csv("Data/All_data.csv")

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

