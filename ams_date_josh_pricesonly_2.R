#################################
#FETCH AMS DATA FOR MS###########
#Created by Justin Turner########
#Last modified 9/13/17 by JMT####
#################################


##INPUTS TO MODIFY##
#Our AMS Report lives at this link: We define it here
url <- "https://www.ams.usda.gov/mnreports/jk_ls145.txt"
output_location = "C:/Users/justin.turner/Desktop/cattle.csv" #change this to wherever you want it to create a .csv
##END OF INPUTS##

#install.packages("readr", "stringr", "gridExtra") #Remove the hashtag up front to install (only need once)

  #Load the necessary packages into memory
library(readr); library(stringr); library(dplyr) ; library(gridExtra)

  #Now we will load the text into memory and assign it to a variable
report_raw <- read_lines(url)
  head(report_raw,5) #preview first 5 rows to ensure it loaded

###BEGIN STEER DATA PARSING###
  
find.steer_header_location <- regexpr("Feeder Steers:(.*).",report_raw[32:40]) #finds header
steer.header <- regmatches(report_raw[32:40], find.steer_header_location) #takes the above and 

  #parse prices
steer.price_headerloc <- min(which(str_detect(report_raw, "[Ff]eeder [Ss]teers:")))
steer.price_raw <- report_raw[(steer.price_headerloc+1):(steer.price_headerloc+8)] #plus 8 gives us 8 lines below that header
steer.price_rownames <- str_extract(steer.price_raw, "[0-9][0-9][0-9]-[0-9][0-9][0-9]") #gets steer weight classes

  #create dataframe of everything before each semicolon
steer.price_raw2 <-unlist(strsplit(steer.price_raw, split=";"))
steer.price_df <- data.frame(steer.price_raw2)

  #split columns by keyword 'lbs'
steer.price_df$weight <- lapply(strsplit(as.character(steer.price_df$steer.price_raw2), "lbs"), "[", 1)
steer.price_df$prices <- lapply(strsplit(as.character(steer.price_df$steer.price_raw2), "lbs"), "[", 2)
steer.price_df <- subset(steer.price_df, select = -c(steer.price_raw2)) #cleaning to price and weight only

  #final clean: need to remove whitespace blank rows

steer.price_df_final <- steer.price_df[!is.na(steer.price_df$prices),]

###END OF STEER DATA PARSING###
###BEGIN HEIFER DATA PARSING###

find.heifer_header_location <- regexpr("Feeder Heifers:(.*).",report_raw[30:50]) #finds header between line 30 and 50
heifer.header <- regmatches(report_raw[30:50], find.heifer_header_location) #takes the above and stores what it finds

#parse prices
heifer.price_headerloc <- min(which(str_detect(report_raw, "[Ff]eeder [Hh]eifers:")))
heifer.price_raw <- report_raw[(heifer.price_headerloc+1):(heifer.price_headerloc+7)] #plus 7 gives us 7 lines below that header
heifer.price_rownames <- str_extract(heifer.price_raw, "[0-9][0-9][0-9]-[0-9][0-9][0-9]") #gets heifer weight classes

#create dataframe of everything before each semicolon
heifer.price_raw2 <-unlist(strsplit(heifer.price_raw, split=";"))
heifer.price_df <- data.frame(heifer.price_raw2)

#split columns by keyword 'lbs'
heifer.price_df$weight <- lapply(strsplit(as.character(heifer.price_df$heifer.price_raw2), "lbs"), "[", 1)
heifer.price_df$prices <- lapply(strsplit(as.character(heifer.price_df$heifer.price_raw2), "lbs"), "[", 2)
heifer.price_df <- subset(heifer.price_df, select = -c(heifer.price_raw2)) #cleaning to price and weight only

#final clean: need to remove whitespace blank rows
heifer.price_df_final <- heifer.price_df[!is.na(heifer.price_df$prices),]

###END HEIFER PARSING###

#Attempt to get Date From the Top of the Report
#Looks for the MS in the second line

finddate <- regexpr("MS(.*)USDA",report_raw[1:3]) #trying to find date. number indicates character where match begins
regmatches(report_raw[1:3], finddate)
location <- substr(report_raw[2],1,11) #moving to line 2, 
reportdate <- substr(report_raw[2],20,38) #moving to line 2,

#attach date to dataframe
steer.price_df_final$date <- reportdate
heifer.price_df_final$date <- reportdate

#attach cattle type
steer.price_df_final$type <- "feeder steers"
heifer.price_df_final$type <- "feeder heifers"

#Now I'm adding both steers and heifers to one dataframe (matrix equivalent)
steerheifer_df <-rbind.data.frame(steer.price_df_final, heifer.price_df_final)

final_matrix = as.matrix(steerheifer_df)

#Creates an Output File for the Cattle Receipts defined above
write.table(final_matrix,output_location,sep=",", row.names=FALSE, append= T)

#############
#END OF CODE#
#############
