#### Setup Libraries ####

library(plyr)
library(maptools)
library(dplyr)
library(sp)
library(rjson)
library(ggmap)
library(tigris)
library(RCurl)
library(rgdal)
library(httr)
library(leaflet)
library(reshape2)

#### Read your data into R ####

dat <- read.csv("C:/Users/hcorrales/Documents/Github/Geocoding-Nonprofits/data/mydata.csv") # Read in your file with Addresses.
dat <- na.omit(dat)

#### Download Shapefiles for your county ####

download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2010/TRACT/2010/tl_2010_36067_tract10.zip", "onondaga census tracts.zip" )
unzip( "onondaga census tracts.zip" )
file.remove( "onondaga census tracts.zip" )
syr <- readShapePoly( fn="tl_2010_36067_tract10", proj4string=CRS("+proj=longlat +datum=WGS84") )

#### Geocode addresses using Google Maps

mydata.coordinates <- geocode(paste(dat$address, dat$city, dat$state, sep = ", "))

write.csv(mydata.coordinates, "geocoded.csv", row.names = FALSE)
mydata.coordinates <- read.csv("geocoded.csv")

#### Prepare coordinates data to convert into points in order to plot them ####

mydata.withcoords <- cbind(dat, mydata.coordinates)
mydata.withcoords <- na.omit(mydata.withcoords)

to.sp <- data.frame(lon = mydata.withcoords$lon, lat = mydata.withcoords$lat)
mydata.sp <-  SpatialPoints(to.sp, proj4string=CRS("+proj=longlat +datum=WGS84") )

# Find out which tract each points fall into.

mydata.list <- over(syr, mydata.sp, returnList=T ) # This might be useful only in aggregating for the choropleth.
count <- sapply( mydata.list, length )
myclient.tracts <- data.frame( GEOID10=syr$GEOID10, count=count ) # this works for the choropleth

########################

## Data and Map Setup Ends Here ##


################




