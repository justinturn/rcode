##Connection Info##
#install.packages("twitteR","data.table", repos="http://cran.rstudio.com/") 
library("twitteR", "data.table")
require(data.table)
  
consumer_key <- "ENTER HERE"
consumer_secret <- "ENTER HERE"
access_token <- "ENTER HERE"
access_secret <- "ENTER HERE"
options(httr_oauth_cache=T) #cache OAuth credentials between R sessions.
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)
##END##

##Page Info##
lifechurch <- getUser("turnerjustinm")
location(lifechurch)
##END PAGE INFO##

lcfollowers<-lifechurch$getFollowers(retryOnRateLimit=200) #this could take a while here
#print (length(lcfollowers))

lc_followers_df = rbindlist(lapply(lcfollowers, as.data.frame))

lc_followers_matrix <- data.matrix(lc_followers_df, rownames.force=NA)

head(lc_followers_df$location,10) 

write.csv(lc_followers_df,"C:/Users/justin.turner/Desktop/twitterfollowers.csv") #here's your output dump. 
