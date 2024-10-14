function [Y] = solve_cd(X, n, h, s)
    h1 = s * h;
    h2 = (1 - s) * h;
    
    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        % Euler
        X(1) = Y(i - 1, 1);
        X(2) = Y(i - 1, 2);
        X(3) = Y(i - 1, 3);
        
        [F] = f(X);
        
        X(1) = X(1) + h1 * F(1);
        X(2) = X(2) + h1 * F(2);
        X(3) = X(3) + h1 * F(3);

        % 
    end
end
