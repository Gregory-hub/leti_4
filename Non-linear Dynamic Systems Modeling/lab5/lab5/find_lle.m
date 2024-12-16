function [lle] = find_lle(h, x, max_time, interval_time, eps, solve, a, b, c)
    x1 = x + eps;
    n = floor(interval_time / h);

    lle = 0;
    for i = 1 : max_time / interval_time
        X = solve(x, n, h, a, b, c);
        X1 = solve(x1, n, h, a, b, c);
        x = X(end, :);
        x1 = X1(end, :);
        lle = lle + log(norm(x1 - x) / eps);
        x1 = x + eps * (x1 - x) / (norm(x1 - x));
    end

    lle = lle / max_time;
end
