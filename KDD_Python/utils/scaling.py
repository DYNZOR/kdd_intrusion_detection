from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.base import BaseEstimator, TransformerMixin
import pandas as pd

class CustomScaler(BaseEstimator,TransformerMixin): 
    ##def __init__(self,columns, scaling, copy=True,with_mean=True,with_std=True):
    def __init__(self,columns):
        ##self.scaler = StandardScaler(copy,with_mean,with_std)
        self.scaler = MinMaxScaler(feature_range=(0,1))
        self.columns = columns

    def fit(self, X, y=None):
        self.scaler.fit(X[self.columns], y)
        return self

    def transform(self, X, y=None, copy=None):
        init_col_order = X.columns
        X_scaled = pd.DataFrame(self.scaler.transform(X[self.columns]), columns=self.columns, index=X.index)
        X_not_scaled = X.ix[:,~X.columns.isin(self.columns)]
        return pd.concat([X_not_scaled, X_scaled], axis=1)[init_col_order]

    
