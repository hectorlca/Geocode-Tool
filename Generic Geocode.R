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

dat <- read.csv("data/mydata.csv") # Read in your file with Addresses.
dat <- na.omit(dat) # leaves out rows with missing info.

#### Product 1: The original file with GIS data appended to it. ####

### Download Shapefiles for Onondaga County ###
#Note: If you are looking at mapping adresses in a county other than Onondaga you must modify the 
#link addresses below to fit the FIPS code convention: State FIP code: 36, Onondaga FIP code: 067.

download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2010/TRACT/2010/tl_2010_36067_tract10.zip", "onondaga census tracts.zip" )
unzip( "onondaga census tracts.zip" )
file.remove( "onondaga census tracts.zip" )
syr <- readShapePoly( fn="tl_2010_36067_tract10", proj4string=CRS("+proj=longlat +datum=WGS84") )

# Remove files to keep folder clean.
file.remove("tl_2010_36067_tract10.dbf")
file.remove("tl_2010_36067_tract10.prj")
file.remove("tl_2010_36067_tract10.shp")
file.remove("tl_2010_36067_tract10.shp.xml")
file.remove("tl_2010_36067_tract10.shx")

#### Geocode addresses using Google Maps
# The following lines will take some time to run, depending on how many addresses you wish to geocode.

#HASHTAGGED OUT WHILE IN DEVELOPMENT AND NEED TO EXPLAIN HOW TO EITHER START FROM THIS LINE OR SKIP IT.

#mydata.coordinates <- geocode(paste(dat$address, dat$city, dat$state, sep = ", "))
#write.csv(mydata.coordinates, "geocoded.csv", row.names = FALSE)
mydata.coordinates <- read.csv("geocoded.csv")

### Prepare coordinates data to convert into points in order to plot them ###

mydata.withcoords <- cbind(dat, mydata.coordinates)
mydata.withcoords <- na.omit(mydata.withcoords)

to.sp <- data.frame(lon = mydata.withcoords$lon, lat = mydata.withcoords$lat)
mydata.sp <-  SpatialPoints(to.sp, proj4string=CRS("+proj=longlat +datum=WGS84") )

# Find out which tract each points fall into and append the census tract to original file.
mydata.tracts <- over(mydata.sp, syr, returnList= FALSE ) # This gets the Census Tract for the address.
mydata.withcoords$tract <- mydata.tracts$NAME10

# THIS COMPLETES PRODUCT A: THE ORIGINAL FILE, WITH GEOGRAPHIC INFO ATTACHED.
write.csv(mydata.withcoords, "data/mygeocodeddata.csv")


#### Product B: A map that plots your clients ####

# Aggregate how many entries per Census Tract to draw the heatmap.
mydata.list <- over(syr, mydata.sp, returnList = TRUE )
count <- sapply( mydata.list, length )
myclient.tracts <- data.frame( GEOID10=syr$NAME10, count=count ) # THIS IS FOR THE HEATMAP

########################

## Data and Map Setup Ends Here ##


################




