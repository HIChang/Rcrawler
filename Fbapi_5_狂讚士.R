##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## 狂讚士
## 挑選一位朋友，對其所有文章按讚

library(data.table)
library(magrittr)
library(httr)

token = "EAACEdEose0cBAODqIC6HCTZAQ0YZBXk1U6siIPYtbOZA5Kr2qdVuns8aGPF4ypCC42Yp046E4KY9Hn1igN8qsKPUd8AggNSyRB0cTFyZBO30voSt2WeR1ZAl81k7qeEZC7wJmqAX3Xrksyreu6LSJ53ZBiXNuDLoFmFTYz9mNEF1QZDZD"

## 取得朋友ID
getFriends <- function(token) {
  result <- list()
  api_addr <- "https://graph.facebook.com/v2.4/me/friends"
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
    result %>% rbindlist
  }
}

head(getFriends(token=token))

## 設定時間點 (yyyy-mm-dd) （參考我的按讚趨勢案例）
# unix time conversion
str2Timestamp <- function(dts)
  as.integer(as.POSIXct(dts, origin="1970-01-01"))

## 取得朋友post id
getFriendPostId <- function(uid, dts, token) {
  require(data.table)
  require(magrittr)
  require(httr)
  result <- list()
  api_addr <- sprintf("https://graph.facebook.com/v2.4/%s/posts", uid)
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

getFriendPostId("1009500255736134", "2016-01-01", token=token) %>% head


## 確認是否可取得朋友文章id
all_friends <- getFriends(token=token)


# since it may take some time, let's do it parallel
library(parallel)
cl <- makeCluster(detectCores())
clusterExport(cl, "str2Timestamp")
all_friends_posts <- parLapplyLB(cl, all_friends$id, getFriendPostId, dts="2016-01-01", token=token)
stopCluster(cl)

## check list
names(all_friends_posts) <- all_friends$name
post_counts <- sapply(all_friends_posts, 
                      function(x) if (!length(x)) 0 else nrow(x))
paste("取得文章數:", names(post_counts), post_counts, sep=" | ") %>% 
  head %>%
  write.table(quote=FALSE, row.names=FALSE, col.names=FALSE)

## 對文章按讚 (參考facebook機器人案例)
postLike <- function(pid, token) {
  api_addr <- sprintf("https://graph.facebook.com/v2.6/%s/likes", pid)
  qs <- list(access_token=token)
  r <- POST(api_addr, query=qs)
  r
}


# # # loop for all posts given a user
# # me_id <- "1009500255736134"
# # all_my_posts <- getFriendPostId(me_id, "2016-05-01", token=token)
# # lapply(all_my_posts$pid, postLike, token=token)

