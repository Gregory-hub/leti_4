function [Y] = solve_imp(X, n, h, a, b, c)
    Y = zeros(n + 1, 3);
    Y(1, :) = X;
    
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'trust-region');

    for i = 2 : n + 1
        Y_prev = Y(i - 1, :);
        fun = @(Y_curr) Y_prev - Y_curr + h * (f(Y_prev, a, b, c) + f(Y_curr, a, b, c)) / 2;
        Y(i, :) = fsolve(fun, Y_prev, options);
    end
end
