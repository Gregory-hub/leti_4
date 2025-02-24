import numpy as np
import matplotlib.pyplot as plt
from data_generator import norm_dataset, nonlinear_dataset_13

mu0 = [0, 1, 1]
mu1 = [5, 5, 5]
sigma0 = [1, 1, 2]
sigma1 = [1, 2, 1]

N = 1000                                                # число объектов класса
col = len(mu0)                                          # количество столбцов-признаков – длина массива средних

mu = [mu0, mu1]
sigma = [sigma0, sigma1]
X, Y, class0, class1 = norm_dataset(mu, sigma, N)
# X, Y, class0, class1 = nonlinear_dataset_13([0, 0, 0], [0, 0, 0], [6, 0, 2], [2, 0, 0], N)

# разделяем данные на 2 подвыборки
trainCount = round(0.7*N*2)                             # не забываем округлить до целого
Xtrain = X[0:trainCount]
Xtest = X[trainCount:N*2+1]
Ytrain = Y[0:trainCount]
Ytest = Y[trainCount:N*2+1]

# построение гистограмм распределения для всех признаков
for i in range(0, col):
    _ = plt.hist(class0[:, i], bins='auto', alpha=0.7)  # параметр alpha позволяет задать прозрачность цвета
    _ = plt.hist(class1[:, i], bins='auto', alpha=0.7)
    plt.title('Parameter ' + str(i))
    plt.xlabel('Parameter value')
    plt.ylabel('Number of objects')
    plt.savefig('hist_' + str(i + 1) + '.png')          # сохранение изображения в файл
    plt.show()

# построение одной скатеррограммы по выбранным признакам
plt.scatter(class0[:, 0], class0[:, 2], marker=".", alpha=0.7)
plt.scatter(class1[:, 0], class1[:, 2], marker=".", alpha=0.7)
plt.title('Scatter')
plt.xlabel('Parameter 0')
plt.ylabel('Parameter 2')
plt.savefig('scatter_' + str(i + 1) + '.png')
plt.show()

# plt.scatter(class0[:, 0], class0[:, 1], marker=".", alpha=0.7)
# plt.scatter(class1[:, 0], class1[:, 1], marker=".", alpha=0.7)
# plt.title('Scatter')
# plt.xlabel('Parameter 0')
# plt.ylabel('Parameter 2')
# plt.savefig('scatter_' + str(i + 1) + '.png')
# plt.show()

# plt.scatter(class0[:, 1], class0[:, 2], marker=".", alpha=0.7)
# plt.scatter(class1[:, 1], class1[:, 2], marker=".", alpha=0.7)
# plt.title('Scatter')
# plt.xlabel('Parameter 0')
# plt.ylabel('Parameter 2')
# plt.savefig('scatter_' + str(i + 1) + '.png')
# plt.show()
