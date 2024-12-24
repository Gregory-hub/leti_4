function [X] = solve_imp_w_sync(X_s, X_m, h, p, K)
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'trust-region');
    
    E = X_m - X_s;
    X = zeros(size(X_s));

    fun = @(Y) X_s - Y + h / 2 * f(X_s + Y + K .* E, p(1), p(2), p(3));

    % 
    % X_mid = X_s + h / 2 * f(X_s, a, b, c);
    % fun = @(Y_curr) X_mid - X_s + h / 2 * f(X_mid, a, b, c);
    % 
    % X = 2 * fsolve(fun, X_mid, options) - X_s;
    X = fsolve(fun, X_s, options);
end
