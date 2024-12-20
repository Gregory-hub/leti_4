clear

a = 0.2;
b = 0.2;
c = 5.7;

X0_master = [1 1 1];
X0_slave = [-2 -1 -4];
h = 1e-2;
max_time = 1000;
funs = { @solve_euler, @solve_midpoint, @solve_cd };

n = round(max_time / h);

K_m = [0.5, 0, 0];
K_s = [0, 0.5, 0];


for m = 1 : length(funs)
    fun = funs{m};
    
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

        X_m = X_m + h * K_m .* (X_s - X_m);
        X_s = X_s + h * K_s .* (X_m - X_s);
        
        X_m_array(i, :) = X_m;
        X_s_array(i, :) = X_s;
        
        E(i) = norm(X_m - X_s);
    end
    
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
    title('Slave')
    grid on
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


    % figure
    % hold on
    % plot3(X_m_array(:,1), X_m_array(:,2), X_m_array(:,3));
    % plot3(X_s_array(:,1), X_s_array(:,2), X_s_array(:,3));
    % xlabel('x1')
    % ylabel('x2')
    % zlabel('x3')
    % grid on


    % figure
    % plot(t, E)
    % grid on
    % yscale('log')
    % title('Error')
    % xlabel('time')
    % ylabel('Error')

end
