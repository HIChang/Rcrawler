##################################
####    Facebook Graph API    ####
####        Exercises         ####
##################################

## Facebook 機器人
## 自動PO文、按讚、刪文

library(httr)
token = "EAACEdEose0cBAPub4H52OMmT0ZActfSCVHYd4nWOM01FxJquq6qPLkZB0WWACrqj9b5eDYZCpyVE13aN9PbH8SlohQASL6VW0KrQp9YHh6glBvPwUxyKATOV8PPE3yzLX3lHJ72AHBlGx8wksSZAXc6mdFdFmzZA60m8LOBrDOgZDZD"

## PO文
postArticle <- function(mesg, token) {
  api_addr <- sprintf("https://graph.facebook.com/v2.6/me/feed/")
  r <- POST(api_addr, body=list(access_token=token, message=mesg))
  content(r)
}
(test_pid <- postArticle("test123", token=token))


## 按讚
postLike <- function(pid, token) {
  api_addr <- sprintf("https://graph.facebook.com/v2.6/%s/likes", pid)
  qs <- list(access_token=token)
  r <- POST(api_addr, query=qs)
  r
}

postLike(pid=test_pid, token=token)



# 刪文
deletePost <- function(pid, token) {
  api_addr <- sprintf("https://graph.facebook.com/v2.6/%s", pid)
  qs <- list(access_token=token)
  r <- DELETE(api_addr, query=qs)
  r
}

deletePost(test_pid, token=token)