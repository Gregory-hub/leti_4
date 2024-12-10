clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
eps = 1e-8;
max_time = 1000;
interval_time = 0.5;
solve = @solve_cd;

min_p_pow = -4;
max_p_pow = -1;
p_pow_step = 1e-2;

p_pow = min_p_pow : p_pow_step : max_p_pow;
p = 10.^p_pow;

figure
xlabel('h')
ylabel('LLE')
xscale('log')
hold on

LLE = zeros(size(p));

for i = 1 : length(p)
    lle = find_lle(p(i), x, max_time, interval_time, eps, solve, a, b, c);
    LLE(i) = lle;
end

plot(p, LLE)
grid on
