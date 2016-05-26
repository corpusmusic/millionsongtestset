from sklearn.linear_model import *
import csv
import numpy as np
import pandas as pd
from sklearn.cross_validation import train_test_split
from sklearn import metrics
from pprint import pprint

# Categorical: mode, key, topic, genre

def print_confusion_info(confusion, genres):
    gacc_map = {}
    dim = 15
    for ii in xrange(dim):
        predict_count = confusion[ii].sum()
        correct_predict = confusion[ii,ii]
        fraction_str = str(correct_predict)+"/"+str(predict_count)
        gacc_map[genres[ii]] = float(correct_predict)/float(predict_count)
        print (str(ii) + " - " + genres[ii] + ": " + str(round(gacc_map[genres[ii]],3)) + "\t" + fraction_str)

    print("\t" + "\t".join(str(x) for x in xrange(15)))
    print("".join("-") * 90)
    for ii in xrange(dim):
        print("%i:\t" % ii + "\t".join(str(confusion[ii,x]) for x in xrange(15)))


def get_genres(seq): 
    # order preserving
    checked = []
    for e in seq:
        if e not in checked:
            checked.append(e)
    return checked

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

    print "Model score: " + str((model.score(X,y)))

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
    model2 = LogisticRegression()
    model2.fit(X_train, y_train)

    predicted = model2.predict(X_test)

    probs = model2.predict_proba(X_test)

    # generate evaluation metrics
    print "Accuracy score: " + str(metrics.accuracy_score(y_test, predicted))

    genres = sorted(get_genres(y_test))
    confusion = metrics.confusion_matrix(y_test,predicted)

    print_confusion_info(confusion,genres)

    # Non-categorical
    print "\nNon-categorical values"
    X = df_nc.ix[:,1:].values
    y = df_nc['genre'].values

    model = LogisticRegression()
    model = model.fit(X,y)

    print "Model score: " + str((model.score(X,y)))

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
    model2 = LogisticRegression()
    model2.fit(X_train, y_train)



    predicted = model2.predict(X_test)

    probs = model2.predict_proba(X_test)

    # generate evaluation metrics
    print "Accuracy score: " + str(metrics.accuracy_score(y_test, predicted))

    genres = sorted(get_genres(y_test))
    confusion = metrics.confusion_matrix(y_test,predicted)

    print_confusion_info(confusion,genres)

    coef_mat = model2.coef_
    intercept = model2.intercept_

    pprint(intercept)

    vals = df_nc.columns.values
    for ii in range(14):
        print genres[ii]
        for jj in range(10):
            print "\t" + str(vals[jj+1]) + ": " + str(coef_mat[ii][jj])

main()
