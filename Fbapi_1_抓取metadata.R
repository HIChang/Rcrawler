##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## 抓取”me”所有metadata fields

library(httr)
library(rvest)

# the target API url
URL <- "https://graph.facebook.com/v2.6/me"

# a valid token
token <- "EAACEdEose0cBAO56mnYChqzW5uZBDsJdaV9rZBPOz3ZBlpO9DWpT5OQYLw0LaL8MQLkjftKev6Dyu88NqIiBG3eEnp7mmrxnQlZC2Kv7Jw9uXZA0x9tG3EgOpGZAXMbHLcOXtolOC2wnH7pZCqVmP23mZCR1nqUUNNWZA2Y3c4kkiDQZDZD"

# build the query string for the GET method
qs <- list(metadata=1, access_token=token)

# make the query
r <- GET(URL, query=qs)

# check the response
r
str(r, max.level=1)

# parse the resulting json data
parsed_contents <- content(r) # see ?content for more details
str(parsed_contents, max.level=2)

head(parsed_contents$metadata$fields,2)

# 抓取所有 fields
parsed_contents$metadata$fields %>%
  sapply(function(x) x[["name"]]) %>% 
  writeLines


## Try it!!
## 抓取所有me的edges (connections)

parsed_contents$metadata$connections %>% 
  names %>%
  writeLines