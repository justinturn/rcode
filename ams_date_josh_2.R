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

# Cattle Receipts
cattle.receipts_loc <- min(which(str_detect(report_raw, "[Cc]attle [Rr]eceipts")))
parse_cattlereceipts <- 
  function(x, variable){
    parse_number(str_extract(x, paste0("(?<=(", variable, ")\\: {1,10})[0-9,]{1,10}")))
  }

cattle.receipts <- 
  data_frame(
    This.Week = parse_cattlereceipts(report_raw[cattle.receipts_loc], "Cattle Receipts"),
    Last.Week = parse_cattlereceipts(report_raw[cattle.receipts_loc], "Last Week"),
    Last.Year = parse_cattlereceipts(report_raw[cattle.receipts_loc], "Last Year")
  )


# Percent of Supply ----
pct.of.supply_headerloc <- min(which(str_detect(report_raw, "[Pp]ercent [Oo]f [Ss]upply")))
pct.of.supply_raw <- report_raw[(pct.of.supply_headerloc+1):(pct.of.supply_headerloc+4)]
pct.of.supply_rownames <- str_extract(pct.of.supply_raw, "^[A-Za-z0-9 ]+(?=\\t)")
pct.of.supply_data <- str_sub(pct.of.supply_raw, nchar(pct.of.supply_rownames) + 1, nchar(pct.of.supply_raw))
pct.of.supply_data <- str_extract_all(pct.of.supply_data, "\\d{1,2}(?= {0,10}percent)")


parse_supply <- function(x){
  df <- as.data.frame(t(as.numeric(x)))
  names(df) <- c("This.Week", "Last.Week", "Last.Year")
  df
}

pct.of.supply_df <-
  bind_cols(
    data_frame(Cattle.Type = pct.of.supply_rownames),
    bind_rows(lapply(pct.of.supply_data, parse_supply))
  )

#Feeder Steer Prices

find.steer_header_location <- regexpr("Feeder Steers:(.*).",report_raw[32:40]) #finds header
steer.header <- regmatches(report_raw[32:40], findsteers) #takes the above and 

#parse prices
steer.price_headerloc <- min(which(str_detect(report_raw, "[Ff]eeder [Ss]teers:")))
steer.price_raw <- report_raw[(steer.price_headerloc+1):(steer.price_headerloc+8)] #plus 8 gives us 8 lines below that header
steer.price_rownames <- str_extract(steer.price_raw, "[0-9][0-9][0-9]-[0-9][0-9][0-9]") #gets steer weight classes
steer.price_data <- str_sub(steer.price_raw, nchar(steer.price_rownames) + 1, nchar(steer.price_raw)) #gets all the price data in raw
#steer.price_data <- str_extract_all(steer.price_data, "\\d+") #takes above and refines price data
steer.price_data <- str_extract_all(steer.price_data, "\\d+\\.*\\d*") #takes above and refines price data
#steer.price_data <- str_extract_all(steer.price_data, "\\d{1,6}(?= {0,10})") #takes above prices and makes list; writes over it
print (steer.price_data)  

##Issues: Still trying to get the weight classes correct and the prices need to be structured right. Missing the off color 250-300 lbs
##I think i should capture raw data then split by semicolon, then refine that subset

parse_steers <- function(x){
  df <- as.data.frame(t(as.numeric(x)))
  names(df) <- c("Weight.Class", "Price")
  df} 

steer.price_df <-
  bind_cols(
    data_frame(Weight.Class =steer.price_rownames),
    bind_rows(lapply(steer.price_data, parse_steers))
  )


#Attempt to get Date From the Top of the Report
#Looks for the MS in the second line

finddate <- regexpr("MS(.*)USDA",report_raw[1:3]) #trying to find date. number indicates character where match begins
string <-regmatches(report_raw[1:3], finddate)
location <- substr(report_raw[2],1,11) #moving to line 2, 
reportdate <- substr(report_raw[2],20,36) #moving to line 2,

cattle.receipts$Date <- reportdate

#Creates an Output File for the Cattle Receipts defined above
write.table(cattle.receipts,output_location,sep=",", row.names=FALSE, append= T)

#############
#END OF CODE#
#############