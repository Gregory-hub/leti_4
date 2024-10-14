function [Y] = solve_midpoint(X, n, h)
    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        X(1) = Y(i - 1, 1);
        X(2) = Y(i - 1, 2);
        X(3) = Y(i - 1, 3);

        [F] = f(X + h / 2 * f(X));
        
        Y(i, 1) = X(1) + h * F(1);
        Y(i, 2) = X(2) + h * F(2);
        Y(i, 3) = X(3) + h * F(3);
    end
end
