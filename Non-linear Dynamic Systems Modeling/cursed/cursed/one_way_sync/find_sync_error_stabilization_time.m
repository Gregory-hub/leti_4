function [time] = find_sync_error_stabilization_time(X0_master, X0_slave, h, n, fun, K, a, b, c, error_tolerance)
    [~, ~, E] = sync_one_way(X0_master, X0_slave, h, n, fun, K, a, b, c);
    
    index = find(E <= error_tolerance, 1);
    if (isempty(index))
        time = Inf;
    else
        time = index * h;
    end
end
