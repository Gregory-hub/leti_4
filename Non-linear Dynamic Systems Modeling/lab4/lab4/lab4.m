clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
h = 1e-3;
max_time = 1000;
solve = @solve_euler;

n = max_time / h;

p_step = 1e-2;
min_p = 0;
max_p = 2;

p = min_p : p_step : max_p;

figure
xlabel('b')
ylabel('SE')
hold on

SE = zeros(size(p));

for i = 1 : length(p)
    X = solve(x, n, h, a, p(i), c);
    se = find_spectral_entropy(X(:, 1));
    SE(i) = se;
end

plot(p, SE)
grid on
