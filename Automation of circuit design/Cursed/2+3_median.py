from read_data import read_data
from constants import *


if __name__ == "__main__":
    df, column_names, col_investigated = read_data()
    positive = col_investigated >= PRICE_THRESHOLD
    # col_name = "inches"
    col_name = "ram(GB)"
    print(col_name + " median:", df[col_name].median())
    print(col_name + " (class '" + LABEL_POSITIVE + "') median:", df[positive][col_name].median())
    print(col_name + " (class '" + LABEL_NEGATIVE + "') median:", df[positive == False][col_name].median())
