## PLAY

library('dplyr')
library('ggplot2')
library('ggmap')
library('leaflet')
library('animation')

## Change here to data directory
setwd('~/repos/download_vbz_data/')

dat = read.csv('data/delay_data/fahrzeitensollist2016102320161029.csv', stringsAsFactors = FALSE)

stations = read.csv('data/delay_data/stations_2017.csv')
stations = select(stations, halt_punkt_id, GPS_Longitude, GPS_Latitude)


dat$delay_already = (dat$ist_ab_von - dat$soll_ab_von)/60
dat$delay_at_segment = (dat$ist_an_nach - dat$soll_an_nach)/60

delay_by_station = dat %>%
  dplyr::group_by(betriebsdatum, linie, seq_von, halt_punkt_id_von, halt_punkt_id_nach) %>%
  dplyr::summarize(avg_delay=mean(delay_at_segment)) %>%
  ungroup() %>%
  arrange(linie, seq_von) 
## delay_by_station = filter(delay_by_station, linie==32)



delay_by_station = left_join(delay_by_station, 
                             stations, by=c('halt_punkt_id_von'='halt_punkt_id')) %>% 
  rename(GPS_Longitude.von=GPS_Longitude, GPS_Latitude.von=GPS_Latitude)

delay_by_station = left_join(delay_by_station, stations, 
                             by=c('halt_punkt_id_nach'='halt_punkt_id')) %>% 
  rename(GPS_Longitude.nach=GPS_Longitude, GPS_Latitude.nach=GPS_Latitude)


delay_by_station$avg_delay[delay_by_station$avg_delay < 0] = 0

delay_by_station$abs_delay = delay_by_station$avg_delay / max(delay_by_station$avg_delay)   


zurich <- get_map("Zurich,Switzerland", zoom=13, color = 'bw', maptype = 'satellite')




ggmap(zurich) + geom_segment(data = delay_by_station, aes(x=GPS_Longitude.von,
                                                          xend=GPS_Longitude.nach,
                                                          y=GPS_Latitude.von,
                                                          yend=GPS_Latitude.nach, group = linie, 
                                                          color=avg_delay, 
                                                          alpha=abs_delay)) +
  scale_color_continuous(low='white', high='red') + 
  scale_alpha_continuous(range=c(0, 1)) #+ facet_wrap(~betriebsdatum)

