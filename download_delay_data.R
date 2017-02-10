library("plyr")
source("get_data_links.R")


links_years <- list(links_2015, links_2016, links_2017)
data_dirs <- paste("data", 2015:2017, sep = "_")

## create directories, if not yet existent
lapply(data_dirs, function(ddir) {
  if(!dir.exists(ddir))
    dir.create(ddir)
})


get_available_timeslots <- function(links = links_2016) {
  
  lks <- links$delay
  
  ## extract timestamp from link
  lsplit <- strsplit(lks, split = "sollist|.csv")
  timestmp <- sapply(lsplit, function(x) x[2])
  
  ## reformat in POSIXct
  data.frame(from = strptime(timestmp, format = "%Y%m%d"),
             to = strptime(substring(timestmp, first = 9), format = "%Y%m%d"),
             link = lks)
}

timeslots <- ldply(links_years, get_available_timeslots)



download_delay_data <- function(date, timeslots = timeslots) {
  
  thislink <- date >= timeslots$from & date <= timeslots$to
  timeslots[thislink, ]
  
}

download_delay_data(date = as.POSIXct())




