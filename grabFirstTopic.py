from __future__ import division

from collections import defaultdict
from operator import itemgetter
import csv
import sys


def read_data(filename):
    with open(filename, 'r') as csvf:
        return [row for row in csv.reader(csvf)]


def write_csv(data, filename):
    with open(filename, 'w') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for line in data:
            writer.writerow(line)


if __name__ == '__main__':
    try:
        datafile = sys.argv[1]
    except:
        datafile = 'MSDSubset-topic-model-results.csv'

    inputdata = read_data(datafile)
    outputdata = []
    header = ['tid', 'artist_name', 'title', 'genre', 'topic']
    outputdata.append(header)
    for line in inputdata:
        genre = line[3].split('|')[0]
        topic = line[4].split('|')[0]
        songinfo = [line[0], line[1], line[2], genre, topic]
        outputdata.append(songinfo)

    write_csv(outputdata, 'MSDSubset-topics.csv')
