clear

a = 0.2;
b = 0.2;
c = 5.7;

X0_master = [0 0 0];
X0_slave = [1 2 3];
h = 1e-2;
max_time = 200;
transient_time = 100;
% funs = { @solve_cd };
funs = { @solve_imp };

n = round(max_time / h);

K = [0, 0.5, 0];
% K = [0, 2.08, 0];

for m = 1 : length(funs)
    fun = funs{m};
    
    X_m_array = zeros(n, 3);
    X_s_array = zeros(n, 3);
    E = zeros(n, 1);
    
    X_m = X0_master;
    X_s = X0_slave;
    
    for i = 1 : transient_time / h
        Y_m = fun(X_m, 1, h, a, b, c);
        Y_s = fun(X_s, 1, h, a, b, c);
        
        X_m = Y_m(end, :);
        X_s = Y_s(end, :);
    end

    wb = waitbar(0, 'Please wait...');
    for i = 1 : n
        waitbar(i/n, wb, 'Processing...');
        Y_m = fun(X_m, 1, h, a, b, c);
        Y_s = fun(X_s, 1, h, a, b, c);
        
        X_m = Y_m(end, :);
        X_s = Y_s(end, :);
        X_s = X_s + h * K .* (X_m - X_s);
        
        X_m_array(i, :) = X_m;
        X_s_array(i, :) = X_s;

        E(i) = norm(X_m - X_s);
    end
    close(wb);

    t = 0 : h : (n - 1) * h;
    
    figure
    
    subplot(3, 3, 1)
    hold on
    plot(t, X_m_array(:, 1), 'b');
    grid on
    title('Master')
    xlabel('time')
    ylabel('x1')
    
    subplot(3, 3, 4)
    hold on
    plot(t, X_m_array(:, 2), 'b');
    grid on
    xlabel('time')
    ylabel('x2')
    
    subplot(3, 3, 7)
    hold on
    plot(t, X_m_array(:, 3), 'b');
    grid on
    xlabel('time')
    ylabel('x3')    


    subplot(3, 3, 2)
    hold on
    plot(t, X_s_array(:, 1), 'r');
    grid on
    title('Slave')
    xlabel('time')
    ylabel('x1')

    subplot(3, 3, 5)
    hold on
    plot(t, X_s_array(:, 2), 'r');
    grid on
    xlabel('time')
    ylabel('x2')

    subplot(3, 3, 8)
    hold on
    plot(t, X_s_array(:, 3), 'r');
    grid on
    xlabel('time')
    ylabel('x3')


    subplot(3, 3, 3)
    hold on
    plot(t, X_m_array(:, 1), 'b');
    plot(t, X_s_array(:, 1), 'r');
    title('Master and slave')
    grid on
    xlabel('time')
    ylabel('x1')

    subplot(3, 3, 6)
    hold on
    plot(t, X_m_array(:, 2), 'b');
    plot(t, X_s_array(:, 2), 'r');
    grid on
    xlabel('time')
    ylabel('x2')

    subplot(3, 3, 9)
    hold on
    plot(t, X_m_array(:, 3), 'b');
    plot(t, X_s_array(:, 3), 'r');
    grid on
    xlabel('time')
    ylabel('x3')

    
    figure
    hold on
    plot3(X_m_array(:,1), X_m_array(:,2), X_m_array(:,3));
    plot3(X_s_array(:,1), X_s_array(:,2), X_s_array(:,3));
    xlabel('x1')
    ylabel('x2')
    zlabel('x3')
    grid on

    figure
    plot(t, E)
    grid on
    yscale('log')
    title('Error')
    xlabel('time')
    ylabel('Error')

end
