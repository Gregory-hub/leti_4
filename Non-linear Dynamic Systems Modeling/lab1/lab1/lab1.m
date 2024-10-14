clear

X0 = [0 0 0];
h = 1e-3;
n = 1e6;

% X = solve_euler(X0, n, h);
X = solve_midpoint(X0, n, h);

plot_3d_time(h, X);
plot_3d_phase(X);
