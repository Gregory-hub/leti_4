clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
h = 1e-2;
max_time = 100;
% fun = @solve_cd;
fun = @solve_imp;

n = round(max_time / h);

special_points = zeros(2, 3);
D = c^2 - 4 * a * b;
special_points(1, :) = [(c + sqrt(D)) / 2, -(c + sqrt(D)) / (2 * a), (c + sqrt(D)) / (2 * a)];
special_points(2, :) = [(c - sqrt(D)) / 2, -(c - sqrt(D)) / (2 * a), (c - sqrt(D)) / (2 * a)];

X = fun(x, n, h, a, b, c);
plot_3d_phase(X, special_points);

