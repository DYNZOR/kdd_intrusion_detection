import pandas as pd
import numpy as np


data = pd.read_csv(".\Data_Sets\Dataset_w_extras.csv")
print('KDD Dataset imported...\n')
print('Dataframe header\n')
print(data.head())
print("Dataframe shape: ", data.shape)

print(data.groupby('attack_name').count())


data = data.drop_duplicates()
print("Dataframe shape after duplicate removal: ", data.shape)

## Obtain sample numbers
print(data.groupby('attack_name').count())

data.to_csv('Data_No_Duplicates.csv', sep=',')
