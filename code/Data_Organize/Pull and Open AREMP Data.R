#get AREMP data from geodata 

install.packages("rgdal")
install.packages("downloader")
install.packages('sp')
install.packages('geojsonio')
library(rgdal)
library(downloader) 
library(sp)
library(sf)
library(tidyverse)
library(geojsonio)

wd=getwd()

projection<- "+proj=longlat +datum=WGS84 +no_defs"

#URL for the zip file containing the AREMP geodatabase 
fileURL<- "https://www.fs.fed.us/r6/reo/monitoring/watershed/NwfpWatershedCondition20yrReport.gdb.zip"

#Download the file to the Data file in the local repository 
download(fileURL, "Data/NwfpWatershedCondition20yrReport.gdb.zip" )

#Unzip the file into the Data file in the local repository
unzip("Data/NwfpWatershedCondition20yrReport.gdb.zip", exdir="Data")

#Define the file path to the geodata base, if the ARAMP changes their file structure this will need to be updated 
# Delete this after getting code to run coorecltly fgdb <- path.expand('Data/NwfpWatershedCondition20yrReport.gdb')
path <- '/Data/NwfpWatershedCondition20yrReport.gdb'
fgdb <- paste0(wd, path)

#invistigate the layers in the AREMP geodatabase 
subset(ogrDrivers(), grepl("GDB", name))
fc_list <- ogrListLayers(fgdb)

#load the locations, stream and habitat data from the ARAMP geodatabase file 
locations <- st_read(dsn=fgdb, layer= fc_list[10])
data <- st_read(dsn=fgdb, layer=fc_list[11])


#rename a columen in the data file so the locaitons and the data can be joined on that columen 
names(data)[names(data) == "site_id"] <- "SITE_ID"

#Join the location information and the metric data 
AREMP <- right_join(locations, data, by="SITE_ID")

#Transform to a standard system 
a_WGS84 <- st_transform(AREMP, crs="+proj=longlat +datum=WGS84 +no_defs")

#pull coordinates out of shapefile 
lat_long <- do.call(rbind, st_geometry(a_WGS84)) %>% 
  as_tibble(.name_repair = "unique") %>% setNames(c("longitude","lattitude", "c3", "c4"))

# create a table of the AREMP data with lat, and long 
table <- (st_geometry(AREMP)<- NULL)
AREMP_csv <- bind_cols(AREMP, lat_long)

write.csv(AREMP_csv, file="Data/AREMP.csv", row.names=FALSE)


#Save a GeoSJSON file 
st_write(a_WGS84,dsn="Data/AREMP.GeoJSON", layer="AREMP", driver="GeoJSON")


