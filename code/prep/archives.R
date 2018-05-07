# Packages to load
library(rvest)
library(tidyverse)

# Archives links
'http://seandietrich.com/archives/' -> archivesLink

# A tibble of archive links
archivesLink %>% 
  read_html() %>% 
  html_nodes(xpath = '//*/div[2]/div[2]/ul[2]/li/a') %>% 
  html_attr('href') %>% 
  as.tibble() %>% 
  rename(archives = value) -> archives

# Set an empty data frame
final = NULL

# Loop through archives and get all blog post links
for (a in 1:length(archives$archives)) {
  # Print where you are in the loop
  print(paste0(a, ": ", final$stories[a]))

    # Get all links for blog posts
  archives$archives[a] %>% 
    read_html() %>% 
    html_nodes(xpath = '//*/div/div[1]/div[1]/div[1]/time') %>% 
    html_text() %>% 
    as.tibble() %>% 
    rename(date = value) %>% 
    mutate(date = as.Date(date, format="%B %d, %Y")) -> postDate
  
  archives$archives[a] %>% 
    read_html() %>% 
    html_nodes(xpath = '//*/div[1]/header/div[1]/div/h1/a') %>%
    html_attr('href') %>% 
    as.tibble() %>% 
    rename(stories = value) -> postLink
  
  # Bind and save to data frame
  cbind(postLink, postDate) -> stories 
  rbind(stories, final) -> final
  Sys.sleep(2)
}

# Save Archive Links
archivesLink %>% 
  saveRDS('rds/archivesLink.RDS')

# Save Final List of stories
final %>%
  saveRDS('rds/final.RDS')

rm(archivesLink)
rm(postDate)
rm(postLink)
rm(archives)