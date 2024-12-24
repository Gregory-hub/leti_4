clear

a = 0.2;
b = 0.2;
c = 5.7;

p = [a, b, c];

X0_m = [0 0 0];
X0_s = [1 2 3];
% X0_s = [3 -3 0];
h = 1e-2;
max_time = 100;
transient_time = 100;
window_time = 1;
iterations = 100;
fun = @solve_cd_w_sync;

n = round(max_time / h);

K_f = [0, 2, 0];
K_b = [0, 10, 0];

X_m = X0_m;
X_s = X0_s;

for i = 1 : round(transient_time / h)
    X_m = fun(X_m, [0 0 0], h, p, [0 0 0]);
    X_s = fun(X_s, [0 0 0], h, p, [0 0 0]);
end

window_n = round(window_time / h);

X_m_array = zeros(n, 3);
X_s_array = zeros(n, 3);
X_m_forward = zeros(window_n, 3);
X_m_backward = zeros(window_n, 3);
X_s_window = zeros(window_n, 3);

buffer_norm = zeros(window_n, 1);
buffer_rms = zeros(1, iterations);
buffer_last_rms = zeros(floor(n / window_n), 1);

hw = waitbar(0, 'Please wait...');

% figure(1)

for k = 0 : window_n : n - window_n
    
    % clf(1)
    
    waitbar((k+1)/n, hw, 'Processing...');

    X_s = X_m + 5;

    for i = 1 : window_n
        X_m_forward(i, :) = X_m;
        X_m_array(k + i, :) = X_m;
        X_m = fun(X_m, [0 0 0], h, p, [0 0 0]);
    end

    X_m_backward = flip(X_m_forward);
    
    for i = 1 : iterations
        %Forward sync
        for j = 1 : window_n - 1
            X_s_array(k + j, :) = X_s;
            buffer_norm(j) = norm(abs(X_s - X_m_forward(j, :)));
            X_s_prev = X_s;
            X_s = fun(X_s_prev, [0 0 0], h, p, [0 0 0]);
            X_s = fun(X_s_prev, X_m_forward(j, :) - X_s, h, p, K_f);
        end
        
        % plot(1 : window_n, E)
        % hold on
        % yscale('log')
        
        %Backward sync
        for j = 1 : window_n - 1
            X_s_array(k + window_n - j, :) = X_s;
            X_s_prev = X_s;
            X_s = fun(X_s_prev, [0 0 0], -h, p, [0 0 0]);
            X_s = fun(X_s_prev, X_m_backward(j, :) - X_s, -h, p, -K_b);
        end
        
        % plot(1 : window_n, E)
        % hold on
        % yscale('log')
        
        buffer_rms(i) = rms(buffer_norm);
    end
    X_s = X_s_array(k + window_n, :);

    buffer_last_rms(k / window_n + 1) = log10(buffer_rms(end)) - log10(buffer_rms(1));
end

close(hw);

E = zeros(n, 1);
for i = 1 : length(X_m_array)
    E(i) = norm(X_m_array(i, :) - X_s_array(i, :));
end


%isnan checking
buffer_last_rms(isnan(buffer_last_rms)) = 1000000;

indices = 1 : window_n : n;

figure
surf([X_s_array(indices,1), X_s_array(indices,1)], [X_s_array(indices,2), X_s_array(indices,2)], [X_s_array(indices,3), X_s_array(indices,3)],...
    [buffer_last_rms(:), buffer_last_rms(:)], 'EdgeColor','flat', 'FaceColor','none',LineWidth=1.5);
zlabel('$z$','interpreter','latex','FontSize',15);
ylabel('$y$','interpreter','latex','FontSize',15);
xlabel('$x$','interpreter','latex','FontSize',15);
colorbar;
% colormap('copper')
colormap([turbo(1000); 1-flip(copper(144));])
caxis([-14 2]);
view(0,0);

% 
% figure
% hold on
% plot3(X_m_array(:,1), X_m_array(:,2), X_m_array(:,3), 'b');
% plot3(X_s_array(:,1), X_s_array(:,2), X_s_array(:,3), 'r');
% xlabel('x1')
% ylabel('x2')
% zlabel('x3')
% grid on

t = 0 : window_time : max_time - window_time;

figure
plot(t, abs(buffer_last_rms))
grid on
yscale('log')
xlabel('time')
ylabel('\Deltalog10(RMS(||Error||))')

t = 0 : h : max_time - h;

figure
plot(t, E)
grid on
yscale('log')
xlabel('time')
ylabel('||Error||')

% 
% t = 0 : h : max_time - h;
% 
% figure
% 
% subplot(3, 3, 1)
% hold on
% plot(t, X_m_array(:, 1), 'b');
% grid on
% title('Master')
% xlabel('time')
% ylabel('x1')
% 
% subplot(3, 3, 4)
% hold on
% plot(t, X_m_array(:, 2), 'b');
% grid on
% xlabel('time')
% ylabel('x2')
% 
% subplot(3, 3, 7)
% hold on
% plot(t, X_m_array(:, 3), 'b');
% grid on
% xlabel('time')
% ylabel('x3')    
% 
% 
% subplot(3, 3, 2)
% hold on
% plot(t, X_s_array(:, 1), 'r');
% grid on
% title('Slave')
% xlabel('time')
% ylabel('x1')
% 
% subplot(3, 3, 5)
% hold on
% plot(t, X_s_array(:, 2), 'r');
% grid on
% xlabel('time')
% ylabel('x2')
% 
% subplot(3, 3, 8)
% hold on
% plot(t, X_s_array(:, 3), 'r');
% grid on
% xlabel('time')
% ylabel('x3')
% 
% 
% subplot(3, 3, 3)
% hold on
% plot(t, X_m_array(:, 1), 'b');
% plot(t, X_s_array(:, 1), 'r');
% title('Master and slave')
% grid on
% xlabel('time')
% ylabel('x1')
% 
% subplot(3, 3, 6)
% hold on
% plot(t, X_m_array(:, 2), 'b');
% plot(t, X_s_array(:, 2), 'r');
% grid on
% xlabel('time')
% ylabel('x2')
% 
% subplot(3, 3, 9)
% hold on
% plot(t, X_m_array(:, 3), 'b');
% plot(t, X_s_array(:, 3), 'r');
% grid on
% xlabel('time')
% ylabel('x3')
