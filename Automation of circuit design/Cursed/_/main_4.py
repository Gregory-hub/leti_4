import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

df = pd.read_csv('_/Heart_Attack.csv')

name_col = 'Age'
colum = df[name_col]

med_col = int(np.median(colum))   # медиана с использованием numpy
print('Numpy Median: ', med_col)

columns = ['Age', 'RestingBloodPressure', 'CholesterolLevel', 'HighestBeatsPerMinute', 'DepressionST']
columns1 = ['Age', 'Gender', 'ChestPain', 'FastingBloodSugar', 'RestingECG', 'ExerciseInducedAngina']
columns2 = ['Age', 'PeakSTSegmentSlope', 'NumberOfLargeVessels', 'AbsorptionWaist', 'Disease']

legend_elements = \
    [Line2D([0], [0], marker='o', color='w', markerfacecolor='tomato', markersize=6, label=f'{name_col} ≤ {med_col}'),
     Line2D([0], [0], marker='o', color='w', markerfacecolor='royalblue', markersize=6, label=f'{name_col} > {med_col}')]

### SCATTER

colors = df[name_col].apply(lambda x: 'red' if x <= med_col else 'blue')

for i, col_group in enumerate([columns, columns1, columns2]):
    pd.plotting.scatter_matrix(df[col_group], color=colors, figsize=(10, 10))
    plt.figlegend(handles=legend_elements, loc='upper right', fontsize=10)
    plt.savefig(f'{i}_scatter.png')
    plt.show()

### BOXPLOT

under_med = df[df[name_col] <= med_col]
above_med = df[df[name_col] > med_col]
labels = ['Under median', 'Above median']
color_ = ['tomato', 'royalblue']

for col in columns:
    under_col = under_med[col]
    above_col = above_med[col]

    data = [under_col, above_col]

    fig, ax = plt.subplots()
    ax.set_ylabel(col)

    bp = ax.boxplot(data, patch_artist = True, tick_labels = labels)

    for patch, color in zip(bp['boxes'], color_):
        patch.set_facecolor(color)

    plt.title(f"Box plot {col}")
    plt.figlegend(handles=legend_elements, loc='upper right', fontsize=10)

    plt.grid()
    plt.savefig(f'boxplot_{col}.png')
    plt.show()
