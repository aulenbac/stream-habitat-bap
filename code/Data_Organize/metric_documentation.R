metric_information <-function(metric_name) {
  
  install.packages("jsonlite")
  install.package("openxlsx")
  library(jsonlite)
  library(openxlsx)

  wd <- "C:/Users/rscully/Documents/Projects/Habitat Data Sharing/2019 Work/Code/tributary-habitat-data-sharing-"
  file_metadata <- paste0(wd,"/Data/Metadata.xlsx")
  
  # This should work, but I can't get it to work? 
  #wd= getwd()
  #file_metadata<- paste0(wd,'Data/Metadata.xlsx")

  metadata <-as_tibble(read.xlsx(file_metadata, 3)) #read in the metadata 
  metric_index<- filter(metadata, ShortName==metric_name)
  mr_index <- data.frame(select(metric_index, contains('ShortName')), select(metric_index, contains('CollectionMethod')))

  # add a row to put the text into 
  mr_index <- add_row(mr_index)

  i =0 #reset the index 
  for(i in 2:length(mr_index)){
          id= mr_index[1,i]
          if(!is.na(id)){ 
                mr_method    <- paste0("https://www.monitoringresources.org/api/v1/methods/", id) 
                mr_method    <- URLencode(mr_method)
                method_text  <- fromJSON(mr_method) 
                instruction  <-  method_text$instructions
                if (!is.null(instruction)){
                  mr_index[2,i]  <-  method_text$instructions
                } else { 
                    mr_index[2,i]= "NA"}
                    
               } 
  }
write    
return(mr_index)
} 


