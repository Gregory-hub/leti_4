clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
h = 1e-2;
max_time = 2000;
solve = @solve_cd;

n = max_time / h;

p_step = 20e-1;
min_p = 1;
max_p = 10;

p = min_p : p_step : max_p;

figure
xlabel('c')
ylabel('SE')
hold on

SE = zeros(size(p));

for i = 1 : length(p)
    X = solve(x, n, h, a, b, p(i));
    se = find_spectral_entropy(X(floor(9 * length(X) / 10) : end, 1));
    SE(i) = se;
end

plot(p, SE)
grid on
