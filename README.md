---
output: html_document
---
##Introduction

This guide is meant to show the steps used in a process to geocode a set of addresses onto a map. It is intended to be used by Nonprofit Organizations to track their clients. The tool **can** be used with other purposes in mind however. When the process is followed correctly, this tool will yield three 'products':

a) Your original file with three columns added: Latitude, Longitude, and the Census Tract in which the address falls.

b) An interactive map with dots overlaid. Each dot represents an address, or a client.

c) An interactive "heatmap", (formally a 'choropleth map') of whatever client characteristics you would like to map. Characteritics such as average weight, average age, employment, and education status are all examples of what a heatmap can show.

The tools will work with any dataset that contains addresses as long as they are entered in the correct format.

Although this process may seem daunting for a non-programmer, be patient and follow the steps carefully and you should reach the tools mentioned above.


## Getting your Data Ready:
 
Since its easier to go through this process using an example, we will be using a fake dataset listing randomly generated names along with randomly generated information about each client.

 
####The file should be structured in the following way:
 
 
![](http://i.imgur.com/x767Su7.jpg)


You **must** have your data saved as a CSV file. Otherwise, R won't be able to read your data.
CSV stands for 'Comma Separated Values'. In order to save a datasheet as a CSV file when you are in Excel, click 'Save as', name your file, and in the 'File type' dropdown box, select 'CSV (Comma Delimited).


### A note on the Google Maps API  
 In this tool, we will use R and RStudio to interface with Google Maps in order to convert addresses into a set of coordinates that will allow us to plot them on a map. There are two things to know regarding the Google Maps API:
 
1) Ocasionally Google Maps will not recognize an address. Two common causes are: 
    a) The address is a PO Box or b) the Apartment/Suite number is written at the beginning of the address or appears misplaced within         the address.
    
2) The Google Maps API only allows **2,500 requests** per day. If your data contains more than 2,500 addresses, you should look into       paying for more daily capacity. This case is unlikely with the intended audience for this tool.


###Getting started with R and RStudio

*First, you must download and install R, a free software environment for statistical computing and graphics. You may download it here: https://cran.rstudio.com/bin/windows/base/ . Use the predetermined settings to install R and click 'Next' until the installation is complete.
 
*Once you've downloaded and installed R, it's time to install RStudio. You can download it here: https://www.rstudio.com/products/rstudio/download/ . In this page you must select a version to download --  see which description fits your computer best and download that version. Once RStudio has finished installing, open it.
# 
####We're almost done installing. Once you have opened RStudio, it should look like this: 
 
  
![](http://i.imgur.com/xqGpmWm.jpg)
 
 
  
Once you're there, you can select the "Packages" tab located in the lower-right corner of the screen. Once the tab is selected, find and click the "Install" button.

####It should open a prompt window like this:
 
  
![](http://i.imgur.com/zfYIo8l.jpg)
  

Here, we need to fill out the empty box labeled "Packages". To do this, just copy and paste the following line into the box and then click 'Install'.

#### *plyr, maptools, dplyr, sp, rjson, ggmap, tigris, RCurl, rgdal, httr, leaflet, reshape2*


## Opening and Running the Script

To get started with the script, click on the following [link](https://raw.githubusercontent.com/hectorlca/Geocoding-Nonprofits/master/Generic%20Geocode.R?token=APMd8H_JktibNsjpEYjlhJTaBU9dnvRtks5YWo3nwA%3D%3D).





# I NEED TO LEAVE THIS HERE BECAUSE I NEED TO KEEP WORKING ON THE TOOL ITSELF, AS WELL AS THE CGLR TOOL THAT SHOWS THE TIME SERIES GRAPHS FOR EACH CENSUS TRACTS










   