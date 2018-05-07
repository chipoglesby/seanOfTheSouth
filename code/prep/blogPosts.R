library(rvest)
library(tidyverse)

blogPosts = NULL
blogPostsFinal = NULL

for (b in 1:length(final$stories)) {
  print(paste0(b, ": ", final$stories[b]))
  # body
  final$stories[b] %>% 
    read_html() %>% 
    html_nodes(xpath = '//*/div/div/div/div/div/p') %>% 
    html_text() %>% 
    as.tibble() %>% 
    rename(body = value) -> blogBody
  
  # date
  final$stories[b] %>%    
    read_html() %>% 
    html_nodes(xpath = '//*/div/div[1]/div[1]/div[1]/time') %>% 
    html_text() %>% 
    as.tibble() %>% 
    rename(date = value) %>% 
    mutate(date = as.Date(date, format="%B %d, %Y")) -> blogDate
  
  # headline
  final$stories[b] %>% 
    read_html() %>% 
    html_nodes(xpath = '//*/div[1]/header/div/div/h1') %>% 
    html_text() %>% 
    as.tibble() %>% 
    filter(value != '') %>%
    rename(headline = value) -> blogHeadline
  
  final$stories[b] %>% 
    as.tibble() %>% 
    rename(url = value) -> url
  
  # Add to data frame
  cbind(blogBody, blogDate, blogHeadline, url) -> blogPosts
  rbind(blogPosts, blogPostsFinal) -> blogPostsFinal
  # Sleep for two seconds
  Sys.sleep(2)
}

blogPostsFinal %>% 
  saveRDS('rds/blogPostsFinal.RDS')

rm(blogDate)
rm(blogHeadline)
rm(blogDate)
rm(blogBody)
rm(blogPosts)