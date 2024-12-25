function [X] = solve_imp_w_sync(X_s, X_m, h, p, K)
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'trust-region');
    % options = optimset('TolX', 1e-2, 'TolX', 1e-2, 'Display', 'none');

    E = X_m - X_s;
    
    fun = @(X_curr) X_s - X_curr + h * (f(X_s, p) + f(X_curr, p) + 2 * K' .* E) / 2;
    X = fsolve(fun, X_s + h * f(X_s, p)', options);
end
