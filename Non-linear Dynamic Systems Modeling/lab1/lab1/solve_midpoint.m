function [Y] = solve_midpoint(X, n, h)
    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        Y_prev = Y(i - 1, :);
        [F] = f(Y_prev + h / 2 * f(Y_prev));
        Y(i, :) = Y_prev + h * F;
    end
end
