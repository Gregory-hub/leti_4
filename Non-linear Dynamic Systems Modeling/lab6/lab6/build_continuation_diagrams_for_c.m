function [] = build_continuation_diagrams_for_c(h, time_interval, num_of_p_points)
    label = 'c';
    
    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    X0 = [0 0 0];
    
    n = time_interval / h;
    
    funs = { @solve_euler, @solve_midpoint, @solve_cd, @solve_dopri8 };
    
    c_min = 1;
    c_max = 10;
    c_step = (c_max - c_min) / (num_of_p_points - 1);
    c_array = c_min : c_step : c_max;

    figures = cell(length(funs), 1);
    funs_runtime = zeros(length(funs), 1);
    
    for m = 1 : length(funs)
        disp('Running method at index ' + string(m) + '...');
        fun = funs{m};
        X = X0;
        
        tic
        
        bif = zeros(1, 2);
        for i = 1 : length(c_array)
            Y = fun(X, n, h, a, b, c_array(i));
            X = Y(end,:);
            start_index = round(9 * length(Y) / 10);
            pks = findpeaks(Y(start_index:length(Y), 1));
            for j = 1 : length(pks)
                bif(end + 1,:) = [c_array(i) pks(j)];
            end
        end
        funs_runtime(m) = toc;
        
        figure
        xlabel(label)
        hold on
        
        for i = 1 : length(bif)
            stem(bif(i, 1), bif(i, 2), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 3, 'Color', 'r')
        end
        grid on

        figures{m} = gcf;
    end
    
    saveas(figures{1}, 'continuation_diagram_euler_c.png')
    saveas(figures{2}, 'continuation_diagram_midpoint_c.png')
    saveas(figures{3}, 'continuation_diagram_cd_c.png')
    saveas(figures{4}, 'continuation_diagram_dopri8_c.png')
    
    disp('Euler calculation time: ' + string(funs_runtime(1)))
    disp('Midpoint calculation time: ' + string(funs_runtime(2)))
    disp('CD calculation time: ' + string(funs_runtime(3)))
    disp('Dopri8 calculation time: ' + string(funs_runtime(4)))
end
