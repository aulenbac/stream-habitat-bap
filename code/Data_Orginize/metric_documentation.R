
library(jsonlite)

program <-c('PIBO', 'BLM', 'EPA')
metadata <-as_tibble(read.xlsx("Data/Metadata.xlsx", 2))


metric_name= "PctPool"

metric_information <-function(metric_name) {
  metric_index<- filter(metadata, ShortName==index)
  mr_index <- c(select(metric_index, contains('ShortName')), select(metric_index, contains('Method')))
  
  for(i in 2:length(mr_index)){
    print(i)
    id= mr_index[i]
    print(id)
    mr_method   <- paste0("https://www.monitoringresources.org/api/v1/methods/", id) 
    mr_method   <- URLencode(mr_method)
    method_text <-fromJSON(mr_method) 
    print(method_text$instructions)
    }
} 



