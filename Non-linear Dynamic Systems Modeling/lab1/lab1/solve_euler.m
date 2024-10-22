function [Y] = solve_euler(X, n, h)
    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        Y_prev = Y(i - 1, :);
        Y(i, :) = Y_prev + h * f(Y_prev);
    end
end
