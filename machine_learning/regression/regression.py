import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data

############################
#
# Correlation (warm up) ----   
#
############################

# Example of Correlation Coefficiant on births date by year 

births_url = "https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data = pd.read_csv(births_url)

(
    ggplot(births_data) +
    geom_point(aes(x = 'year', 
                   y='births'), 
               color='blue', 
               alpha=.01) + 
    geom_smooth(aes(x = 'year',
                    y = 'births')
    ) +
    labs(
        title ='Total Births by Year',
        x = 'Year',
        y = 'Births',
    )
    )

corr, _ = st.pearsonr(births_data['year'], births_data['births'])

print('Pearsons correlation: %.3f' % corr)

############################
#
# Univariate Regression ----   
#
############################

# Pull in grad data from Fivethirtyeight's Github

grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)

grads_data=grads_data[grads_data.ShareWomen.notnull()]

# First lets looks at the linear relationship of maultiple variables

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median'), 
               color='blue') + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median'), 
                method='lm'
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    )
    )

# Run the OLS estimation for univariate regression

grads_data['share_women_percent']=grads_data['ShareWomen']*100

est = smf.ols(formula='Median ~ share_women_percent', data=grads_data).fit() 

est.summary()

############################
#
# Multivariate Regression ----   
#
############################

# Graph for multivariate regression

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median', 
               color='Unemployment_rate')) + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median'), 
                method='lm'
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) 
    )

# Run the OLS estimation for multivariate regression

est_multiple = smf.ols(formula='Median ~ share_women_percent+Unemployment_rate', data=grads_data).fit() 

est_multiple.summary()

# Run Mutlivariate regression on your own

est_births = smf.ols(formula='births ~ year+month', data=births_data).fit() 

est_births.summary()

############################
#
# Multivariate Regression with Factors ----   
#
############################

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median')) + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median'), 
                method='lm'
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) + 
    facet_wrap('~Major_category')
    )

est_multiple = smf.ols(formula='Median ~ share_women_percent+Major_category', data=grads_data).fit() 

est_multiple.summary()




