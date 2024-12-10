clear

a = 0.2;
b = 0.2;
c = 5.7;

X0 = [0 0 0];
max_time = 3000;

funs = {@solve_euler, @solve_midpoint, @solve_cd};
min_p_pow = -4;
max_p_pow = -1;
p_pow_step = 5e-2;
 
p_pow = min_p_pow : p_pow_step : max_p_pow;
p = 10.^p_pow;

thread_num = 6;

indices = zeros(thread_num, 1);
for i = 1 : length(indices)
    indices(i) = floor(length(p) / 10^(thread_num - i + 1)) + 1;
    if (i > 1 && indices(i) <= indices(i - 1))
        indices(i) = indices(i - 1) + 1;
    end
end

% reference dopri8 calculation
% bif_dopri_arrays = cell(thread_num, 1);
% parfor k = 1 : thread_num
%     bif_dopri_array = zeros(1, 2);
%     if (k < thread_num)
%         index_last = indices(k + 1);
%     else
%         index_last = length(p);
%     end
% 
%     for i = indices(k) : index_last
%         n = round(max_time / p(i));
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

for m = 3 : 3
    fun = funs{m};
    
    figure
    title('Bifurcation diagram for Ressler system')
    xlabel('h')
    ylabel('Local maximum magnitude')
    xscale log
    hold on
    
    % reference dopri8 plot
    % for i = 1 : length(bif_dopri)
    %     stem(bif_dopri(i, 1), bif_dopri(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'b')
    % end
    
    % chosen method calculation
    bif_arrays = cell(thread_num, 1);
    parfor k = 1 : thread_num
        bif_array = zeros(1, 2);
        if (k < thread_num)
            index_last = indices(k + 1);
        else
            index_last = length(p);
        end
        
        for i = indices(k) : index_last
            n = round(max_time / p(i));
            X = fun(X0, n, p(i), a, b, c);
            start_index = round(1 * length(X) / 10);
            pks = findpeaks(X(start_index:length(X), 1));
            for j = 1 : length(pks)
                bif_array(end + 1, :) = [p(i) pks(j)];
            end
        end
        
        bif_arrays{k} = bif_array;
    end
    
    peak_count = 0;
    for i = 1 : length(bif_arrays)
        peak_count = peak_count + size(bif_arrays{i}, 1);
    end
    
    bif = zeros(peak_count, 2);
    index = 1;
    for k = 1 : length(bif_arrays)
        for i = 1 : size(bif_arrays{k}, 1)
            bif(index, :) = bif_arrays{k}(i, :);
            index = index + 1;
        end
    end
    
    % chosen method plot
    for i = 1 : length(bif)
        stem(bif(i, 1), bif(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'r')
    end
    
    grid on
end
