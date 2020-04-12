#Notepad

#Keeps only unique responses
Q2dataunique <- Q2data %>% distinct(ResponseNoPunc, .keep_all = TRUE)
summary(Q2dataunique)

#Save out the duplicates to add in later (do this after tokenisation)
Q2dataduplicates <- Q2data %>% find_duplicates(ResponseNoPunc)

Q2dataduplicates <- Q2dataduplicates %>%
  group_by(ResponseNoPunc) %>%
  slice(-1)


