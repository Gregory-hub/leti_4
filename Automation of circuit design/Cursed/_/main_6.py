import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
from scipy.stats import levene

df = pd.read_csv('Heart_Attack.csv')

name_col = 'Age'
#name_col = 'CholesterolLevel'
col = df[name_col]

negative = df[df['Disease'] == 0]
positive = df[df['Disease'] == 1]
neg_col = negative[name_col]
pos_col = positive[name_col]

mean_col_neg = np.mean(neg_col)
mean_col_pos = np.mean(pos_col)

std_col_neg = np.std(neg_col)
std_col_pos = np.std(pos_col)

med_col_neg = np.median(neg_col)
med_col_pos = np.median(pos_col)

dis_col_neg = np.var(neg_col)
dis_col_pos = np.var(pos_col)

print(f'Negative: Mean={mean_col_neg}, Std={std_col_neg}, Median={med_col_neg}, Dispersion={dis_col_neg}')
print(f'Positive: Mean={mean_col_pos}, Std={std_col_pos}, Median={med_col_pos}, Dispersion={dis_col_pos}')

stat, p = stats.shapiro(neg_col)
print(f'Negative: p-value = {p}')

stat, p = stats.shapiro(pos_col)
print(f'Positive: p-value = {p}')

lev = levene(neg_col, pos_col)
print(f'Levene Statistic: {lev.statistic}, p-value: {lev.pvalue}')

if lev.pvalue >= 0.05:
    eq = True
else:
    eq = False

t_stat, p_value = stats.ttest_ind(neg_col, pos_col, equal_var=eq)
print(f"T-statistic: {t_stat}, P-value: {p_value}")

if p_value < 0.05:
    print('The differences are significant')
else:
    print('The differences are not significant')
