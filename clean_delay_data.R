library("lubridate")
library("plyr")




correct_classes_delaydata <- function(data) {
  
  ## correct date (convert existing collumns)
  dateformat <- "%d.%m.%y"
  data$betriebsdatum <- as.POSIXlt(data$betriebsdatum, format = dateformat)
  data$datum_von <- as.POSIXlt(data$datum_von, format = dateformat)
  data$datum_nach <- as.POSIXlt(data$datum_nach, format = dateformat)
  
  ## correct date-time (add collumns)
  data$datetime_soll_an_von <- as.POSIXlt(data$datum_von + data$soll_an_von)
  data$datetime_ist_an_von <- as.POSIXlt(data$datum_von + data$ist_an_von)
  data$datetime_soll_ab_von <- as.POSIXlt(data$datum_von + data$soll_ab_von)
  data$datetime_ist_ab_von <- as.POSIXlt(data$datum_von + data$ist_ab_von)
  
  data$datetime_soll_an_nach <- as.POSIXlt(data$datum_nach + data$soll_an_nach)
  data$datetime_ist_an_nach <- as.POSIXlt(data$datum_nach + data$ist_an_nach)
  data$datetime_soll_ab_nach <- as.POSIXlt(data$datum_nach + data$soll_ab_nach)
  data$datetime_ist_ab_nach <- as.POSIXlt(data$datum_nach + data$ist_ab_nach)
  
  return(data)
}

# ## example
# date <- as.POSIXlt("2016-05-18")
# thisfile <- date >= timeslots$from & date <= timeslots$to
# slot <- timeslots[thisfile, ]
# dat0 <- read.csv(paste0("data/delay_data", slot$filename), stringsAsFactors = FALSE)
# dat <- correct_classes_delaydata(dat0)



