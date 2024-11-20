clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
eps = 1e-8;
h = 1e-2;
max_time = 1000;
interval_time = 0.5;
solve = @solve_cd;

p_step = 1e-4;
min_p = p_step;
max_p = 0.1;

p = min_p : p_step : max_p;

figure
xlabel('h')
ylabel('LLE')
hold on

LLE = zeros(size(p));

for i = 1 : length(p)
    lle = find_lle(p(i), x, max_time, interval_time, eps, solve, a, b, c);
    LLE(i) = lle;
end

loglog(p, LLE)
grid on
