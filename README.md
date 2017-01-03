---
title: "Geocoding for Nonprofits"
author: "Documentation Prepared by Hector Corrales, Program Officer"
date: "Central New York Community Foundation"
output: html_document
---

## Introduction to Open Source Geocoding

***

Organizations increasingly find themselves collecting data on their daily activities and data about the people they serve. These data collection processes have the potential to be harnessed for insights into a community's "pulse" in a given area. However, Nonprofit organizations function in an environment of limited financial and human resources. 

The Central New York Community Foundation is heavily invested in building capacity of the Nonprofit community in CNY and has developed this open source tool, free of charge, and (we hope) easily usable by people with a working knowledge of Microsoft Excel, or other spreadsheet software. 

This document walks a user through the necessary steps to geocode a set of addresses. The tool, or "script" will arrange and display the given info in three ways:

a) The original Excel file with three columns added: Latitude, Longitude, and the Census Tract in which the address falls.

b) An interactive map with dots overlaid. Each dot represents an address, or a client. Information about the client can be included so when the dot is clicked, information about the client will pop up.

c) Lastly, an interactive "heatmap", (formally a 'choropleth map') of whatever client characteristics you would like to map. Characteritics such as average weight, average age, employment, and education status are all examples of what a heatmap can show. Information about the **Census Tract** can be included in this interactive map. Clicking on the shape of a Census Tract will provide you with mote data about that specific tract. For example:  

***
<center>![](http://imgur.com/UMKaTHw.jpg)</center>
***

It is intended to be used by Nonprofit Organizations to track their clients. The tool **can** be used with other purposes in mind however. When the process is followed correctly, this tool will yield three 'products':
The tools will work with any dataset that contains addresses as long as they are entered in the correct format.

Although this process may seem daunting for a non-programmer, be patient and follow the steps carefully and you should reach the tools mentioned above.

***



### 1) Getting started with R and RStudio

First, you must download and install R, a free software environment for statistical computing and graphics. You may download it here: https://cran.rstudio.com/bin/windows/base/ . Use the predetermined settings to install R and click 'Next' until the installation is complete.
 
Once you've downloaded and installed R, it's time to install RStudio. You can download it here: https://www.rstudio.com/products/rstudio/download/ . In this page you must select a version to download --  see which description fits your computer best and download that version. Once RStudio has finished installing, open the program.
***

##### We're almost done installing. Once you have opened RStudio, locate the pane that is in the lower right corner of the screen.

*** 
<center>![](http://i.imgur.com/xqGpmWm.jpg)</center>
***
  
Once you've located the pane, select the "Packages" tab. Once the tab is selected, find and click the "Install" button.

It should open a prompt window like this:

*** 
  
<center>![](http://i.imgur.com/zfYIo8l.jpg)</center>
  
***
Here, we need to fill out the empty box labeled "Packages". To do this, just copy and paste the following line into the box and then click 'Install'.  

```{r}
plyr, maptools, dplyr, sp, rjson, ggmap, tigris, RCurl, rgdal, httr, leaflet, reshape2
```
 
 
If you are confused by this step, it's ok. You just need to know that installing these "packages" is a way to expand the functionality of **R**, and is a necessary step in order for this tool to get to its final three products.

***

### 2) Getting the script onto your computer.

Now that we have R installed, we have to load the script itself so that it can run locally in your computer and pull the data from *your* file. The following steps will copy the script onto your computer and get it ready for your use.

**Step 1**

Create a folder in your PC. Name it whatever you like and place it somewhere where you can find it easily for future use. Take note of the file path where you are creating the folder, since we will need it later. As you can see in the image below, I've created a new folder called **"My Geocoding Tool"**. The filepath is in the top bar. 

***
<center>![](http://imgur.com/fG0hHPE.jpg)</center>
***

**Step 2**  

Once the folder has been created, [download the script from this link and open it.](https://github.com/hectorlca/Geocode-Tool/archive/master.zip)  
Now, double click on the downloaded ZIP file (if it did not open automatically) and extract all the files to the folder that you created in Step 1.

Your folder should now look like this:

***
<center>![](http://imgur.com/AnxFNL4.jpg)</center>
***

### 3) Getting your Data in the right format:  
   
Since its easier to go through this process using an example, we will be using a fake dataset listing randomly generated names along with randomly generated information about each client.

 
The file should be structured in the following way:  

***

<center>![](http://i.imgur.com/x767Su7.jpg)</center>

***


You **must** have your data saved as a CSV file. Otherwise, R won't be able to read your data.
CSV stands for 'Comma Separated Values'. In order to save a datasheet as a CSV file when you are in Excel, click 'Save as', name your file, and in the 'File type' dropdown box, select *"CSV (Comma Delimited)".*

##### A note on the Google Maps API  

In this tool, we will use R and RStudio to interface with Google Maps in order to convert addresses into a set of coordinates that will allow us to plot them on a map. There are two things to know regarding the Google Maps API:
 
1) Ocasionally Google Maps will not recognize an address. Two common causes are: 
    a) The address is a PO Box or b) the Apartment/Suite number is written at the beginning of the address or appears misplaced within         the address.
    
2) The Google Maps API only allows **2,500 requests** per day. If your data contains more than 2,500 addresses, you should look into       paying for more daily capacity. This case is unlikely with the intended audience for this tool.

***
 
Okay, now we're ready to get our data in the right place and run the script. 



Due to the nature of this tool, the user cannot escape at least some interaction with the code that makes it run. The most obvious way 
This section digs deeper into the first
