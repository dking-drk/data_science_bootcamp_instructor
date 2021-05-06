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

My_first_element<-'This is my first vector'

#############################
#
# 3. Vectors in R ----
#
############################

seq(10,1000,10)

New_list <- c('item_1', 'item_2', 'item_3')

#############################
#
# 4. Data Frames in R ----
#
############################

my_data_frame <- data.frame(
  id = c (1:5), 
  student_name = c("Cheyanne","Thomas","Manoj","Tara","Gabriel"), 
  birth_date = as.Date(c("1990-01-01", "1984-09-23", "1972-11-15", "1999-05-11",
                         "1982-03-27")),
  grades=c('A', 'B+', 'A-', 'A', 'A-')
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
          './intro_to_r/search_ad_data.csv', 
            row.names=F)
          

#############################
#
# 7. Accessing items in data 
#
############################

just_names <- c("Cheyanne","Thomas","Manoj","Tara","Gabriel")

just_names[3]

just_one_column<-my_data_frame['student_name']

also_one_column<-my_data_frame$student_name

my_data_frame$here_is_a_new_column<-my_data_frame$student_name

cheyanne<-as.character(my_data_frame[1,2])

filtering<-my_data_frame[my_data_frame$id<=3,]



