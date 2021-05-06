library(readr)# First install this package and then load in


# To get the correct URL, you need to chose the 'Raw' option

github_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv"

recent_grad_data<-read_csv(url(github_raw_url))

