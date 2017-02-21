##' This is an example analysis of delays of mondays between 7 and 9 a.m. between
##' 2016-01-03 00:00:00 CEST and 2016-01-15 24:00:00 CEST
library("ggplot2")

source("clean_delay_data.R")
source("load_delay_data.R")

## load timeslots data.frame
timeslots <- read.csv(file = "data/delay_data/timeslots_files.csv", 
                      colClasses = c("factor", "POSIXct", "POSIXct", 
                                     "character", "character"))

## Download all available files !!! takes very long !!!
## If possible, take from USB stick
# source("download_delay_data.R")
# lapply(timeslots$from, download_delay_data, timeslots = timeslots)


## load data of given times
mydat <- import_clean_delaydata(from = as.POSIXlt("2016-01-03 00:00:00 CEST"),
                       to = as.POSIXlt("2016-01-15 24:00:00 CEST"),
                       which_info = "datetime_soll_an_von",
                       wday = 1,
                       hour = c(7, 8),
                       timeslots = timeslots)

## check 
table(mydat$betriebsdatum$wday)
table(as.POSIXlt(mydat$datetime_soll_an_von)$wday)
table(as.POSIXlt(mydat$datetime_soll_an_von)$hour)
range(mydat$datetime_soll_an_von)

## compute delays 
## (TODO: check what different datetimes mean ist_an_von versus ist_an_nach etc)
mydat$datetime_delay_an_von <- mydat$datetime_ist_an_von - mydat$datetime_soll_an_von
mydat$delay_an_von <- mydat$ist_an_von - mydat$soll_an_von

# should be TRUE
all.equal(mydat$delay_an_von, 
          as.double(mydat$datetime_delay_an_von, units = "secs"))


## plot
ggplot(mydat, aes(x = datetime_delay_an_von, color = factor(mydat$datetime_soll_an_von$hour))) + 
  geom_density(alpha = 0.2)
