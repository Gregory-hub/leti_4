from matplotlib.lines import Line2D

from read_data import read_data
from constants import *
from plot_data import *


if __name__ == "__main__":
    df, column_names, _ = read_data(False)

    col_name = "ram(GB)"
    col = df[col_name]
    median = col.median()

    column_names_for_scatter = [df.columns[df.dtypes != 'bool']]

    legend_elements = \
        [Line2D([0], [0], marker='o', color='w', markerfacecolor='tomato', markersize=6, label=f'{col_name} >= {median}'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor='royalblue', markersize=6, label=f'{col_name} < {median}')]

    colors = df[col_name].apply(lambda x: 'red' if x >= median else 'blue')

    for name in column_names_for_scatter:
        pd.plotting.scatter_matrix(df[name], color=colors, figsize=(8, 8))
        plt.figlegend(handles=legend_elements, loc='upper right', fontsize=10)
        plt.savefig(IMAGE_PATH + 'scatter_matrix.png')
        plt.show()
