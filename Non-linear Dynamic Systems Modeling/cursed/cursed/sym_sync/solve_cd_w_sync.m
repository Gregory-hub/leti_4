function [X] = solve_cd_w_sync(X_s, X_m, h, p, K)
    s = 0.5;
    h1 = s * h;
    h2 = (1 - s) * h;

    E = X_m - X_s;
    X = zeros(size(X_s));
    X_mid = zeros(size(X_s));
    
    X_mid(1) = X_s(1) + h1 * (-X_s(2) - X_s(3));
    X_mid(2) = X_s(2) + h1 * (X_mid(1) + p(1) * X_s(2) + K(2) * E(2));
    X_mid(3) = X_s(3) + h1 * (p(2) + X_s(3) * (X_mid(1) - p(3)));

    X(3) = (X_mid(3) + h2 * p(2)) / (1 - h2 * (X_mid(1) - p(3)));
    X(2) = (X_mid(2) + h2 * (X_mid(1) + K(2) * E(2))) / (1 - p(1) * h2);
    X(1) = X_mid(1) + h2 * (-X(2) - X(3));
end
