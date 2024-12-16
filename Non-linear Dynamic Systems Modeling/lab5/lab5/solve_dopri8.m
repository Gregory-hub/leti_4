function [Y] = solve_dopri8(X, n, h, a, b, c)
    f_ode = @(t, X) f(X, a, b, c)';

    [~, Y] = ode78(f_ode, 0 : h : n * h, X);
end
