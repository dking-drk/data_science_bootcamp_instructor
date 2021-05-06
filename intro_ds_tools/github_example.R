library(tidyverse)

filter<-my_data_frame %>% 
  filter(student_name=='Cheyanne')

for (i in 0:222) {
  
  print(paste0(i, " - 1", " = ", i-1))
  
  if (i == 222) {
    print('Hello World!')
  }
  
  Sys.sleep(.25)
  
}

my_data_frame <- data.frame(
  id = c (1:5), 
  student_name = c("Cheyanne","Thomas","Manoj","Tara","Gabriel"), 
  birth_date = as.Date(c("1990-01-01", "1984-09-23", "1972-11-15", "1999-05-11",
                         "1982-03-27")),
  grades=c('A', 'B+', 'A-', 'A', 'A-')
)

search_ad_data <- read.csv('C:/Users/daniel.king/Documents/personal/rework_academy/search_ad_data.csv')




