## Downloads the passenger counts data 


zip_url = 'https://data.stadt-zuerich.ch/dataset/vbz_fahrgastzahlen_ogd/resource/1d94f238-ac45-4829-8248-1c30b7a85623/download/fahrgastzahlen2014.zip'

zip_filename = './data/passenger_counts.zip'
download.file(zip_url, destfile=zip_filename)
unzip(zip_filename, exdir='./data/passenger_counts/')
unlink(zip_filename)
