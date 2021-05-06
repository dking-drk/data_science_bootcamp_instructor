library(readr)# First install this package and then load in

# To get the correct URL, you need to chose the 'Raw' option ----

github_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv"

recent_grad_data<-read_csv(url(github_raw_url))

################################################
#
# 1. First, let's look at the data frame: ---- 
#
###############################################

# To view the data you can run the following line of code 

View(recent_grad_data)

# Additionally, you can just click on the data frame in the environment box

# You can also click on the down blue arrow which is helpful if your data is large 

################################################
#
# 2. Speaking of which, what if my data frame is too large: ---- 
#
############################################### 

# You will run into issues opening the data frame 

# You can get a look at the top of the data by running the function head()

head(recent_grad_data)# This will give you 10

head(recent_grad_data, 20)# This will give you 20

# You can also take a look at the column name which comes in handy 

colnames(recent_grad_data)

################################################
#
# 3. Finally, just to get you started, you can get a summary of your data frame: ---- 
#
############################################### 

summary(recent_grad_data)

################################################
#
# 4. It might be easier to see this if we make is a data frame: ---- 
#
############################################### 

summary_grad_data <- as.data.frame.matrix(summary(recent_grad_data))















