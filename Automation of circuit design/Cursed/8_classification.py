import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
import scikitplot as skplt

from read_data import read_data
from constants import *
from plot_data import *


def prepare_data(c0: pd.DataFrame, c1: pd.DataFrame):
    Y0 = np.zeros((c0.shape[0], 1), dtype=bool)
    Y1 = np.ones((c1.shape[0], 1), dtype=bool)

    X = np.vstack((c0, c1))
    Y = np.vstack((Y0, Y1)).ravel()

    # перемешиваем данные
    rng = np.random.default_rng()
    arr = np.arange(X.shape[0])
    rng.shuffle(arr)
    X = X[arr]
    Y = Y[arr]

    return X, Y


if __name__ == "__main__":
    df, _, col_investigated = read_data(False)

    column_names_dropped = []

    for name in df.columns:
        if df[name].dtype == 'object':
            column_names_dropped.append(name)
    
    df = df.drop(columns=column_names_dropped)

    # print(df)
    print(df.columns)

    label_c0 = LABEL_POSITIVE
    label_c1 = LABEL_NEGATIVE

    positive = col_investigated >= PRICE_THRESHOLD

    c0 = df[positive]
    c1 = df[positive == False]

    X, Y = prepare_data(c0, c1)

    N = X.shape[0]

    # разделяем данные на 2 подвыборки
    trainCount = round(0.7*N)
    Xtrain = X[0:trainCount]
    Xtest = X[trainCount:N+1]
    Ytrain = Y[0:trainCount]
    Ytest = Y[trainCount:N+1]

    # col_name_0 = 'inches'
    # col_name_1 = 'battery'
    # plt.scatter(c0[col_name_0], c0[col_name_1], marker=".", alpha=0.7)
    # plt.scatter(c1[col_name_0], c1[col_name_1], marker=".", alpha=0.7)
    # plt.title('Scatter')
    # plt.xlabel(col_name_0)
    # plt.ylabel(col_name_1)
    # plt.show()

    clf = LogisticRegression(random_state=13, solver='saga').fit(Xtrain, Ytrain)

    Pred_test = clf.predict(Xtest)                              # Predict class labels for samples in X.
    Pred_test_proba = clf.predict_proba(Xtest)                  # Probability estimates

    Pred_train = clf.predict(Xtrain)
    Pred_train_proba = clf.predict_proba(Xtrain)

    acc_train = clf.score(Xtrain, Ytrain)
    acc_test = clf.score(Xtest, Ytest)

    plt.hist(Pred_train_proba[Ytrain, 1], bins='auto', alpha=0.7)
    plt.hist(Pred_train_proba[~Ytrain, 1], bins='auto', alpha=0.7) # т.к массив свероятностями имеет два столбца, мы берем один - первый
    plt.title("Classification results (train)")
    plt.xlabel("probability")
    plt.ylabel('n')
    plt.grid(True)
    plt.savefig(IMAGE_PATH + 'classification_train' + '.png')
    plt.show()

    plt.hist(Pred_test_proba[Ytest,1], bins='auto', alpha=0.7)
    plt.hist(Pred_test_proba[~Ytest,1], bins='auto', alpha=0.7) # т.к массив свероятностями имеет два столбца, мы берем один - первый
    plt.title("Classification results (test)")
    plt.xlabel("probability")
    plt.ylabel('n')
    plt.grid(True)
    plt.savefig(IMAGE_PATH + 'classification_test' + '.png')
    plt.show()

    sensitivity_test = 0
    specificity_test = 0
    for i in range(len(Pred_test)):
        if Pred_test[i]==True and Ytest[i]==True:
            sensitivity_test += 1

        if Pred_test[i]==False and Ytest[i]==False:
            specificity_test += 1

    sensitivity_test /= len(Pred_test[Pred_test==True])
    specificity_test /= len(Pred_test[Pred_test==False])

    sensitivity_train = 0
    specificity_train = 0
    for i in range(len(Pred_train)):
        if Pred_train[i]==True and Ytrain[i]==True:
            sensitivity_train += 1

        if Pred_train[i]==False and Ytrain[i]==False:
            specificity_train += 1

    sensitivity_train /= len(Pred_train[Pred_train==True])
    specificity_train /= len(Pred_train[Pred_train==False])

    print('Accuracy (train):', round(acc_train, 3))
    print('Sensitivity (train):', round(sensitivity_train, 3))
    print('Specificity (train):', round(specificity_train, 3))

    print('Accuracy (test):', round(acc_test, 3))
    print('Sensitivity (test):', round(sensitivity_test, 3))
    print('Specificity (test):', round(specificity_test, 3))

    skplt.metrics.plot_roc_curve(Ytest, Pred_test_proba, figsize = (8, 8))
    plt.grid(True)
    plt.savefig(IMAGE_PATH + 'RFC_roc_curve_test' + '.png')
    plt.show()
