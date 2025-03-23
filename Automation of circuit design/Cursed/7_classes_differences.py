import pandas as pd
from scipy import stats
from scipy.stats import mannwhitneyu

from read_data import read_data
from constants import *
from plot_data import *


if __name__ == "__main__":
    df, column_names, col_investigated = read_data()

    # col_name = "ram(GB)"
    col_name = "inches"

    label_c0 = LABEL_POSITIVE
    label_c1 = LABEL_NEGATIVE

    positive = col_investigated >= PRICE_THRESHOLD

    col_c0 = df[positive][col_name]
    col_c1 = df[positive == False][col_name]

    print("PARAMETER '" + col_name + "'")

    stat, p = stats.shapiro(col_c0)
    print("SHAPIRO-WILK TEST")
    print("Class '" + label_c0 + "' p-value: " + "{:.3e}".format(p))
    print("Class '" + label_c0 + "' is " + ("" if p >= 0.05 else "not") + " normally distributed")

    stat, p = stats.shapiro(col_c1)
    print("Class '" + label_c1 + "' p-value: " + "{:.3e}".format(p))
    print("Class '" + label_c1 + "' is " + ("" if p >= 0.05 else "not") + " normally distributed")

    print("-" * 50)
    print("MANN-WHITNEY U TEST")
    u_stat, p_value = mannwhitneyu(col_c0, col_c1)
    print("U-Test statistic: {:.3e}".format(u_stat))
    print("p-value: {:.3e}".format(p_value))

    if p_value < 0.05:
        print('The differences are significant')
    else:
        print('The differences are not significant')
    print("-" * 50)
