#Script Gets the Number of Page Likes for a Given Page#
#Last modified 5/19/17 by JMT#
import facebook
import datetime

# gettoken: http://stackoverflow.com/questions/3058723/programmatically-getting-an-access-token-for-using-the-facebook-graph-api

APP_ID = '439643413055447'
APP_SECRET = '5bf2516ab46d77519a17aa395e77369c'
token = 'EAAGP2nV2h9cBAHNilzgCwlrFvUfVxwrSZCQJONtMfnsjZALNuZAVberGi9Xoq1J6PGST15ZCceHZBijpxNDkzgGR6WlN5s9pcAW9kpLwPeruoziIguFpYjJsgPiNkaAknDjLyuiuzYaFFxXoPxNEzrcnxeKierdUZD'

fb_page_id = '5898823795'

graph = facebook.GraphAPI(access_token=token)

##Metrics we want#
#New_Like_Count equals new likes since admin has logged in
#Fans are the pages version of 'friends'
#Accountname is facebook page name

page = graph.get_object(fb_page_id, fields='id,name,fan_count, new_like_count')
fans = page.get('fan_count')
newlikes = page.get ('new_like_count')
accountname = page.get('name')

#Here's where the data will go#
f = open('F:/Finance/Tableau/Social Media Dashboard/Facebook Analytics/lcfb.txt', 'a')

f.write("%s,%s,%s,%s\n" % (accountname, fans, newlikes, datetime.datetime.now()))

#print page.get('fan_count')
