function [Y] = f(X, p)  
    % dx1 / dt = Y(1)
    % dx2 / dt = Y(2)
    % dx2 / dt = Y(3)
    
    a = p(1);
    b = p(2);
    c = p(3);
    
    Y = zeros(1, 3);
    Y(1) = -X(2) - X(3);
    Y(2) = X(1) + a * X(2);
    Y(3) = b + X(3) * (X(1) - c);
end
