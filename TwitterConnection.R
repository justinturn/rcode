##Connection Info##
#install.packages("twitteR","data.table", repos="http://cran.rstudio.com/") 
library("twitteR", "data.table")
require(data.table)
  
consumer_key <- "HuurwMMHUvuSNVXVp09vlaLvI"
consumer_secret <- "LxHkoCNZyZaWk4fVc503wIxkgo6v6nQ35FuKhO1Ztzl8OTz10p"
access_token <- "569538791-ysrvRNkkT2WF1JlKK5DBCqmTHLHGcQpzuEQ9bjSe"
access_secret <- "q6HGoqizgZf82GADqA3OfuuOVBBMX2FYbsH1zyubfBC3y"
options(httr_oauth_cache=T) #This will enable the use of a local file to cache OAuth access credentials between R sessions.
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)
##END##

##Page Info##
lifechurch <- getUser("lifechurch")
location(lifechurch)
##END PAGE INFO##

lcfollowers<-lifechurch$getFollowers(retryOnRateLimit=200)
#print (length(lcfollowers))

lc_followers_df = rbindlist(lapply(lcfollowers, as.data.frame))

lc_followers_matrix <- data.matrix(lc_followers_df, rownames.force=NA)

head(lc_followers_df$location,10) 

write.csv(lc_followers_df,"C:/Users/justin.turner/Desktop/twitterfollowers.csv")
