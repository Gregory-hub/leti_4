from read_data import read_data
from constants import *
from plot_data import *


if __name__ == "__main__":
    df, column_names, _ = read_data()
    col_name = "ram(GB)"
    col = df[col_name]
    median = col.median()

    column_names_for_barplots = ["brand", "os", "resolution", "announcement_date"]
    column_names_not_for_plot = ["phone_name"]

    label_c0 = col_name + " >= median"
    label_c1 = col_name + " < median"

    above = col >= median

    df_for_hists = df.drop(columns=["price(USD)", *column_names_for_barplots, *column_names_not_for_plot])
    build_hists(df_for_hists, above, label_c0, label_c1)

    for i in range(len(column_names_for_barplots)):
        label = column_names_for_barplots[i] + " (" + label_c0 + ")"
        df_col_above = df[above][column_names_for_barplots[i]]
        build_bar_plot(df_col_above.value_counts().head(10), label)

        label = column_names_for_barplots[i] + " (" + label_c1 + ")"
        df_col_below = df[above == False][column_names_for_barplots[i]]
        build_bar_plot(df_col_below.value_counts().head(10), label)
    
    plt.hist(df["price(USD)"][above], bins=20, alpha=0.7, label=label_c0)
    plt.hist(df["price(USD)"][above == False], bins=20, alpha=0.7, label=label_c1)
    plt.xlabel("price(USD)")
    plt.ylabel("n")
    plt.legend(prop={"size": 6})
    plt.grid(True)
    plt.tight_layout()
    path = IMAGE_PATH + "hist_price(USD)_" + label_c0 + "_" + label_c1
    path = path.replace(">=", "bigger").replace("<", "smaller")
    plt.savefig(path)
    plt.close()
