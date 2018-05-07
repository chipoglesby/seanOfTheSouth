sentiments %>% 
  filter(lexicon == 'bing') -> bing

sentiments %>% 
  filter(lexicon == 'nrc') -> emotions

# Quick bar plot to check dates
blogPostsFinal %>% 
  mutate(weekday = strftime(date,'%A')) %>%
  group_by(weekday, date) %>% 
  count(count = n_distinct(headline)) %>% 
  ggplot(aes(weekday, count)) +
  geom_bar(stat = 'identity')

# Top words in the corpus
blogPostsFinal %>%
  mutate(body = gsub('[^a-zA-Z ]', '', body)) %>% 
  unnest_tokens(word, 
                body, 
                to_lower = TRUE, 
                drop = FALSE) %>% 
  anti_join(stop_words) %>% 
  count(word, sort = TRUE)

# Quick graph of positive and negative words
blogPostsFinal %>%
  unnest_tokens(word, 
                body, 
                drop = FALSE,
                to_lower = TRUE) %>% 
  inner_join(bing) %>% 
  anti_join(stop_words) %>% 
  group_by(sentiment) %>% 
  count(word) %>% 
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free") +
  labs(y = "Count",
       x = 'Word') +
  coord_flip() +
  ggtitle('Sentiments from Sean of the South')

# Emotional Words from Sean of the South
blogPostsFinal %>%
  unnest_tokens(word, 
                body, 
                drop = FALSE,
                to_lower = TRUE) %>% 
  inner_join(emotions) %>% 
  anti_join(stop_words) %>% 
  group_by(sentiment, sentiment) %>% 
  count(word) %>% 
  top_n(10) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free") +
  labs(y = "Count",
       x = 'Word') +
  coord_flip() +
  ggtitle('Sentiments from Sean of the South')

# Overall Sentiment of Sean of the South
blogPostsFinal %>%
  unnest_tokens(word, 
                body, 
                drop = FALSE,
                to_lower = TRUE) %>% 
  inner_join(emotions) %>% 
  anti_join(stop_words) %>% 
  group_by(sentiment) %>% 
  count(sentiment) %>% 
  ungroup() %>% 
  mutate(sentiment = reorder(sentiment, n)) %>%
  ggplot(aes(sentiment, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  labs(y = "Count",
       x = 'Sentiment') +
  coord_flip() +
  ggtitle('Sentiments from Sean of the South')

# Overall Sentiments
blogPostsFinal %>%
  unnest_tokens(word, 
                body, 
                drop = FALSE,
                to_lower = TRUE) %>% 
  inner_join(emotions) %>% 
  anti_join(stop_words) %>%
  filter(sentiment == 'negative') %>% 
  count(word, sort = TRUE) %>% 
  top_n(10, n)