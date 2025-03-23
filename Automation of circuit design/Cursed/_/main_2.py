import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('Heart_Attack.csv')

#name_col = 'Age'
name_col = 'CholesterolLevel'
col = df[name_col]
# positive = df[df.iloc[:, 13] == 1]
# negative = df[df.iloc[:, 13] == 0]
negative = df[df['Disease'] == 0]
positive = df[df['Disease'] == 1]
neg_col = negative[name_col]
pos_col = positive[name_col]

med_col = np.median(col)   # медиана с использованием numpy
print('Numpy Median: ', med_col)
med_col_neg = np.median(neg_col)
med_col_pos = np.median(pos_col)
print('Numpy Median Negative: ', med_col_neg)
print('Numpy Median Positive: ', med_col_pos, '\n')

col_sort = sorted(col)
len_col = len(col_sort)
if len_col % 2 == 0:
    el1 = col_sort[len_col // 2 - 1]
    el2 = col_sort[len_col // 2]
    rez = (el1 + el2) / 2
    print('Manual Median: ', rez)
else:
    el = col_sort[len_col // 2]
    print('Manual Median: ', el)

neg_sort = sorted(neg_col)
len_neg = len(neg_sort)
pos_sort = sorted(pos_col)
len_pos = len(pos_sort)
if len_neg % 2 == 0:
    el1 = neg_sort[len_neg // 2 - 1]
    el2 = neg_sort[len_neg // 2]
    rez = (el1 + el2) / 2
    print('Manual Median Negative: ', rez)
elif len_neg % 2 != 0:
    el = neg_sort[len_neg // 2]
    print('Manual Median Negative: ', el)

if len_pos % 2 == 0:
    el1 = pos_sort[len_pos // 2 - 1]
    el2 = pos_sort[len_pos // 2]
    rez = (el1 + el2) / 2
    print('Manual Median Positive: ', rez)
elif len_pos % 2 != 0:
    el = pos_sort[len_pos // 2]
    print('Manual Median Positive: ', el)
