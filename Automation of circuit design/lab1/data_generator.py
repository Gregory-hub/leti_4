import numpy as np


def norm_dataset(mu,sigma,N):
    mu0 = mu[0]
    mu1 = mu[1]
    sigma0 = sigma[0]
    sigma1 = sigma[1]

    col = len(mu0)                                          # количество столбцов-признаков – длина массива средних

    class0 = np.random.normal(mu0[0], sigma0[0], [N, 1])    # инициализируем первый столбец (в Python нумерация от 0)
    class1 = np.random.normal(mu1[0], sigma1[0], [N, 1])
    for i in range(1, col):
        v0 = np.random.normal(mu0[i], sigma0[i], [N, 1])
        class0 = np.hstack((class0, v0))

        v1 = np.random.normal(mu1[i], sigma1[i], [N, 1])
        class1 = np.hstack((class1, v1))

    Y1 = np.ones((N, 1), dtype=bool)
    Y0 = np.zeros((N, 1), dtype=bool)

    X = np.vstack((class0, class1))
    Y = np.vstack((Y0, Y1)).ravel()                         # ravel позволяет сделать массив плоским – одномерным, размера (N,)

    # перемешиваем данные
    rng = np.random.default_rng()
    arr = np.arange(2*N)                                    # индексы для перемешивания
    rng.shuffle(arr)
    X = X[arr]
    Y = Y[arr]

    return X, Y, class0, class1


def nonlinear_dataset_13(cen0, cen1, radii0, radii1, N):
    col = len(cen0)
    theta = 2 * np.pi * np.random.rand(N)
    theta = theta[:, np.newaxis]

    class0 = np.empty((N, col))
    class1 = np.empty((N, col))

    r = radii0[0] + np.random.rand(N)
    r = r[:, np.newaxis]
    class0[:, 0] = (r * np.sin(theta) + cen0[0]).flatten()

    r = radii1[0] + np.random.rand(N)
    r = r[:, np.newaxis]
    class1[:, 0] = (r * np.sin(theta) + cen1[0]).flatten()

    for i in range(1, col):
        r = radii0[i] + np.random.rand(N)
        r = r[:, np.newaxis]
        class0[:, i] = (r * np.cos(theta) + cen0[i]).flatten()

        r = radii1[i] + np.random.rand(N)
        r = r[:, np.newaxis]
        class1[:, i] = (r * np.cos(theta) + cen1[i]).flatten()

    Y1 = np.ones((N, 1), dtype=bool)
    Y0 = np.zeros((N, 1), dtype=bool)

    X = np.vstack((class0, class1))
    Y = np.vstack((Y0, Y1)).ravel()                         # ravel позволяет сделать массив плоским – одномерным, размера (N,)

    # перемешиваем данные
    rng = np.random.default_rng()
    arr = np.arange(2*N)                                    # индексы для перемешивания
    rng.shuffle(arr)
    X = X[arr]
    Y = Y[arr]

    return X, Y, class0, class1
