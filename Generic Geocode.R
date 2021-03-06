#### Setup Libraries and Data. Note, you only need to install packages once. 
#### After that, you can delete those lines and keep only the ones that start with "library() ####

install.packages("plyr")
install.packages("maptools")
install.packages("dplyr")
install.packages("sp")
install.packages("rjson")
install.packages("ggmap")
install.packages("tigris")
install.packages("RCurl")
install.packages("rgdal")
install.packages("httr")
install.packages("leaflet")
install.packages("reshape2")
install.packages("acs")

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
library(acs)


#### Read in your Data and GIS file. #### 

dat <- read.csv("data/mydata.csv") # Read in your file with Addresses.
dat <- na.omit(dat) # leaves out rows with missing info.

syr <- tracts(state = 36, county = c("Onondaga",
                                     "Madison"),
                                     cb = TRUE) # Get a GIS file with shapes for Census Tracts in the counties you select.


#### Geocode addresses using Google Maps ####

# The following lines will take some time to run, depending on how many addresses you wish to geocode.
# Only need to run once, then you can eithe put a hashtag before the line (like in this sentence) 



########################################
mydata.coordinates <- geocode(     #####
  paste(dat$address,               #####
        dat$city,                  #####
        dat$state,                 #####
        sep = ", "))               #####
                                   #####
########################################


write.csv(mydata.coordinates, "geocoded.csv", row.names = FALSE) # This saves the table with coordinates.


mydata.coordinates <- read.csv("data/geocoded.csv") # Then you can read the coordinates table back in again.

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

mydata.tracts <- over(mydata.sp, syr, returnList = FALSE ) # This gets the Census Tract for the address.
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
  addCircleMarkers( 
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

#### SHow product C: A file with the census tract and the (count or rate) of what you want to measure.

mytract.data <- as.data.frame(df_merged)
mytract.data <- select(mytract.data, NAME, count)

mytract.data # this is the dataframe to show for product C.


#### Show Product D: A heatmap. ####
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






