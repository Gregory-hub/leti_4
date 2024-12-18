function [] = build_phase_volume_diagrams_for_c(h, max_time, num_of_p_points)
    label = 'c';

    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    X0 = [0 0 0];
    n = max_time / h;
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
        
        tic
        
        V = zeros(size(c_array));
        for i = 1 : length(c_array)
            Y = fun(X0, n, h, a, b, c_array(i));
            start_index = round(5 * length(Y) / 10);
            Y = Y(start_index:length(Y), :);
            sides = [max(Y(:,1)) - min(Y(:,1)), max(Y(:,2)) - min(Y(:,2)), max(Y(:,3)) - min(Y(:,3))];
            V(i) = sides(1) * sides(2) * sides(3);
        end
        
        funs_runtime(m) = toc;
        
        figure
        xlabel(label)
        ylabel('Phase volume')
        hold on
        plot(c_array, V)
        grid on
        
        figures{m} = gcf;
    end
    
    saveas(figures{1}, 'phase_volume_euler_c.png')
    saveas(figures{2}, 'phase_volume_midpoint_c.png')
    saveas(figures{3}, 'phase_volume_cd_c.png')
    saveas(figures{4}, 'phase_volume_dopri8_c.png')
    
    disp('Euler phase volume calculation time: ' + string(funs_runtime(1)))
    disp('Midpoint phase volume calculation time: ' + string(funs_runtime(2)))
    disp('CD phase volume calculation time: ' + string(funs_runtime(3)))
    disp('Dopri8 phase volume calculation time: ' + string(funs_runtime(4)))
end
