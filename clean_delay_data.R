library("lubridate")
library("plyr")

timeslots <- read.csv(file = "data/timeslots_files.csv", 
                      colClasses = c("factor", "POSIXct", "POSIXct", 
                                     "character", "character"))


correct_classes_delaydata <- function(data) {
  
  ## correct date (convert existing collumns)
  dateformat <- "%d.%m.%y"
  data$betriebsdatum <- strptime(data$betriebsdatum, format = dateformat)
  data$datum_von <- strptime(data$datum_von, format = dateformat)
  data$datum_nach <- strptime(data$datum_nach, format = dateformat)
  
  ## correct date-time (add collumns)
  data$datetime_soll_an_von <- data$datum_von + data$soll_an_von
  data$datetime_ist_an_von <- data$datum_von + data$ist_an_von
  data$datetime_soll_ab_von <- data$datum_von + data$soll_ab_von
  data$datetime_ist_ab_von <- data$datum_von + data$ist_ab_von
  
  data$datetime_soll_an_nach <- data$datum_nach + data$soll_an_nach
  data$datetime_ist_an_nach <- data$datum_nach + data$ist_an_nach
  data$datetime_soll_ab_nach <- data$datum_nach + data$soll_ab_nach
  data$datetime_ist_ab_nach <- data$datum_nach + data$ist_ab_nach
  
  return(data)
}

# ## example
# date <- as.POSIXlt("2016-05-18")
# thisfile <- date >= timeslots$from & date <= timeslots$to
# slot <- timeslots[thisfile, ]
# dat0 <- read.csv(paste0("data/", slot$filename), stringsAsFactors = FALSE)
# dat <- correct_classes_delaydata(dat0)

##' Create data.frames of a certain time frame.
##' This can take a while!!!
##' 
##' Data needs to already be stored on your disk in folder data/ from working 
##' directory.
##' 
##' @param from POSIXlt object with first timepoint to consider
##' @param to POSIXlt object with last timepoint to consider
##' @param which_info one of  "datetime_soll_an_von", "datetime_ist_an_von",   
##' "datetime_soll_ab_von",  "datetime_ist_ab_von",   "datetime_soll_an_nach", 
##' "datetime_ist_an_nach", "datetime_soll_ab_nach", "datetime_ist_ab_nach" 
##' @param mday integer, day of the month, if NULL all days are returne
##' @param wday integer, day of the week (0 = sunday, 1 = monday, ...), if NULL
##' all weekdays are returned
##' @param hour integer, hour of the day, if NULL all are returned
##' @param min integer, minute of the hour, if NULL all are returned
##' @param timeslots data.frame with time slot info on data files
import_clean_delaydata <- function(from = as.POSIXlt("2016-05-18 00:00:00 CEST"), 
                                   to = as.POSIXlt("2016-06-01 24:00:00 CEST"),
                                   which_info = "datetime_soll_an_von", 
                                   mday = NULL,
                                   wday = NULL,
                                   hour = NULL,
                                   min = NULL,
                                   timeslots) {
  
  ## select which data to load
  thisfiles <- timeslots$to >= from & timeslots$from <= to
  slots <- timeslots[thisfiles, ]
  
  ## load and clean data
  dat0 <- ldply(paste0("data/", slots$filename), read.csv, 
                stringsAsFactors = FALSE, .progress = "text")
  dat <- correct_classes_delaydata(dat0)
  
  ## pic lines of data relevant
  timeinfo <- as.POSIXlt(dat[[which_info]])
  thisrows <- timeinfo  >= from & timeinfo  <= to
  if(!is.null(mday)) thisrows <- thisrows & timeinfo$mday == mday
  if(!is.null(wday)) thisrows <- thisrows & timeinfo$wday == wday
  if(!is.null(hour)) thisrows <- thisrows & timeinfo$hour == hour
  if(!is.null(min)) thisrows <- thisrows & timeinfo$min == min
  return(dat[thisrows, ])
  
}


# ## example
# mydat <- import_clean_delaydata(from = as.POSIXlt("2016-05-18 00:00:00 CEST"), 
#                        to = as.POSIXlt("2016-06-01 24:00:00 CEST"),
#                        which_info = "datetime_soll_an_von",
#                        wday = 1, 
#                        timeslots = timeslots)
# # test if correct 
# table(mydat$datum_von$wday)

