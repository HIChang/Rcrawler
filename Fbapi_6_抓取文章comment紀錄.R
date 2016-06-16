##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## 抓取文章Comments紀錄

library(data.table)
library(magrittr)
library(httr)

# token <- "EAACEdEose0cBACd67SIUWAZB8QwOHPe5AApXQgnGR9XthWOpI2nLs3SYSvDgZBscIZAVyZBOYqGXmEFbrZBxD1iWun8XTIjZAfKUQtYzMbFo7ta6Rr3A03GGqpfsJVELK7vgXshpomEhX4xITpj2rYJ2cNE94WZBMLDvYXk71KtXQZDZD"

getComments <- function(pid, token) {
  result <- list()
  fields <- c("id", "message", "comment_count", "like_count")
  api_addr <- sprintf("https://graph.facebook.com/v2.6/%s/comments?fields=%s", 
                      pid, paste(fields, collapse=','))
  qs <- list(access_token=token)
  r <- GET(api_addr, query=qs)
  res <- content(r)
  result <- 
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
      result %>% rbindlist %>% cbind(pid=pid)
    }
  result
}


pid <- "1009500255736134_1185333538152804"

comments <- getComments(pid, token)
replies <- lapply(comments[comment_count > 0, id], getComments, token=token) %>% rbindlist

res <- rbind(comments, replies)
res
