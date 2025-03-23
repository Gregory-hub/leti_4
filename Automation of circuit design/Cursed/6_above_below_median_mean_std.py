from read_data import read_data
from constants import *
from plot_data import *


if __name__ == "__main__":
    df, column_names, _ = read_data(False)

    col_name = "ram(GB)"
    col = df[col_name]
    median = col.median()

    label_c0 = col_name + " >= median"
    label_c1 = col_name + " < median"

    above = col >= median

    table_data = []
    for name in column_names:
        if df[name].dtype not in ['object']:
            mean = df[name].mean()
            mean_above = df[above][name].mean()
            mean_below = df[above == False][name].mean()
            std = df[name].std()
            std_above = df[above][name].std()
            std_below = df[above == False][name].std()
            table_data.append([name, mean, mean_above, mean_below, std, std_above, std_below])

    label_c0 = '(' + label_c0 + ')'
    label_c1 = '(' + label_c1 + ')'
    header = ['column name', 'mean', 'mean' + label_c0, 'mean' + label_c1, 'std', 'std' + label_c0, 'std' + label_c1]
    df_table = pd.DataFrame(table_data, columns=header)
    print(df_table)
