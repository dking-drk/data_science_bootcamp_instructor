library(tidyverse)

# By the way, this is a comment

# Notice below that if I use 4 dashes I get a nice little bockmark inbetween my file and the cosole

#############################
#
# 1. Arithmetic in R ----
#
############################

10/2

10*2

10==9

Factorial(5)

#############################
#
# 2. Defining Elements ----
#
############################

my_first_element<-'This is my first vector'

my_first_element

the_number_10 <- 10

big_long_number<-100000^100

the_number_10 = 11

my_first_element<-c('This is my first vector', 'and second')

#############################
#
# 3. Vectors in R ----
#
############################

seq_colon_element<-1:10

long_vector<-seq(10,1000,10)

New_list <- c('item_1', 'item_2', 'item_3')

danny_vector<-seq(1,1000,5)

mean(danny_vector)

median(danny_vector)


danny_vector*long_vector

#############################
#
# 4. Data Frames in R ----
#
############################

my_data_frame <- data.frame(
  id = c(1:6), 
  student_name = c("Cheyanne","Thomas","Manoj","Tara","Gabriel", "Cheyanne"), 
  birth_date = as.Date(c("1990-01-01", "1984-09-23", "1972-11-15", "1999-05-11",
                         "1982-03-27", NA)),
  grades=c('A', 'B+', 'A-', 'A', 'A-', NA)
)


my_new_data_frame <- data.frame(
  id = c(1:7), 
  date = as.Date(c("1990-01-01", "1984-09-23", "1972-11-15", "1999-05-11",
                         "1982-03-27", "2021-05-06", "2020-03-14"))
)

#############################
#
# 5. Reading in Data ----
#
############################

# First of all, you can use you can use absolute paths, lets see those....

# But relative paths are easier to write and are great for Github

getwd()# first you want to make sure you know what your 

# Then just use the "." notation to specify the path before the foder you want to specify 

search_ad_data <- read.csv('./intro_to_r/search_ad_data.csv')

#############################
#
# 6. Writing Data  ----
#
############################

# Writting is largely the same

write.csv(search_ad_data, 
          './intro_to_r/search_ad_data_2.csv', 
            row.names=F)
          

#############################
#
# 7. Accessing items in data  ----
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
# 8. Aggregate Functions: ---- 
#
############################################### 

unique(search_ad_data$platform_id)

table(search_ad_data$platform_id)# Count table with one variable

table(search_ad_data$platform_id, search_ad_data$campaign_id)# Count table with two variables

table(search_ad_data$date, 
      search_ad_data$campaign_id, 
      search_ad_data$platform_id)# Count table with three variables

ave_cost_per_day<-aggregate(cost~date, search_ad_data, FUN=mean)# Aggregate 

med_impressions_per_day<-aggregate(impressions~date, search_ad_data, FUN=median)



################################################
#
# 9. DPLYR example: ---- 
#
############################################### 

github_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv"

recent_grad_data<-read_csv(url(github_raw_url))

new_dplyr_df <- search_ad_data %>% 
  group_by(date) %>% 
  summarize(cost=mean(cost, na.rm=T), 
            impressions=median(impressions, na.rm=T), 
            clicks=sum(clicks, na.rm=T), 
            visits=max(visits, na.rm=T), 
            conversions=min(conversions, na.rm=T)) %>% 
  arrange(date)







