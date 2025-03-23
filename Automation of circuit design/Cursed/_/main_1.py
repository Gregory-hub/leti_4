import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('_/Heart_Attack.csv')

columns = df.columns[:].tolist()
last_col = df.columns[-1]

for col in columns:

    plt.hist(df[df[last_col] == 0][col], bins=20, alpha=0.7, label='Negative')
    plt.hist(df[df[last_col] == 1][col], bins=20, alpha=0.7, label='Positive')

    plt.title(f'График распределения {col}')
    plt.xlabel(f'{col} value')
    plt.ylabel('Number of objects')
    plt.legend()
    plt.grid(True)
    # plt.savefig('hist_' + str(col) + '.png')
    plt.show()
