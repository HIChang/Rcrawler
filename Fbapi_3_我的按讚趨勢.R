##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## 我的按讚趨勢
## 抓取特定時間內，所有文章的文章按讚者資料

token <- "EAACEdEose0cBAPub4H52OMmT0ZActfSCVHYd4nWOM01FxJquq6qPLkZB0WWACrqj9b5eDYZCpyVE13aN9PbH8SlohQASL6VW0KrQp9YHh6glBvPwUxyKATOV8PPE3yzLX3lHJ72AHBlGx8wksSZAXc6mdFdFmzZA60m8LOBrDOgZDZD"

## think about a blueprint of your crawler
# 設定時間點，並做unix time 轉換
str2Timestamp <- function(dts) {}

# 抓取所有文章ID
getPostIdFromFeed <- function(dts, token) {}

# 單一文章，抓取所有reactions (請參考抓取所有分頁案例)
# getAllReact  <- function(pid, token) {}



##設定時間點 (yyyy-mm-dd)
# unix time conversion
str2Timestamp <- function(dts)
  as.integer(as.POSIXct(dts, origin="1970-01-01"))

# try it
str2Timestamp("2015-01-01")



## 抓取所有文章ID
getPostIdFromFeed <- function(dts,token) {
  require(data.table)
  require(magrittr)
  require(httr)
  result <- list()
  api_addr <- "https://graph.facebook.com/v2.6/me/feed"
  qs <- list(since=str2Timestamp(dts), access_token=token)
  r <- GET(api_addr, query=qs)
  res <- content(r)
  if ( !length(res$data) ) {
    result
  } else {
    result <- c(result, res$data)
    while ( "next" %in% names(res$paging) ) {
      next_query <- res$paging$`next`
      r <- GET(next_query)
      res <- content(r)
      result <- c(result, res$data)
    }
    result %<>% 
      lapply(function(x) c(time=x$created_time, pid=x$id)) %>% 
      do.call(rbind, .) %>%
      as.data.table %>%
      .[, time:=as.POSIXct(time, format="%Y-%m-%dT%H:%M:%S%z")]
    result
  }
}

# try it
getPostIdFromFeed("2015-01-01", token=token) %>% head



## 抓取所有reactions
getAllReact <- function(token, node) {
  require(data.table)
  require(magrittr)
  require(httr)
  result <- list()
  api_addr <- sprintf("https://graph.facebook.com/v2.6/%s/reactions", node)
  qs <- list(access_token=token)
  r <- GET(api_addr, query=qs)
  res <- content(r)
  
  if ( !length(res$data) ) {
    result
  } else {
    result <- c(result, res$data)
    while ( "next" %in% names(res$paging) ) {
      next_query <- res$paging$`next`
      r <- GET(next_query)
      res <- content(r)
      result <- c(result, res$data)
    }
    result %>% rbindlist %>% cbind(node=node)
  }
}

# try it
getAllReact(token, node = getPostIdFromFeed("2015-01-01", token)$pid[1] ) %>% head



## get all reactions
all_posts <- getPostIdFromFeed("2016-01-01", token=token) %>%
  .[, list(time=max(time)), by="pid"]

all_react <- lapply(all_posts$pid, getAllReact, token=token) %>%
  do.call(rbind, .) %>%
  merge(all_posts, by.x="node",by.y="pid")

head(all_react)



## 平行運算，提高運算效能
library(parallel)
cl <- makeCluster(detectCores())
system.time(
  all_react2 <- parLapply(cl, all_posts$pid, getAllReact, token=token)%>%
    do.call(rbind, .) %>%
    merge(all_posts, by.x="node",by.y="pid")
)



## do something
library(ggplot2)

setorder(all_react, time)
all_react <- all_react[, timed:=as.Date(time)]
all_react <- all_react[, timed:=as.Date(time)]
like_trending1 <- all_react[, list(n_like=.N), by="timed"]
like_trending2 <- all_react[, list(n_like=.N), by="name,timed"]
top_likes <- all_react[, list(n_like=.N), by="name"] %>% setorder(-n_like)

## 趨勢圖
like_trending1 %>% 
  ggplot(aes(x=timed, y=n_like)) + geom_line() + geom_point()

## Top 5 
like_trending2[name %in% top_likes$name[1:5]] %>%
  ggplot(aes(x=timed, y=n_like, color=name)) + geom_line() + geom_point() +
  theme(text=element_text(family='Heiti TC Light')) # required to show chinese on OSX