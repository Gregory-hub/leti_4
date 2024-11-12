clear

a = 0.2;
b = 0.2;
c = 5.7;

eps = 1e-12;
x = [0 0 0];
h = 1e-3;
max_time = 1000;
interval_time = 50;
solve = @solve_cd;

x1 = x + eps;
n = interval_time / h;

lle = 0;
for i = 1 : max_time / interval_time
    X = solve(x, n, h, a, b, c);
    X1 = solve(x1, n, h, a, b, c);
    x = X(end, :);
    x1 = X1(end, :);
    lle = lle + log10(x1 / x);
    x1 = x + eps * (x1 - x) / (norm(x1 - x));
end

lle = lle / max_time
