library("plyr")
source("get_data_links.R")


links_years <- list(links_2015, links_2016, links_2017)

## create directory, if not yet existent
if(!dir.exists("data/"))
  dir.create("data/")


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

timeslots <- ldply(links_years, get_available_timeslots)
timeslots$filename <- sapply(strsplit(timeslots$link, split = "/download/"), function(x) x[2])



download_delay_data <- function(date, timeslots = timeslots) {
  
  thislink <- date >= timeslots$from & date <= timeslots$to
  slot <- timeslots[thislink, ]
  download.file(slot$link, paste0("data/", slot$filename))
  
}


## pick a date and download the data set with the given date, e.g.
download_delay_data(date = as.POSIXct("2016-02-18"), timeslots = timeslots)




