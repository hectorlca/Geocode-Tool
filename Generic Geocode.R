#### Setup Libraries and Data ####

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



dat <- read.csv("data/mydata.csv") # Read in your file with Addresses.
dat <- na.omit(dat) # leaves out rows with missing info.

#####  Product A: Substituted FTP download for tigris tracts() ####

#START TIGRIS Work
syr <- tracts(state = 36, county = 67, cb = TRUE) # from tigris


# Geocode addresses using Google Maps
# The following lines will take some time to run, depending on how many addresses you wish to geocode.

#HASHTAGGED OUT WHILE IN DEVELOPMENT AND NEED TO EXPLAIN 
#HOW TO EITHER START FROM THIS LINE OR SKIP IT.


##### GOOGLE MAPS GEOCODE #### T

mydata.coordinates <- geocode(paste(dat$address, dat$city, dat$state, sep = ", "))
#write.csv(mydata.coordinates, "geocoded.csv", row.names = FALSE)


mydata.coordinates <- read.csv("geocoded.csv")

### Prepare coordinates data to convert into points in order to plot them ###

mydata.withcoords <- cbind(dat, mydata.coordinates)
mydata.withcoords <- na.omit(mydata.withcoords)

to.sp <- data.frame(lon = mydata.withcoords$lon, lat = mydata.withcoords$lat)
mydata.sp <-  SpatialPoints(to.sp, 
                            proj4string = CRS("+proj=longlat
                                              +datum=NAD83 
                                              +no_defs 
                                              +ellps=GRS80 
                                              +towgs84=0,0,0") )

# Find out which tract each point fall into and append the census tract number to original file.
mydata.tracts <- over(mydata.sp, syr, returnList= FALSE ) # This gets the Census Tract for the address.
mydata.withcoords$tract <- mydata.tracts$NAME



#### This completes product A: The original file, with coordinates and census tracts. ####
write.csv(mydata.withcoords, "data/mygeocodeddata.csv", row.names = FALSE)
mygisdata <- read.csv("data/mygeocodeddata.csv")


#### Product B: A map that plots your clients ####


syr.map <- 
  leaflet(data = data.frame(lon = -76.148223, lat = 43.024003)) %>% 
  addProviderTiles("Esri.WorldStreetMap", tileOptions(minZoom=10, maxZoom=18))  %>%
  setView(lng=-76.13, lat=43.03, zoom=13) %>%
  setMaxBounds(lng1=-75, lat1=41, lng2=-77,  lat2=45) %>%
  addCircleMarkers( icon = myIcon,
    lng = mygisdata$lon, lat = mygisdata$lat, 
                   clusterOptions = markerClusterOptions(),
                   popup = paste(sep = "<br/>", mygisdata$name, mygisdata$address, 
                                 (paste("Census Tract: ", mygisdata$tract))),
                   radius=10, stroke = TRUE, color = "steelblue", weight = 8, opacity = 0.7)




#### Show Product B ####

syr.map






#### Product C: A heatmap of which Census Tracts your clients are located in. ####

# Aggregate how many entries per Census Tract to draw the heatmap.

mydata.list <- over(syr, mydata.sp, returnList = TRUE )
count <- sapply( mydata.list, length )
myclient.tracts <- data.frame( GEOID10=syr$NAME, count=count ) # THIS IS FOR THE HEATMAP

# Append the client count to the Shapefile.
df_merged <- geo_join(syr, myclient.tracts, "NAME", "GEOID10") 


#### Show Product C: A heatmap. ####
popup <- paste0("Census Tract: ", df_merged$NAME, "<br>", 
                "Number of Clients here: ", df_merged$count, ".", "<br>",
                "THE INFO I WANT TO SEE")

pal <- colorNumeric(
  palette = "Blues",
  domain = df_merged$count
)

leaflet() %>%
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng=-76.13, lat=43.03, zoom = 12) %>%
  addPolygons(data = df_merged, 
              fillColor = ~pal(count), 
              color = "gray80", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1.5, 
              smoothFactor = 0.2,
              popup = popup) %>%
  
  addLegend(pal = pal, 
            values = df_merged$count, 
            position = "bottomright", 
            title = "# of Clients",
            labFormat = labelFormat(suffix = "")) 






