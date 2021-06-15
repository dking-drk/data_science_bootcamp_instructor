import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf

# Pull in grad data from Fivethirtyeight's Github

grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)

grads_data=grads_data[grads_data.ShareWomen.notnull()]

# First lets looks at the linear relationship 

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

# Run the OLS estimation 

est = smf.ols(formula='Median ~ ShareWomen', data=grads_data).fit() 

est.summary()



