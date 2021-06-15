# pip install statsmodels
# pip install statistics
# pip install scipy
# pip install pandas
# pip install numpy

from scipy.stats import ttest_1samp
from scipy import stats as st
import pandas as pd
import statistics
from statsmodels.stats.proportion import proportions_ztest
import numpy as np

############################
#
# F1 Score ----   
#
############################

precision = 100/(110)

recall = 100/(105)

f1 = 2*((precision*recall)/(precision+recall))


############################
#
# One sample T-Test ----   
#
############################

# read in median income data 

median_income_data = pd.read_csv('../data_science_bootcamp_instructor/machine_learning/intro/t_tests/t_tests/sample_median_hh_income.csv')
 
# remember: the actual median household income in the US is 68000

true_mean_hh_income=68000

# Are these means equal?

mean_hh_income = statistics.mean(median_income_data['median_hh_income'])

tscore, pvalue = ttest_1samp(median_income_data['median_hh_income'], 
                             popmean=68000)

print("t Statistic: ", tscore)  
print("P Value: ", pvalue)
# t Statistic:  t Statistic:  -0.13219765721853508
# P Value:  0.8948545744080184

# This p value is much much larger than .05 and therefore we cannot reject the null hypothesis 

############################
#
# Two sample T-Test ----   
#
############################

births_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data = pd.read_csv(births_url)

winter=births_data[births_data.month.isin([1,2,3])]

summer=births_data[births_data.month.isin([6,7,8])]

st.ttest_ind(a=winter['births'],
             b=summer['births'],
             equal_var=True)

############################
#
# Proportion Test ----   
#
############################

# "campaign","conversions","clicks"
# desk_organization,72241.79036798535,57375642
# dirty_clothes,197403.74723294372,129139077

#this is how the proportion looks in R
#prop.test(x = c(72241.79036798535, 197403.74723294372), 
 #         n = c(57375642, 129139077))

# can we assume anything from our sample
significance = 0.025

# This is how we identify our proportions in python
sample_success_a, sample_size_a = (72241.79036798535, 57375642)
sample_success_b, sample_size_b = (197403.74723294372, 129139077)

# Identify numerator (successes) and denominator (sample)
successes = np.array([sample_success_a, sample_success_b])

samples = np.array([sample_size_a, sample_size_b])

# Run test
stat, p_value = proportions_ztest(count=successes, nobs=samples,  alternative='two-sided')

stat

p_value




