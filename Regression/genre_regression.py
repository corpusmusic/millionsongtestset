from sklearn.linear_model import *
import csv
import numpy as np
import pandas as pd

# Categorical: mode, key, topic, genre

def read_data(filename):
    with open(filename, 'rB') as csvf:
        return [row for row in csv.reader(csvf)]

def build_key_map(header):
    key_map = {}
    for i in range(0, len(header)):
        key_map[header[i]] = i

    return key_map

def main():
    df = pd.read_csv("MSD_regression_data.csv")
    df_nc = pd.read_csv("MSD_regression_data_noncat.csv")

    for cat in ['genre', 'mode', 'key', 'topic']:
        new_df = pd.get_dummies(df[cat])
        cols = [cat+"."+str(col) for col in new_df.columns]
        print cols
        new_df.columns = cols

        df = df.drop(cat, axis=1)
        df = pd.concat([df, new_df], axis=1)

    print df.columns.values

    lr = LogisticRegression()
    lr.fit(df['genre'].values, df.ix[:,1:].values)

    

main()
