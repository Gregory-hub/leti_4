import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from data_generator import generate_dataset_A, generate_dataset_B, generate_dataset_C


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

# for i in range(0, 1):
#     # построение одной скатеррограммы по выбранным признакам
#     plt.scatter(class0[:, i], class0[:, (i + 1) % col], marker=".", alpha=0.7)
#     plt.scatter(class1[:, i], class1[:, (i + 1) % col], marker=".", alpha=0.7)
#     plt.title('Scatter')
#     plt.xlabel('Parameter ' + str(i))
#     plt.ylabel('Parameter ' + str((i + 1) % col))
#     plt.savefig('scatter_' + str(i + 1) + '.png')
#     plt.show()

clf = LogisticRegression(random_state=13, solver='saga').fit(Xtrain, Ytrain)

Pred_test = clf.predict(Xtest)                              # Predict class labels for samples in X.
Pred_test_proba = clf.predict_proba(Xtest)                  # Probability estimates

Pred_train = clf.predict(Xtrain)
Pred_train_proba = clf.predict_proba(Xtrain)

acc_train = clf.score(Xtrain, Ytrain)
acc_test = clf.score(Xtest, Ytest)
# acc_test = sum(Pred_test==Ytest)/len(Ytest)


# plt.hist(Pred_test_proba[Ytest,1], bins='auto', alpha=0.7)
# plt.hist(Pred_test_proba[~Ytest,1], bins='auto', alpha=0.7) # т.к массив свероятностями имеет два столбца, мы берем один - первый
# plt.title("Classification results (dataset C)")
# plt.savefig('classification_res' + '.png')
# plt.show()

# plt.hist(Pred_train_proba[Ytrain, 1], bins='auto', alpha=0.7)
# plt.hist(Pred_train_proba[~Ytrain, 1], bins='auto', alpha=0.7) # т.к массив свероятностями имеет два столбца, мы берем один - первый
# plt.title("Classification results (train) (dataset C)")
# plt.savefig('classification_res' + '.png')
# plt.show()


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

print('Accuracy (train):', acc_train)
print('Sensitivity (train):', sensitivity_train)
print('Specificity (train):', specificity_train)

print('Accuracy (test):', acc_test)
print('Sensitivity (test):', sensitivity_test)
print('Specificity (test):', specificity_test)
