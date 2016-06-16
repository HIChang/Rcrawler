##################################
####   Regular Expressions    ####
##################################

library(rvest)
library(httr)
 
## 以PTT八卦版標題為例
gossip <- GET("https://www.ptt.cc/bbs/Gossiping/index.html",
              set_cookies(over18=1))$content %>% read_html
(
  gossip_titles <- gossip %>% 
    html_nodes("div .title") %>% 
    html_text %>% 
    iconv(from="utf8", to="utf8") # for Windows
)

## replace取代功能
(gossip_titles_cleansed <- gsub("\n\t*", '', gossip_titles))


## filter 篩選功能
grep("問卦", gossip_titles_cleansed, value=TRUE) 
grep("^Re: ", gossip_titles_cleansed, value=TRUE)
grep("^Re: ", gossip_titles_cleansed, value=TRUE, invert=TRUE)
grep("^[^Re]", gossip_titles_cleansed, value=TRUE)


