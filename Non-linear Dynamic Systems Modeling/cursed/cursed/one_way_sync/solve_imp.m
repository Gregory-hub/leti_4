function [Y] = solve_imp(X, n, h, a, b, c)
    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'trust-region');

    for i = 2 : n + 1
        Y_prev = Y(i - 1, :);
        Y_mid = Y_prev + h / 2 * f(Y_prev, a, b, c);
        fun = @(Y_curr) Y_mid - Y_prev + h / 2 * f(Y_mid, a, b, c);
        
        % fun = @(Y_curr) f_for_imp(Y_prev, Y_curr, h, a, b, c);

        Y(i, :) = 2 * fsolve(fun, Y_mid, options) - Y_prev;
    end
end