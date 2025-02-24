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

for i in range(0, col):
    # построение одной скатеррограммы по выбранным признакам
    plt.scatter(class0[:, i], class0[:, (i + 1) % col], marker=".", alpha=0.7)
    plt.scatter(class1[:, i], class1[:, (i + 1) % col], marker=".", alpha=0.7)
    plt.title('Scatter')
    plt.xlabel('Parameter ' + str(i))
    plt.ylabel('Parameter ' + str((i + 1) % col))
    plt.savefig('scatter_' + str(i + 1) + '.png')
    plt.show()

clf = LogisticRegression(random_state=13, solver='saga').fit(Xtrain, Ytrain)

Pred_test = clf.predict(Xtest)                              # Predict class labels for samples in X.
Pred_test_proba = clf.predict_proba(Xtest)                  # Probability estimates

acc_train = clf.score(Xtrain, Ytrain)
acc_test = clf.score(Xtest, Ytest)
# acc_test = sum(Pred_test==Ytest)/len(Ytest)

print('Accuracy train:', acc_train)
print('Accuracy test:', acc_test)

plt.hist(Pred_test_proba[Ytest,1], bins='auto', alpha=0.7)
plt.hist(Pred_test_proba[~Ytest,1], bins='auto', alpha=0.7) # т.к массив свероятностями имеет два столбца, мы берем один - первый
plt.title("Результаты классификации, тест")
plt.savefig('classification_res_' + str(i + 1) + '.png')
plt.show()

sensitivity = 0
specificity = 0
for i in range(len(Pred_test)):
    if Pred_test[i]==True and Ytest[i]==True:
        sensitivity += 1

    if Pred_test[i]==False and Ytest[i]==False:
        specificity += 1

sensitivity /= len(Pred_test[Pred_test==True])
specificity /= len(Pred_test[Pred_test==False])

print('Sensitivity:', sensitivity)
print('Specificity:', specificity)
