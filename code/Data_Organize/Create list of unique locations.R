# There are many environmental and anthropogenic factors that impact in-stream tributary habitat data. Co-variates need to be calculated for each data colletion locations, monitoring 
#programs often repeate locations. This script take the all_data file and strips it down to unique pairs of lat longitude 

# Sampling event table built based on the Darwin Core standard

library(openxlsx)
library(tidyverse)

data<- tbl_df((read.csv("Data/All_Data.csv")))
all_locations <- select(data, one_of(c("SiteID", "BRLat", "BRLong", "Program")))

locations <-data >%>
  group_by("BRLat")


