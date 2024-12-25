clear

a = 0.2;
b = 0.2;
c = 5.7;

X0_master = [0 0 0];
X0_slave = [1 2 3];
h = 1e-2;
max_time = 100;
% fun = @solve_imp;
fun = @solve_cd;

n = round(max_time / h);

k_array = 0 : 0.1 : 6;

% f_sync_time = @(k) find_sync_error_stabilization_time(X0_master, X0_slave, h, n, fun, [k 0 0], a, b, c, 1e-12);

% figure
% subplot(2, 1, 1)
% plot(k_array, arrayfun(f_sync_time, k_array));
% title('K = [k 0 0]')
% xlabel('k')
% ylabel('Sync time, s')
% grid on
% 
% f_sync_time = @(k) find_sync_error_stabilization_time(X0_master, X0_slave, h, n, fun, [0 k 0], a, b, c, 1e-12);
% 
% subplot(2, 1, 2)
% plot(k_array, arrayfun(f_sync_time, k_array));
% title('K = [0 k 0]')
% xlabel('k')
% ylabel('Sync time, s')
% grid on
% 
% f_sync_time = @(k) find_sync_error_stabilization_time(X0_master, X0_slave, h, n, fun, [0 0 k], a, b, c, 1e-12);
% 
% figure
% plot(k_array, arrayfun(f_sync_time, k_array));
% title('K = [0 0 k]')
% xlabel('k')
% ylabel('Sync time, s')
% grid on

f_sync_time = @(k) find_sync_error_stabilization_time(X0_master, X0_slave, h, n, fun, [0 k 0], a, b, c, 1e-12);
K_array = 1.9 : 1e-2 : 2.1;
E_array = arrayfun(f_sync_time, K_array);
[E, K] = findpeaks(-E_array);
[E, E_i] = min(-E);
K = K_array(K(E_i));
K, E

