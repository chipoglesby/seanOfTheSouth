blogPostsFinal %>% 
  mutate(weekday = strftime(date,'%A')) %>%
  group_by(weekday, date) %>% 
  count(count = n_distinct(headline)) %>% 
  ggplot(aes(weekday, count)) +
  geom_bar(stat = 'identity')

blogPostsFinal %>%
  mutate(body = gsub('[^a-zA-Z ]', '', body)) %>% 
  unnest_tokens(word, 
                body, 
                to_lower = TRUE, 
                drop = FALSE) %>% 
  anti_join(stop_words) %>% 
  count(word, sort = TRUE)