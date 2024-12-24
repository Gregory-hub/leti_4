function [X_m_array, X_s_array, E] = sync_one_way(X0_master, X0_slave, h, n, fun, K, a, b, c)   
    X_m_array = zeros(n, 3);
    X_s_array = zeros(n, 3);
    E = zeros(n, 1);
    
    X_m = X0_master;
    X_s = X0_slave;
    
    for i = 1 : n
        Y_m = fun(X_m, 1, h, a, b, c);
        Y_s = fun(X_s, 1, h, a, b, c);
        
        X_m = Y_m(end, :);
        X_s = Y_s(end, :);
        X_s = X_s + h * K .* (X_m - X_s);
        
        X_m_array(i, :) = X_m;
        X_s_array(i, :) = X_s;

        E(i) = norm(X_m - X_s);
    end
end
