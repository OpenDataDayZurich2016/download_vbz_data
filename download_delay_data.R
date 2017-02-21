library("plyr")
source("get_data_links.R")



## create data directory, if not yet existent
if(!dir.exists("data/delay_data/"))
  dir.create("data/delay_data/")


## function to extract a data.frame with start and end time of a 
## given data set and the corresponding link
get_available_timeslots <- function(links = links_2016) {
  
  lks <- links$delay
  
  ## extract timestamp from link
  lsplit <- strsplit(lks, split = "sollist|.csv")
  timestmp <- sapply(lsplit, function(x) x[2])
  
  ## reformat in POSIXct
  data.frame(from = strptime(timestmp, format = "%Y%m%d"),
             to = strptime(substring(timestmp, first = 9), format = "%Y%m%d"),
             link = as.character(lks), stringsAsFactors = FALSE)
}


## get the time slots of data files for all three years currently available
timeslots <- ldply(links_years, get_available_timeslots)
timeslots$filename <- sapply(strsplit(timeslots$link, split = "/download/"), function(x) x[2])


## function to download the data set containing a given date
download_delay_data <- function(date, timeslots) {
  
  thislink <- date >= timeslots$from & date <= timeslots$to
  slot <- timeslots[thislink, ]
  download.file(slot$link, paste0("data/delay_data/", slot$filename))
  
}

write.csv(timeslots, file = "data/delay_data/timeslots_files.csv", row.names = FALSE)

## pick a date and download the data set with the given date, e.g.
# download_delay_data(date = as.POSIXct("2016-05-18"), timeslots = timeslots)

## download all available files !!! takes very long !!!
# lapply(timeslots$from, download_delay_data, timeslots = timeslots)




