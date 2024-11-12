% clear

a = 0.2;
b = 0.2;
c = 5.7;

X0 = [0 0 0];
h = 1e-2;
max_time = 200;

n = max_time / h;

fun = @solve_euler;

p_step = 5e-4;
max_p = 0.37;

p = 0 : p_step : max_p;

figure
title('Bifurcation diagram for Ressler system')
xlabel('a')
ylabel('Local maximum magnitude')
hold on


% reference dopri8 calculation
bif_dopri = zeros(1, 2);
for i = 1 : length(p)
    X = solve_dopri8(X0, n, h, p(i), b, c);
    start_index = round(length(X) / 2);
    pks = findpeaks(X(start_index:length(X), 1));
    for j = 1 : length(pks)
        bif_dopri(end + 1,:) = [p(i) pks(j)];
    end
end


% reference dopri8 plot
for i = 1 : length(bif_dopri)
    stem(bif_dopri(i, 1), bif_dopri(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 1, 'Color', 'b')
end

for i = 1 : length(p)
    X = fun(X0, n, h, p(i), b, c);
    start_index = round(length(X) / 2);
    pks = findpeaks(X(start_index:length(X), 1));
    % plot(p(i), pks, '.')
    for j = 1 : length(pks)
        stem(p(i), pks(j), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 1, 'Color', 'r')
    end
end
grid on

% X = fun(X0, n, h, 0.2, b, c);
% plot_3d_time(h, X);
% plot_3d_phase(X);
