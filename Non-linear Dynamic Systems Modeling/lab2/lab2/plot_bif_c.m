function [] = plot_bif_c(X0, h, max_time)
    n = max_time / h;
    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    funs = {@solve_euler, @solve_midpoint, @solve_cd};
    p_step = 25e-3;
    max_p = 10;
    
    p = 1 : p_step : max_p;
    
    thread_num = 6;
    
    % reference dopri8 calculation
    bif_dopri_arrays = cell(thread_num, 1);
    parfor k = 1 : thread_num
        bif_dopri_array = zeros(1, 2);
        for i = round((k - 1) * length(p) / thread_num) + 1 : k * length(p) / thread_num
            X = solve_dopri8(X0, n, h, a, b, p(i));
            start_index = round(9 * length(X) / 10);
            pks = findpeaks(X(start_index:length(X), 1));
            for j = 1 : length(pks)
                bif_dopri_array(end + 1, :) = [p(i) pks(j)];
            end
        end
        
        bif_dopri_arrays{k} = bif_dopri_array;
    end
    
    peak_count = 0;
    for i = 1 : length(bif_dopri_arrays)
        peak_count = peak_count + size(bif_dopri_arrays{i}, 1);
    end
    
    bif_dopri = zeros(peak_count, 2);
    index = 1;
    for k = 1 : length(bif_dopri_arrays)
        for i = 1 : length(bif_dopri_arrays{k})
            bif_dopri(index, :) = bif_dopri_arrays{k}(i, :);
            index = index + 1;
        end
    end
    
    for m = 1 : length(funs)
        fun = funs{m};
        
        figure
        title('Bifurcation diagram for Ressler system')
        xlabel('c')
        ylabel('Local maximum magnitude')
        hold on
        
        % reference dopri8 plot
        for i = 1 : length(bif_dopri)
            stem(bif_dopri(i, 1), bif_dopri(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'b')
        end
        
        % chosen method calculation
        bif_arrays = cell(thread_num, 1);
        parfor k = 1 : thread_num
            bif_array = zeros(1, 2);
            for i = round((k - 1) * length(p) / thread_num) + 1 : k * length(p) / thread_num
                X = fun(X0, n, h, a, b, p(i));
                start_index = round(9 * length(X) / 10);
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
            for i = 1 : length(bif_arrays{k})
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
end
