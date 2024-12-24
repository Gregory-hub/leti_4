function [Y] = solve_cd(X, n, h, a, b, c)
    s = 0.5;
    h1 = s * h;
    h2 = (1 - s) * h;

    Y = zeros(n + 1, 3);
    Y(1, 1:3) = X;
    
    for i = 2 : n + 1
        Y_prev = Y(i - 1, :);
        
        Y_mid = zeros(1, 3);
        
        Y_mid(1) = Y_prev(1) + h1 * (-Y_prev(2) - Y_prev(3));
        Y_mid(2) = Y_prev(2) + h1 * (Y_mid(1) + a * Y_prev(2));
        Y_mid(3) = Y_prev(3) + h1 * (b + Y_prev(3) * (Y_mid(1) - c));
        
        Y(i, 3) = (Y_mid(3) + h2 * b) / (1 - h2 * Y_mid(1) + h2 * c);
        Y(i, 2) = (Y_mid(2) + h2 * Y_mid(1)) / (1 - a * h2);
        Y(i, 1) = Y_mid(1) + h2 * (-Y(i, 2) - Y(i, 3));
    end
end
