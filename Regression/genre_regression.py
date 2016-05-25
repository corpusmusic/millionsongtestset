
# Categorical: mode, key, topic, genre

def read_data(filename):
    with open(filename, 'rB') as csvf:
        return [row for row in csv.reader(csvf)]

def main():
    X = read_data("MSD_regression_data.csv")
    Y = []
    for song in X:
        Y.append(song[8])
        song.pop(8)


