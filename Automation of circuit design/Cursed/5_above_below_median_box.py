from matplotlib.lines import Line2D

from read_data import read_data
from constants import *
from plot_data import *


if __name__ == "__main__":
    df, column_names, _ = read_data(False)
    col_name = "ram(GB)"
    col = df[col_name]
    median = col.median()

    label_above = col_name + " >= median"
    label_below = col_name + " < median"

    labels = [label_above, label_below]

    above = col >= median

    colors = ['tomato', 'royalblue']
    legend_elements = \
        [Line2D([0], [0], marker='o', color='w', markerfacecolor='tomato', markersize=6, label=f'{col_name} >= {median}'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor='royalblue', markersize=6, label=f'{col_name} < {median}')]

    for name in df.columns:
        if df[name].dtype not in ['object', 'bool']:
            data = [df[above][name], df[above == False][name]]

            fig, ax = plt.subplots(figsize=(8, 8))
            ax.set_ylabel(name)
            bp = ax.boxplot(data, patch_artist=True, tick_labels=labels)

            for patch, color in zip(bp['boxes'], colors):
                patch.set_facecolor(color)

            for median in bp['medians']:
                median.set_color('black')

            plt.title(name)
            plt.grid()
            plt.savefig(IMAGE_PATH + f'boxplot_{name}.png')
            # plt.show()
