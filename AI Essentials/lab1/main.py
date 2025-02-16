from mylogclass import *
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
import matplotlib.pyplot as plt
from matplotlib import colormaps


if __name__ == '__main__':
    data = load_iris() # X is data [150 x 4], y is class [150 x 1], y in {0,1,2}
    X = data.data
    y = data.target
    fnames = data.feature_names

    #plot data
    cmap = colormaps['Set1']
    for i in range(len(y)):
        plt.scatter(X[i,2],X[i,3],color = cmap.colors[y[i]],marker='*')
    plt.xlabel(fnames[2])
    plt.ylabel(fnames[3])
    plt.text(6, 1.5, 'virginica')
    plt.text(4.3, 1, 'versicolor')
    plt.text(2.3, 0.25, 'setosa')

    #let us classify only virginica, using only data columns 2 and 3
    yvirg = y.copy()
    for i in range(len(y)):
        yvirg[i] = 1 if y[i] == 2 else 0 # sort number 2 is virginica

    #uncomment to get off-the-box solution with sklearn

    clf = LogisticRegression(random_state=0).fit(X[:,2:3], yvirg)
    ypred = clf.predict(X[:, 2:3])

    # comment to skip
    #theta =  mylearn(X,y)
    #ypred = mypredict(theta,X)

    #outline predicted classes
    for i in range(len(y)):
        plt.scatter(X[i,2],X[i,3],edgecolors = cmap.colors[ypred[i]],marker='o',s=80, facecolors='none')
    plt.show()
