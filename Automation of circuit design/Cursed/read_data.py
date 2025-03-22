import pandas as pd


def read_data(bool_to_int: bool = True):
    df = pd.read_csv("cleaned_all_phones.csv")
    column_names = df.columns
    if bool_to_int:
        for i in range(len(column_names)):
            if df[column_names[i]].dtype == bool:
                df[column_names[i]] = df[column_names[i]].astype(int)

    col_investigated = df["price(USD)"]

    return df, column_names, col_investigated
