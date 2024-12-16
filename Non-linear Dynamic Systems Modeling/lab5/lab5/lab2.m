% clear

a = 0.2;
b = 0.2;
c = 5.7;

X0 = [0 0 0];
h = 1e-2;
max_time = 3000;

n = max_time / h;

fun = @solve_euler;

p_step = 25e-3;
max_p = 10;

p = 1 : p_step : max_p;

thread_num = 6;

% figure
% title('Bifurcation diagram for Ressler system')
% xlabel('c')
% ylabel('Local maximum magnitude')
% hold on

tic
% % reference dopri8 calculation
% bif_dopri_arrays = cell(thread_num, 1);
% parfor k = 1 : thread_num
%     bif_dopri_array = zeros(1, 2);
%     for i = round((k - 1) * length(p) / thread_num) + 1 : k * length(p) / thread_num
%         X = solve_dopri8(X0, n, p(i), a, b, c);
%         start_index = round(9 * length(X) / 10);
%         pks = findpeaks(X(start_index:length(X), 1));
%         for j = 1 : length(pks)
%             bif_dopri_array(end + 1, :) = [p(i) pks(j)];
%         end
%     end
% 
%     bif_dopri_arrays{k} = bif_dopri_array;
% end
% 
% peak_count = 0;
% for i = 1 : length(bif_dopri_arrays)
%     peak_count = peak_count + size(bif_dopri_arrays{i}, 1);
% end
% 
% bif_dopri = zeros(peak_count, 2);
% index = 1;
% for k = 1 : length(bif_dopri_arrays)
%     for i = 1 : length(bif_dopri_arrays{k})
%         bif_dopri(index, :) = bif_dopri_arrays{k}(i, :);
%         index = index + 1;
%     end
% end

time_dopri_calc = toc;

tic
% % reference dopri8 plot
% for i = 1 : length(bif_dopri)
%     stem(bif_dopri(i, 1), bif_dopri(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'b')
% end

time_dopri_plot = toc;


tic
% chosen method calculation
% bif_arrays = cell(thread_num, 1);
% parfor k = 1 : thread_num
%     bif_array = zeros(1, 2);
%     for i = round((k - 1) * length(p) / thread_num) + 1 : k * length(p) / thread_num
%         X = fun(X0, n, h, a, b, p(i));
%         start_index = round(9 * length(X) / 10);
%         pks = findpeaks(X(start_index:length(X), 1));
%         for j = 1 : length(pks)
%             bif_array(end + 1, :) = [p(i) pks(j)];
%         end
%     end
% 
%     bif_arrays{k} = bif_array;
% end
% 
% peak_count = 0;
% for i = 1 : length(bif_arrays)
%     peak_count = peak_count + size(bif_arrays{i}, 1);
% end
% 
% bif = zeros(peak_count, 2);
% index = 1;
% for k = 1 : length(bif_arrays)
%     for i = 1 : length(bif_arrays{k})
%         bif(index, :) = bif_arrays{k}(i, :);
%         index = index + 1;
%     end
% end

time_method_calc = toc;

tic
% chosen method plot
% for i = 1 : length(bif)
%     stem(bif(i, 1), bif(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'r')
% end

time_method_plot = toc;

% grid on

% X = fun(X0, n, h, 0.001, b, c);
% plot_3d_time(h, X);
% plot_3d_phase(X);

% disp('Dopri8 calculation time: ' + string(time_dopri_calc))
% disp('Dopri8 plot time: ' + string(time_dopri_plot))
% disp('Method calculation time: ' + string(time_method_calc))
% disp('Method plot time: ' + string(time_method_plot))

% % % plot_bif_c(X0, h, max_time);
plot_bif_h(X0, max_time * 10);
