##################################
####   Regular Expressions    ####
####        Exercises         ####
##################################

## 抓取PTT版特殊pattern

# CASE 1 八卦版“有沒有XXX的八卦”

# make a comprehensive function for multi-page crawling
crawlPttTitles <- function(npage, pat, target="Gossiping") {
  require(data.table)
  require(parallel)
  require(stringr)
  require(rvest)
  require(httr)
  
  # make it fast by parallelling
  cl <- makeCluster(detectCores())
  on.exit(stopCluster(cl))
  
  # crawl front page
  response <- GET(sprintf("https://www.ptt.cc/bbs/%s/index.html", target), 
                  set_cookies(over18=1))
  if ( (rcode <- response$status_code) != 200 )
    stop(sprintf("Got status code %s.", rcode))
  
  # get page index
  lastpage_idx <- response$content %>% read_html %>% 
    html_nodes("div .btn.wide") %>%
    iconv(from="utf8", to="utf8") %>% # for Windows
    grep("上頁", ., value=TRUE) %>% {
      as.integer(str_match(., "index([0-9]+)\\.html")[,2])
    }
  all_pages <- sprintf("https://www.ptt.cc/bbs/%s/index%s.html",
                       target, (lastpage_idx+1):(lastpage_idx-npage+2))
  
  # grep titles with given regex
  oneshot <- function(page_url, pat) {
    require(data.table)
    require(rvest)
    require(httr)
    ptt <- GET(page_url, set_cookies(over18=1))$content %>% read_html
    # deleted posts dont have <a href></a>
    not_deleted <- html_nodes(ptt, "div .title") %>% 
      as.character %>% 
      grepl("<a href", .)
    titles <- html_nodes(ptt, "div .title") %>%
      html_text %>%
      iconv(from="utf8", to="utf8") %>% # for Windows
      gsub("\n\t*", '', .) %>%
      .[not_deleted]
    links <- html_nodes(ptt, "div .title a") %>%
      html_attr("href") %>% 
      iconv(from="utf8", to="utf8") # for Windows
    nrec <- html_nodes(ptt, "div .nrec") %>%
      html_text %>%
      iconv(from="utf8", to="utf8") %>% # for Windows
      .[not_deleted]
    res <- data.table(nrec=nrec, title=titles, link=links) %>%
      .[grepl(pat, title)]
    res
  }
  res <- parLapplyLB(cl, all_pages, oneshot, pat=pat)
  res[sapply(res, function(x) length(x) > 0)] %>% rbindlist
}

# check result
system.time(
  wanted <- crawlPttTitles(200, "^\\[問卦\\] 有沒有.*的八卦[？?]")
)

head(wanted)


## tidy result
wanted <- wanted[grep("爆", nrec), cnt := 150L] %>%
  .[grep("^X", nrec), cnt := 0L] %>%
  .[nrec == '', cnt := 0L] %>%
  .[is.na(cnt), cnt:=as.integer(nrec)]


## 做做文字雲
# install.packages("RColorBrewer")
# install.packages("wordcloud")
library(RColorBrewer)
library(wordcloud)
buzz <- str_match(wanted$title, "有沒有(.*)的八卦？")[,2] %>% 
{
  par(family='Heiti TC Light')
  wordcloud(., wanted$cnt, min.freq=3, scale=c(4,.5), 
            rot.per=0, fixed.asp=FALSE,
            colors=brewer.pal(8, name="Set2"), random.color=TRUE)
}




# CASE 2 電影版 Moive Tagging

ptt_movie <- crawlPttTitles(100, "^\\[.*雷\\]", "movie")

rei <- str_match(ptt_movie$title, "^\\[(.*)雷\\]《(.*)》") %>%
  .[!is.na(.[,1]),-1] %>%
  as.data.table %>% {
    setnames(., c("rei", "title"))
    setorder(., title)
    .[, list(.N), by="title,rei"]
  }
head(rei, 20) %>% write.table(row.names=FALSE, col.names=FALSE, quote=FALSE)
