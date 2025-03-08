import matplotlib.pyplot as plt


def test_classification(clf, X, Y):
    Pred = clf.predict(X)
    Pred_proba = clf.predict_proba(X)

    acc = clf.score(X, Y)

    sensitivity = 0
    specificity = 0
    for i in range(len(Pred)):
        if Pred[i]==True and Y[i]==True:
            sensitivity += 1

        if Pred[i]==False and Y[i]==False:
            specificity += 1

    sensitivity /= len(Pred[Pred==True])
    specificity /= len(Pred[Pred==False])

    return Pred, Pred_proba, acc, sensitivity, specificity


def build_scatters(class0, class1):
    col = len(class0[0])
    for i in range(0, col):
        # построение одной скатеррограммы по выбранным признакам
        plt.scatter(class0[:, i], class0[:, (i + 1) % col], marker=".", alpha=0.7)
        plt.scatter(class1[:, i], class1[:, (i + 1) % col], marker=".", alpha=0.7)
        plt.title('Scatter')
        plt.xlabel('Parameter ' + str(i))
        plt.ylabel('Parameter ' + str((i + 1) % col))
        # plt.savefig('scatter_' + str(i + 1) + '.png')
        plt.show()


def plot_clf_results(pred_proba, Y, title=""):
    plt.hist(pred_proba[Y, 1], bins=8, alpha=0.7)
    plt.hist(pred_proba[~Y, 1], bins=8, alpha=0.7)
    plt.title(title)
    plt.savefig(title.replace(' ', '_') + '.png')
    plt.show()
