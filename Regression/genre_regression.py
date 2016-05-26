from sklearn.linear_model import *
import csv
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pylab

# Categorical: mode, key, topic, genre

def decategorize(df):
    for cat in ['mode', 'key', 'topic']:
        new_df = pd.get_dummies(df[cat])
        cols = [cat+"."+str(col) for col in new_df.columns]
        new_df.columns = cols

        df = df.drop(cat, axis=1)
        df = pd.concat([df, new_df], axis=1)

    return df
  

def main():
    df = pd.read_csv("MSD_regression_data.csv")
    df_nc = pd.read_csv("MSD_regression_data_noncat.csv")

    df_decat = decategorize(df)

    print df_decat.columns.values

    X = df_decat.ix[:,1:].values
    y = df_decat['genre'].values


    
    model = LogisticRegression()
    model = model.fit(X,y)

    print model.score(X,y)

main()
