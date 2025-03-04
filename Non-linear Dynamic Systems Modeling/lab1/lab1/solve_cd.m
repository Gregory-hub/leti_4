function [Y] = solve_cd(X, n, h, s)
    h1 = s * h;
    h2 = (1 - s) * h;
    
    a = 0.2;
    b = 0.2;
    c = 5.7;

    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        % Euler
        Y_prev = Y(i - 1, :);
        
        Y_mid = zeros(1, 3);
        
        Y_mid(1) = Y_prev(1) + h1 * (-Y_prev(2) - Y_prev(3));
        Y_mid(2) = Y_prev(2) + h1 * (Y_mid(1) + a * Y_prev(2));
        Y_mid(3) = Y_prev(3) + h1 * (b + Y_prev(3) * (Y_mid(1) - c));
        
        % D-method
        Y(i, 3) = (Y_mid(3) + h2 * b) / (1 - h2 * Y_mid(1) + h2 * c);
        Y(i, 2) = (Y_mid(2) + h2 * Y_mid(1)) / (1 - a * h2);
        Y(i, 1) = Y_mid(1) + h2 * (-Y(i, 2) - Y(i, 3));
    end
end
