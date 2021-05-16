library(tidyverse)
library(lubridate)

# Pull in data ----

my_data_frame <- data.frame(
  id = c(1:6), 
  student_name = c("Cheyanne","Thomas","Manoj","Tara","Gabriel", "Cheyanne"), 
  birth_date = as.Date(c("1990-01-01", "1984-09-23", "1972-11-15", "1999-05-11",
                         "1982-03-27", NA)),
  grades=c('A', 'B+', 'A-', 'A', 'A-', NA)
)


search_ad_data <- read.csv('./intro_to_r/search_ad_data.csv')

#############################
#
# 1. Accessing items in data  ----
#
############################

just_names <- c("Cheyanne","Thomas","Manoj","Tara","Gabriel", "Cheyanne")

just_names[3]

just_one_column<-my_data_frame['student_name']

also_one_column<-my_data_frame$student_name

my_data_frame$here_is_a_new_column<-my_data_frame$student_name

cheyanne<-as.character(my_data_frame[1,2])

filtering<-my_data_frame[my_data_frame$id<=3,]

################################################
#
# 2. Aggregate Funcitons: ---- 
#
############################################### 

table(search_ad_data$platform_id)# Count table with one variable

table(search_ad_data$platform_id, search_ad_data$campaign_id)# Count table with two variables

table(search_ad_data$date, 
      search_ad_data$campaign_id, 
      search_ad_data$platform_id)# Count table with three variables

ave_cost_per_day<-aggregate(cost~date, search_ad_data, FUN=mean)# Aggregate 

################################################
#
# 3. DPLYR example: ---- 
#
############################################### 

births_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data<-read_csv(url(births_url))

summary(births_data)

# Example with search_ad_data

# Group by and summarize

new_dplyr_df <- search_ad_data %>% 
  group_by(date) %>% # group by function
  summarize(cost=sum(cost, na.rm=T), 
            impressions=median(impressions, na.rm=T), 
            clicks=sum(clicks, na.rm=T), 
            visits=max(visits, na.rm=T), 
            conversions=min(conversions, na.rm=T)
            ) %>% # summary function will aggregate rows by grouping variable
  mutate(cost_per_click=cost/clicks, 
         date=as.Date(date),
         year=as.character(year(date))) %>% # Mutate without a groupping variable
  group_by(year) %>% 
  mutate(annual_cost=sum(cost, na.rm=T),
         percent_of_cost=cost/annual_cost) %>%# Mutate with a grouping variable
  filter(year == 2021) %>% # Filter 
  arrange(desc(date)) %>% 
  ungroup() %>% 
  #select(date, cost, total_clicks=clicks, cost_per_click, percent_of_cost)
  mutate(month=month(date, label=T)) %>%
  group_by(year, month) %>%
  summarize(cost=sum(cost, na.rm=T)) %>% 
  spread(year, cost) %>% 
  gather('year', 'births', 2:6) %>% 
  distinct(year, .keep_all=T)

    
################################################
#
# 4. Group By: ---- 
#
############################################### 

yearly_births <- births_data %>% 
  group_by(year)

################################################
#
# 5. Summarize: ---- 
#
############################################### 

yearly_births <- births_data %>% 
  group_by(year) %>% 
  summarize(ave_births=mean(births, na.rm=T))

################################################
#
# 6. Mutate: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  mutate(date=as.Date(paste0(year,
                     '-',
                     month,
                     '-',
                     date_of_month)
                     )
         )

################################################
#
# 7. Filter: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month))) %>% 
  filter(year > 2002)

################################################
#
# 7. Arrange: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month))) %>% 
  filter(year > 2000) %>% 
  arrange(desc(date))

################################################
#
# 7. Select: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month))) %>% 
  filter(year > 2000) %>% 
  arrange(desc(date)) %>% 
  select(year, month, total_births=births)

################################################
#
# 8. Spread: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  group_by(year, month) %>%
  summarize(total_births=sum(births, na.rm=T)) %>% 
  spread(year, total_births)

################################################
#
# 9. Gather: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  gather('date_type', 'date_value', 2:4)

################################################
#
# 10. Joins: ---- 
#
############################################### 

git_grad='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

major_grad='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/majors-list.csv'

recent_grad_data<-read_csv(url(git_grad))

major_data<-read_csv(url(major_grad))

join_example <- recent_grad_data %>% 
  mutate(major_code=as.character(Major_code)) %>%
  inner_join(major_data, by=c('major_code'='FOD1P'))

################################################
#
# 11. Distinct: ---- 
#
############################################### 

dates_birth <- births_data %>% 
  gather('date_type', 'date_value', 2:4) %>% 
  distinct(year, .keep_all=T)

################################################
#
# 11. Loops: ---- 
#
############################################### 

for (i in 0:222) {
  
  print(paste0(i, " - 1", " = ", i-1))
  
  if (i == 222) {
    print('Hello World!')
  }
  
  Sys.sleep(.25)
  
}

# Create a list of 5 items, and then lopping through each item and printing the name. 
# HINT: You can use the print function to print elements in a vetor/list. 

################################################
#
# 11. Loops with Apply: ---- 
#
############################################### 

lapply(just_names, print)

number<-c(1:20)

multiplication <- function(number) {
  number * 2
}

lapply(number, FUN=multiplication)

# Change the function to multiple by five and run the multiplication finction on the number list using lapply.

################################################
#
# 11. GGplot: ---- 
#
############################################### 

ggplot(yearly_births, aes(x=year, y=ave_births)) + 
  geom_line(color='red') 
#+ geom_bar(stat='identity')  

################################################
#
# 12. Geom_line arguments: ---- 
#
############################################### 

ggplot(yearly_births, aes(x=year, y=ave_births)) + 
  geom_line(color='red', 
            size=1.5, 
            linetype='dashed') 
   






