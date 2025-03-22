import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from constants import *


def add_hist(axs, data: pd.DataFrame, positive, xlabel, ylabel, label_c0=LABEL_POSITIVE, label_c1=LABEL_NEGATIVE):
    axs.hist(data[positive], bins=20, alpha=0.7, label=label_c0)
    axs.hist(data[positive == False], bins=20, alpha=0.7, label=label_c1)
    axs.set_xlabel(xlabel)
    axs.set_ylabel(ylabel)
    axs.legend(prop={"size": 6})
    axs.grid(True)


def build_hists_2x2(data: pd.DataFrame, positive, fig_n: int, label_c0=LABEL_POSITIVE, label_c1=LABEL_NEGATIVE):
    if data.shape[1] != 4:
        raise AssertionError("len(data) != 4")

    column_names = data.columns
    fig, axs = plt.subplots(2, 2)
    for i in range(4):
        x = i // 2
        y = i % 2
        col = data[column_names[i]]
        xlabel = column_names[i]
        if y == 0:
            ylabel = "n"
        else:
            ylabel = ""
        add_hist(axs[x, y], col, positive, xlabel, ylabel, label_c0, label_c1)

    plt.tight_layout()
    path = IMAGE_PATH + "hist_" + str(fig_n) + "_" + label_c0 + "_" + label_c1
    path = path.replace(">=", "bigger").replace("<", "smaller")
    plt.savefig(path)
    plt.close()


def build_hists(data: pd.DataFrame, positive, label_c0=LABEL_POSITIVE, label_c1=LABEL_NEGATIVE):
    n_hists_2x2 = data.shape[1] // 4
    n_hists_remaining = data.shape[1] - n_hists_2x2 * 4
    fig_n = 0

    for i in range(n_hists_2x2):
        h_data = data.iloc[:, 4 * i : 4 * (i + 1)]
        build_hists_2x2(h_data, positive, i, label_c0, label_c1)
        fig_n += 1

    if n_hists_remaining >= 2:
        fig, axs = plt.subplots(1, 2)
        h_data = data.iloc[:, n_hists_2x2 * 4 : n_hists_2x2 * 4 + 2]
        add_hist(axs[0], h_data.iloc[:, 0], positive, h_data.column_names[0], "n", label_c0, label_c1)
        add_hist(axs[1], h_data.iloc[:, 1], positive, h_data.column_names[1], "", label_c0, label_c1)
        plt.tight_layout()

        path = IMAGE_PATH + "hist_" + str(fig_n) + "_" + label_c0 + "_" + label_c1
        path = path.replace(">=", "bigger").replace("<", "smaller")
        plt.savefig(path)
        fig_n += 1
        n_hists_remaining -= 2

    if n_hists_remaining == 1:
        fig, axs = plt.subplots(1, 1)
        h_data = data.iloc[:, -1]
        add_hist(axs, h_data.iloc[0], positive, h_data.name, "n", label_c0, label_c1)

        plt.tight_layout()
        plt.savefig(IMAGE_PATH + "hist_" + str(fig_n))


def build_bar_plot(data: pd.Series, label: str):
    sns.barplot(x=data.index, y=data.values)
    plt.title(label + " top " + str(len(data)))
    plt.xlabel(label)
    plt.ylabel("n")
    plt.xticks(rotation=90)
    plt.grid(True)
    plt.tight_layout()
    path = IMAGE_PATH + "bar_" + label
    path = path.replace(">=", "bigger").replace("<", "smaller")
    plt.savefig(path)
    plt.close()
