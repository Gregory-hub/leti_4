clear

X0 = [0 0 0];
h = 2e-2;
max_time = 1000;

n = round(max_time / h);

X = solve_euler(X0, n, h);
% X = solve_midpoint(X0, n, h);
% X = solve_cd(X0, n, h, 0.5);
% X = solve_dopri8(X0, n, h);

plot_3d_time(h, X);
plot_3d_phase(X);

% compare_to_dopri(X, X0, n, h);
