import pandas as pd
import statistics
import matplotlib.pyplot as plt
from plotnine import *
import numpy as np
from scipy import stats as st

############################
#
# One sample T-Test (warm up) ----   
#
############################

# read in median income data 

metro_pop_data = pd.read_csv('../data_science_bootcamp_instructor/machine_learning/intro/correlation/sample_metro_population.csv')

true_mean_population=9434

# Are these means equal?

mean_population = statistics.mean(metro_pop_data['population'])

tscore, pvalue = st.ttest_1samp(metro_pop_data['population'], 
                             popmean=true_mean_population)

print("t Statistic: ", tscore)  
print("P Value: ", pvalue)

############################
#
# Correlation ----   
#
############################

# Pull in births data from Fivethirtyeight's Github

grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)

grads_data=grads_data[grads_data.ShareWomen.notnull()]

# 1. Lets see what the relationship between these two variables looks like. 

plt.scatter(grads_data['ShareWomen'], grads_data['Median'])
plt.xlabel('Share of Women in Major')
plt.ylabel('Median Income')

# 2. Matplotlib is a built in package in python, but I like to use plotnine because it is similar to ggplot

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median'), 
               color='blue') + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median')
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    )
    )

# 3. Calculating covariance 

cov=np.cov(grads_data['ShareWomen'], grads_data['Median'])

print(cov)

# 4. Pearson Correlation Coefficient 

corr, _ = st.pearsonr(grads_data['ShareWomen'], grads_data['Median'])

print('Pearsons correlation: %.3f' % corr)

