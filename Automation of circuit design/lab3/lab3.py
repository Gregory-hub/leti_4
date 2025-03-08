import numpy as np
import scikitplot as skplt
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score

from data_generator import generate_dataset_A, generate_dataset_B, generate_dataset_C
from test_classification import test_classification, build_scatters, plot_clf_results


N = 1000                                                    # число объектов класса
col = 3

# X, Y, class0, class1 = generate_dataset_A(N)              # linear good
# X, Y, class0, class1 = generate_dataset_B(N)              # linear bad
X, Y, class0, class1 = generate_dataset_C(N)                # non-linear

# разделяем данные на 2 подвыборки
trainCount = round(0.7*N*2)
Xtrain = X[0:trainCount]
Xtest = X[trainCount:N*2+1]
Ytrain = Y[0:trainCount]
Ytest = Y[trainCount:N*2+1]

# build_scatters(class0, class1)

# clf = DecisionTreeClassifier(random_state=0).fit(Xtrain, Ytrain)
# clf = DecisionTreeClassifier(random_state=0, max_depth=9).fit(Xtrain, Ytrain)
clf = RandomForestClassifier(random_state=0).fit(Xtrain, Ytrain)

Pred_test, Pred_test_proba, acc_test, sensitivity_test, specificity_test = test_classification(
    clf, Xtest, Ytest)

Pred_train, Pred_train_proba, acc_train, sensitivity_train, specificity_train = test_classification(
    clf, Xtrain, Ytrain)

plot_clf_results(Pred_train_proba, Ytrain, "RFC Classification results (train) (dataset A)")
plot_clf_results(Pred_test_proba, Ytest, "RFC Classification results (test) (dataset A)")

skplt.metrics.plot_roc_curve(Ytest, Pred_test_proba, figsize = (8, 8))
plt.savefig('RFC_roc_curve_test_dataset_A' + '.png')
plt.show()

# Расчет площади под кривой
AUC = roc_auc_score(Ytest, Pred_test_proba[:, 1])

# Расчет максимальной площади под кривой
max_AUC = 0
max_AUC_n_est = 0
for d in range(1, 301, 10):
    clf_auc = RandomForestClassifier(random_state=0, n_estimators=d).fit(Xtrain, Ytrain)
    Pred_test, Pred_test_proba, acc_test, sensitivity, specificity = test_classification(
        clf_auc, Xtest, Ytest)
    a = roc_auc_score(Ytest, Pred_test_proba[:, 1])
    if a > max_AUC:
        max_AUC = a
        max_AUC_n_est = d

print('Accuracy (train):', acc_train)
print('Sensitivity (train):', sensitivity_train)
print('Specificity (train):', specificity_train)

print('Accuracy (test):', acc_test)
print('Sensitivity (test):', sensitivity_test)
print('Specificity (test):', specificity_test)

print("AUC: " + str(AUC))
print("Max AUC: " + str(max_AUC) + " (number of trees: " + str(max_AUC_n_est) + ")")
