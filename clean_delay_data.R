library("lubridate")

timeslots <- read.csv(file = "data/timeslots_files.csv", 
                      colClasses = c("factor", "POSIXct", "POSIXct", 
                                     "character", "character"))


correct_classes_delaydata <- function(data) {
  
  ## correct date
  dateformat <- "%d.%m.%y"
  data$betriebsdatum <- strptime(data$betriebsdatum, format = dateformat)
  data$datum_von <- strptime(data$datum_von, format = dateformat)
  data$datum_nach <- strptime(data$datum_nach, format = dateformat)
  
  ## correct date-time
  data$datetime_soll_an_von <- data$datum_von + data$soll_an_von

  
}

date <- as.POSIXlt("2016-05-18")
date$wday


thisfile <- date >= timeslots$from & date <= timeslots$to
slot <- timeslots[thisfile, ]
data <- read.csv(paste0("data/", slot$filename), stringsAsFactors = FALSE)

