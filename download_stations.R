## Merge train/bus stop with the GPS data
library("rvest")
library('dplyr')

source("get_data_links.R")

## create data directory, if not yet existent
if(!dir.exists("data/"))
  dir.create("data/")


download_named_stations = function(link){
  station_names_url = grep('haltestelle', link$other, value=TRUE)
  station_points_url = grep('haltepunkt', link$other, value=TRUE)
  
  station_names = read.csv(station_names_url, dec=',', stringsAsFactors = FALSE)
  station_points = read.csv(station_points_url, dec=',', stringsAsFactors = FALSE)
  
  
  ## Only need active station points
  station_points = filter(station_points, halt_punkt_ist_aktiv=='True')
  
  
  ## Merge station names with station points
  named_station_points = left_join(station_points, station_names, by='halt_id')
  named_station_points
}

lapply(c('2015', '2016', '2017'), function(year){
  link = get(paste0('links_', year))
  named_stations = download_named_stations(link)
  write.csv(named_stations, sprintf('data/stations_%s.csv', year), row.names=FALSE)
})





