install.packages("rgdal")
install.packages("downloader")
library(rgdal)
library(downloader) 

#URL Location of the AIM GeoDataBase if the location changes this will need to be updated 
fileURL<- "https://gis.blm.gov/AIMDownload/LayerPackages/BLM_AIM_AquADat.zip"

#Download the file to the Data file
download(fileURL, "Data/BLM.zip" )

#Unzip the file into the Data File 
unzip("Data/BLM.zip", exdir="Data")

#Define the file path to the geodata base, if the BLM changes their file structure this will need to be updated 
fgdb=path.expand('Data/BLM_AIM_AquADat/v104/AquADat_data.gdb')

#Read the Geodatabase layer into a file 
BLM <- data.frame(readOGR(dsn=fgdb))

#write the datafile to the datafile in the repository
write.csv(BLM,"Data/BLM.csv")
