from pydataset import data
from plotnine import *
import pandas as pd
import numpy as np

all_data=data()

titanic = data('titanic')

election_data=data('presidentialElections')

air_passengers=data('AirPassengers')

UKDriverDeaths=data('UKDriverDeaths')

cancer=data('esoph')

women_emplyment=data('Mroz')


(
    ggplot(UKDriverDeaths) +
    geom_line(aes(x = 'time', 
                   y='UKDriverDeaths')) + 
    labs(
        title ='Total Births by Year',
        x = 'Year',
        y = 'Births',
    )
    )

UKDriverDeaths

all_data[(all_data.dataset_id == 'USAccDeaths')]







