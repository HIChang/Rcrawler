##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## 抓取所有分頁結果
## 以一篇文章按讚者清單為例
library(data.table)
library(magrittr)

getAllReact <- function(token, node) {
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
    result
  }
}

token <- "EAACEdEose0cBAO56mnYChqzW5uZBDsJdaV9rZBPOz3ZBlpO9DWpT5OQYLw0LaL8MQLkjftKev6Dyu88NqIiBG3eEnp7mmrxnQlZC2Kv7Jw9uXZA0x9tG3EgOpGZAXMbHLcOXtolOC2wnH7pZCqVmP23mZCR1nqUUNNWZA2Y3c4kkiDQZDZD"
node <- "1009500255736134_1177069092312582"

reactions <- getAllReact(token, node) %>%
  do.call(rbind, .) %>%
  as.data.table

reactions
