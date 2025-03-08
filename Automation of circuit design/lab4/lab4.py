import numpy as np
import matplotlib.pyplot as plt

from NeuralNetwork import NeuralNetwork
import data_generator as dg

N = 1000

X, Y, class0, class1 = dg.generate_dataset_A(N)
Y = np.reshape(Y, [2000, 1])

n_neuro = 4
NN = NeuralNetwork(X, Y, n_neuro) # инициализируем сетку на наших данных

# Accuracy and loss while training
N_epoch = 70
accuracy = np.zeros(N_epoch)
loss = np.zeros(N_epoch)
for i in range(N_epoch):
    pred_proba = NN.feedforward()
    pred = pred_proba >= 0.5
    accuracy[i] = sum(pred == Y) / len(pred)
    loss[i] = np.mean(np.square(Y - NN.feedforward()))

    print("Iteration #" + str(i) + ":")
    print("Accuracy: " + str(accuracy[i]))
    print("Loss: " + str(loss[i]))
    print()
    NN.train(X, Y) # обучение сети

weigths = [NN.weights1, NN.weights2]

plt.plot(loss)
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.title("Loss")
plt.savefig("loss.png")
plt.show()

plt.plot(accuracy)
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.title("Accuracy")
plt.savefig("accuracy.png")
plt.show()


# Accuracy when changing neurons number
max_neuro_n = 20
accuracy = np.zeros(max_neuro_n)
loss = np.zeros(max_neuro_n)
for i in range(1, max_neuro_n):
    NN_1 = NeuralNetwork(X, Y, i)
    for j in range(N_epoch):
        NN_1.train(X, Y) # обучение сети
    
    pred_proba = NN_1.feedforward()
    pred = pred_proba >= 0.5
    accuracy[i] = sum(pred == Y) / len(pred)

plt.plot(accuracy)
plt.xlabel("Number of neurons")
plt.ylabel("Accuracy")
plt.title("Accuracy")
plt.savefig("accuracy_neuron_n.png")
plt.show()


pred_proba = NN.feedforward()
pred = pred_proba >= 0.5

acc = sum(pred == Y) / len(pred)
print("Accuracy:", acc[0])

print("Weights:")
print(*weigths, sep="\n")
