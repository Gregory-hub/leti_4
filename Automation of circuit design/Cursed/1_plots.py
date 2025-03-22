import matplotlib.pyplot as plt

from plot_data import *
from read_data import read_data
from constants import *



if __name__ == "__main__":
    df, column_names, col_investigated = read_data()
    column_names_for_barplots = ["brand", "os", "resolution", "announcement_date"]
    column_names_not_for_plot = ["phone_name"]

    plt.hist(col_investigated, bins=20)
    plt.xlabel(col_investigated.name)
    plt.ylabel('n')
    plt.grid(True)
    plt.savefig(IMAGE_PATH + "hist_" + col_investigated.name)
    plt.close("all")

    print(df)
    print("Price median:", df["price(USD)"].median())

    positive = col_investigated >= PRICE_THRESHOLD

    df_for_hists = df.drop(columns=["price(USD)", *column_names_for_barplots, *column_names_not_for_plot])
    build_hists(df_for_hists, positive)

    for i in range(len(column_names_for_barplots)):
        label = column_names_for_barplots[i] + '(' + LABEL_POSITIVE + ')'
        df_col_positive = df[positive][column_names_for_barplots[i]]
        build_bar_plot(df_col_positive.value_counts().head(10), label)

        label = column_names_for_barplots[i] + '(' + LABEL_NEGATIVE + ')'
        df_col_negative = df[positive == False][column_names_for_barplots[i]]
        build_bar_plot(df_col_negative.value_counts().head(10), label)
