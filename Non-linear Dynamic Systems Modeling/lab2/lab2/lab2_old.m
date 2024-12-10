% clear

a = 0.2;
b = 0.2;
c = 5.7;

X0 = [0 0 0];
% h = 1e-3;
max_time = 3000;

fun = @solve_euler;
min_p_pow = -5;
max_p_pow = -1;
p_pow_step = 1e-1;

p_pow = min_p_pow : p_pow_step : max_p_pow;
p = 10.^p_pow;

figure
title('Bifurcation diagram for Ressler system')
xlabel('h')
ylabel('Local maximum magnitude')
hold on

tic
% reference dopri8 calculation
bif_dopri = zeros(1, 2);
for i = 1 : length(p)
    n = round(max_time / p(i));
    X = solve_dopri8(X0, n, p(i), a, b, c);
    start_index = round(9 * length(X) / 10);
    pks = findpeaks(X(start_index:length(X), 1));
    for j = 1 : length(pks)
        bif_dopri(end + 1,:) = [p(i) pks(j)];
    end
end

time_dopri_calc = toc;

tic
% reference dopri8 plot
for i = 1 : length(bif_dopri)
    stem(bif_dopri(i, 1), bif_dopri(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'b')
end

time_dopri_plot = toc;

tic
% method calculation
bif = zeros(1, 2);
for i = 1 : length(p)
    n = round(max_time / p(i));
    X = fun(X0, n, p(i), a, b, c);
    start_index = round(9 * length(X) / 10);
    pks = findpeaks(X(start_index:length(X), 1));
    for j = 1 : length(pks)
        bif(end + 1,:) = [p(i) pks(j)];
    end
end

time_method_calc = toc;

tic
% method plot
for i = 1 : length(bif)
    stem(bif(i, 1), bif(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'r')
end

time_method_plot = toc;

grid on

% X = fun(X0, n, h, 0.2, b, c);
% plot_3d_time(h, X);
% plot_3d_phase(X);


disp('Dopri8 calculation time: ' + string(time_dopri_calc))
disp('Dopri8 plot time: ' + string(time_dopri_plot))
disp('Method calculation time: ' + string(time_method_calc))
disp('Method plot time: ' + string(time_method_plot))
