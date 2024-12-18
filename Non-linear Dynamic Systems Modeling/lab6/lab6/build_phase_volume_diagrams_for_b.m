function [] = build_phase_volume_diagrams_for_b(h, max_time, num_of_p_points)
    label = 'b';

    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    X0 = [0 0 0];
    n = max_time / h;
    funs = { @solve_euler, @solve_midpoint, @solve_cd, @solve_dopri8 };
    
    b_min = 0;
    b_max = 2;
    b_step = (b_max - b_min) / (num_of_p_points - 1);
    b_array = b_min : b_step : b_max;
    
    figures = cell(length(funs), 1);
    funs_runtime = zeros(length(funs), 1);
    
    for m = 1 : length(funs)
        disp('Running method at index ' + string(m) + '...');
        fun = funs{m};
        
        tic
        
        V = zeros(size(b_array));
        for i = 1 : length(b_array)
            Y = fun(X0, n, h, a, b_array(i), c);
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
        plot(b_array, V)
        grid on
        
        figures{m} = gcf;
    end
    
    saveas(figures{1}, 'phase_volume_euler_b.png')
    saveas(figures{2}, 'phase_volume_midpoint_b.png')
    saveas(figures{3}, 'phase_volume_cd_b.png')
    saveas(figures{4}, 'phase_volume_dopri8_b.png')
    
    disp('Euler phase volume calculation time: ' + string(funs_runtime(1)))
    disp('Midpoint phase volume calculation time: ' + string(funs_runtime(2)))
    disp('CD phase volume calculation time: ' + string(funs_runtime(3)))
    disp('Dopri8 phase volume calculation time: ' + string(funs_runtime(4)))
end
