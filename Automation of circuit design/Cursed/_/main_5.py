import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tabulate import tabulate

df = pd.read_csv('Heart_Attack.csv')
table_data = []

name_col = df.columns[:].tolist()
for name in name_col:
    col = df[name]
    negative = df[df['Disease'] == 0]
    positive = df[df['Disease'] == 1]
    neg_col = negative[name]
    pos_col = positive[name]
    len_col = len(col)
    sum_col = sum(col)

    print(f'{name}:')
    mean_col = np.mean(col)   # среднее с использованием numpy
    print('   Numpy Mean: ', mean_col)

    manual_mean = sum_col / len_col
    print('Manual Mean: ', manual_mean)

    mean_col_neg = np.mean(neg_col)
    mean_col_pos = np.mean(pos_col)
    print('Numpy Mean Negative: ', mean_col_neg)
    print('Numpy Mean Positive: ', mean_col_pos)

    manual_neg_mean = sum(neg_col) / len(neg_col)
    print('Manual Mean Negative: ', manual_neg_mean)
    manual_pos_mean = sum(pos_col) / len(pos_col)
    print('Manual Mean Positive: ', manual_pos_mean)

    difference = []
    difference_neg = []
    difference_pos = []

    for i in col:
        difference.append((i - manual_mean) ** 2)
    for i in neg_col:
        difference_neg.append((i - manual_neg_mean) ** 2)
    for i in pos_col:
        difference_pos.append((i - manual_pos_mean) ** 2)

    manual_std_col = np.sqrt(sum(difference) / len_col)
    manual_std_neg = np.sqrt(sum(difference_neg) / len(neg_col))
    manual_std_pos = np.sqrt(sum(difference_pos) / len(pos_col))

    std_col = np.std(col) # стандартное отклонение с использованием numpy
    print('   Numpy STD: ', std_col)

    print('Manual STD: ', manual_std_col)

    std_col_neg = np.std(neg_col)
    std_col_pos = np.std(pos_col)
    print('Numpy STD Negative: ', std_col_neg)
    print('Numpy STD Positive: ', std_col_pos)

    print('Manual STD Negative: ', manual_std_neg)
    print('Manual STD Positive: ', manual_std_pos, '\n')

    table_data.append([name, mean_col, mean_col_neg, mean_col_pos, std_col, std_col_neg, std_col_pos])

df_table = pd.DataFrame(table_data, columns=['Colum', 'Mean', 'Mean Negative', 'Mean Positive', 'STD', 'STD Negative', 'STD Positive'])
print(tabulate(df_table, headers='keys', tablefmt='pretty'))
