clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
max_time = 2000;
fun = @solve_cd;

min_p_pow = -4;
max_p_pow = -1;
p_pow_step = 1e-2;
 
p_pow = min_p_pow : p_pow_step : max_p_pow;
p = 10.^p_pow;

thread_num = 6;

indices = zeros(thread_num, 1);
for i = 1 : length(indices)
    indices(i) = floor(length(p) / 10^(thread_num - i + 1)) + 1;
    if (i > 1 && indices(i) <= indices(i - 1))
        indices(i) = indices(i - 1) + 1;
    end
end

figure
xlabel('h')
ylabel('SE')
xscale log
hold on

SE = zeros(size(p));

for i = 1 : length(p)
    n = round(max_time / p(i));
    X = fun(x, n, p(i), a, b, c);
    se = find_spectral_entropy(X(floor(9 * length(X) / 10) : end, 1));
    SE(i) = se;
end

plot(p, SE)
grid on
