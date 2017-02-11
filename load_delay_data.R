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
##' @param mday integer vector, days of the month, if NULL all days are returned;
##' for this and the following parameters see ?POSIXlt
##' @param wday integer vector, days of the week (0 = sunday, 1 = monday, ...), if NULL
##' all weekdays are returned
##' @param hour integer vector, hours of the day, if NULL all are returned
##' @param min integer vector, minutes of the hour, if NULL all are returned
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
  filenams <- slots$filename
  
  ## check if files are in data folder
  if(!all(file.exists(paste0("data/", filenams)))) 
    stop("At least one the files \n", paste(filenams, collapse = "\n"), 
         "\nis not in the folder ", getwd(), "/data/",
         "\nplease download from \n", paste(slots$link, collapse = "\n"))
  
  ## load and clean data
  dat0 <- ldply(paste0("data/", filenams), read.csv, 
                stringsAsFactors = FALSE, .progress = "text")
  dat <- correct_classes_delaydata(dat0)
  
  ## pic lines of data relevant
  timeinfo <- dat[[which_info]]
  thisrows <- timeinfo  >= from & timeinfo  <= to
  if(!is.null(mday)) thisrows <- thisrows & timeinfo$mday %in% mday
  if(!is.null(wday)) thisrows <- thisrows & timeinfo$wday %in% wday
  if(!is.null(hour)) thisrows <- thisrows & timeinfo$hour %in% hour
  if(!is.null(min)) thisrows <- thisrows & timeinfo$min %in% min
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