import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('Heart_Attack.csv')

name_col = 'Age'
colum = df[name_col]

med_col = int(np.median(colum))   # медиана с использованием numpy
print('Numpy Median: ', med_col)

columns = df.columns[:].tolist()
i = 0

for col in columns:

    plt.hist(df[df[name_col] <= med_col][col], bins=20, alpha=0.7, label='Меньше медианы')
    plt.hist(df[df[name_col] >= med_col][col], bins=20, alpha=0.7, label='Больше медианы')

    plt.title(f'График распределения {col}')
    plt.xlabel(f'{col} value')
    plt.ylabel('Number of objects')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'{i}_hist_mediana_' + str(col) + '.png')
    plt.show()
    i += 1
