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



#install.packages("readr", "strinr", "gridExtra") #Remove the hashtag up front to install (only need once)

#Load the necessary packages into memory
library(readr); library(stringr); library(dplyr) ; library(gridExtra)

#Now we will load the text into memory and assign it to a variable
report_raw <- read_lines(url)
head(report_raw,5) #preview first 5 rows to ensure it loaded


find.steer_header_location <- regexpr("Feeder Steers:(.*).",report_raw[32:40]) #finds header
steer.header <- regmatches(report_raw[32:40], find.steer_header_location) #takes the above and 

#parse prices
steer.price_headerloc <- min(which(str_detect(report_raw, "[Ff]eeder [Ss]teers:")))
steer.price_raw <- report_raw[(steer.price_headerloc+1):(steer.price_headerloc+8)] #plus 8 gives us 8 lines below that header
steer.price_rownames <- str_extract(steer.price_raw, "[0-9][0-9][0-9]-[0-9][0-9][0-9]") #gets steer weight classes
steer.price_data <- str_sub(steer.price_raw, nchar(steer.price_rownames) + 1, nchar(steer.price_raw)) #gets all the price data in raw
steer.price_data <- str_extract_all(steer.price_data, "\\d+\\.*\\d*") #takes above and refines price data

#test
#steer.price_weights <- str_extract_all(steer.price_raw,"[0-9][0-9][0-9]-[0-9][0-9][0-9]", simplify=TRUE)
steer.price_weights <- str_extract_all(steer.price_raw,"", simplify=TRUE)
test <- str_split(steer.price_raw,";")

print(steer.price_raw)