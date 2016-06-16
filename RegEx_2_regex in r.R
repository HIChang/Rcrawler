##################################
####   Regular Expressions    ####
##################################

#### RegEx in R

## 以八卦版標題為例
library(rvest)
library(httr)
gossip <- GET("https://www.ptt.cc/bbs/Gossiping/index.html",
              set_cookies(over18=1))$content %>% read_html
gossip_titles <- gossip %>% 
  html_nodes("div .title") %>% 
  html_text %>% 
  iconv(from="utf8", to="utf8") # for Windows
(gossip_titles_cleansed <- gsub("\n\t*", '', gossip_titles))

## base::grep and base::grepl
#    grep: 傳回篩選後位置or篩選後原始數值
#    grepl: 傳回boolean值
grep("^Re: ", gossip_titles_cleansed)  # return numeric index
gossip_titles_cleansed[grep("^Re: ", gossip_titles_cleansed)] # then can used as selecting vector
grep("^Re: ", gossip_titles_cleansed, value=TRUE)
grep("^Re: ", gossip_titles_cleansed, value=TRUE, invert=TRUE)
grepl("^Re: ", gossip_titles_cleansed)

## base::gsub
#    gsub: 全部取代/刪除
gsub("\\].*", '', gossip_titles_cleansed)
gsub("^.*\\[", '', gossip_titles_cleansed)
gsub("\\].*|^.*\\[", '', gossip_titles_cleansed)

### R Crawler Week2 Example - 全家FamilyMart (店舖查詢)
# http://leoluyi.github.io/RCrawler101_201605_Week2/resources/example/family_mart.html
# ...
# jsonDataString <- resStr %>%
#   sub("^[^\\[]*","",.) %>%
#   sub("[^\\]]*$","",.)

(test="showStoreList([Message...])")
sub("^[^\\[]*","",test)
sub("[^\\]]*$","",test)
test %>% sub("^[^\\[]*","",.) %>% sub("[^\\]]*$","",.)

## stringr package
#    str_extract and str_match: 尋找符合條件的部分
#    str_extract_all and str_match_all: 存成list 格式
library(stringr)
str_extract(gossip_titles_cleansed, "\\[問卦\\]")
# grep("\\[問卦\\]", gossip_titles_cleansed)
# grep("\\[問卦\\]", gossip_titles_cleansed, value=TRUE)

str_extract(gossip_titles_cleansed, "\\[問卦\\].*")
str_extract(gossip_titles_cleansed, "\\[(.*)\\]")
str_extract_all(gossip_titles_cleansed, "\\[(.*)\\]")


str_match(gossip_titles_cleansed, "\\[(.*)\\]")
str_match(gossip_titles_cleansed, "Re: \\[(.*)\\]")
str_match(gossip_titles_cleansed, "\\[(.?)(.?)\\]")
str_match_all(gossip_titles_cleansed, "\\[(.?)(.?)\\]")
