from sklearn.linear_model import *
import csv
import numpy as np
import pandas as pd
from sklearn.cross_validation import train_test_split
from sklearn import metrics

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

    X = df_decat.ix[:,1:].values
    y = df_decat['genre'].values

    model = LogisticRegression()
    model = model.fit(X,y)

    print (model.score(X,y))

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
    model2 = LogisticRegression()
    model2.fit(X_train, y_train)

    predicted = model2.predict(X_test)
    print (predicted)

    probs = model2.predict_proba(X_test)
    print (probs)

    # generate evaluation metrics
    print metrics.accuracy_score(y_test, predicted)

main()
