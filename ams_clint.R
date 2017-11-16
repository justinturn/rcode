#################################
#FETCH USDA MARKET NEWS DATA ####
#Created by Justin Turner########
#Last modified 10/17/17 by JMT####
#################################


##INPUTS TO MODIFY##

xml<-"https://www.marketnews.usda.gov/mnp/fv-report-top-filters?&commAbr=APL&shipNavClass=&portal=fv&repType=termPriceDaily&movNavClass=&Go=Go&locName=&type=termPrice&navClass=%2C&organic=&navType=byComm&environment=&varName=&locAbr=&volume=&stateID=&commName=APPLES&termNavClass=&repDate=10%2F16%2F2017&endDate=10%2F16%2F2017&format=xml&rebuild=false"
output_location = "C:/Users/justin.turner/Desktop/amsreport.csv" #change this to wherever you want it to create a .csv
##END OF INPUTS##

library(readr); library(stringr); library(dplyr) ; library(gridExtra) 

xml <- read_lines(xml)
require(XML)
apples <- xmlParse(xml)
apples_2 <- xmlToDataFrame(apples)


######################
#Output to PostGres DB
######################
require("RPostgreSQL")

# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
pw <- {
  "jT123456"
}

# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "AMS",
                 host = "146.148.56.79", port = 5432,
                 user = "justinturn", password = pw)
rm(pw) # removes the password

dbWriteTable(con, "ams_apples", 
             value = apples_2, append = TRUE, row.names = FALSE)

#df_postgres <- dbGetQuery(con, "SELECT * from cartable") # if you want to query 

