function [] = build_phase_volume_diagrams_for_h(max_time, num_of_p_points)
    label = 'h';
    
    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    X0 = [0 0 0];
    funs = { @solve_euler, @solve_midpoint, @solve_cd, @solve_dopri8 };
    
    min_h_pow = -3;
    max_h_pow = -1;
    h_pow_step = (max_h_pow - min_h_pow) / (num_of_p_points - 1);
    
    h_pow_array = min_h_pow : h_pow_step : max_h_pow;
    h_array = 10.^h_pow_array;
    
    figures = cell(length(funs), 1);
    funs_runtime = zeros(length(funs), 1);
    
    for m = 1 : length(funs)
        disp('Running method at index ' + string(m) + '...');
        fun = funs{m};
        
        tic
        
        V = zeros(size(h_array));
        for i = 1 : length(h_array)
            n = round(max_time / h_array(i));
            Y = fun(X0, n, h_array(i), a, b, c);
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
        xscale log
        plot(h_array, V)
        grid on
        
        figures{m} = gcf;
    end
    
    saveas(figures{1}, 'phase_volume_euler_h.png')
    saveas(figures{2}, 'phase_volume_midpoint_h.png')
    saveas(figures{3}, 'phase_volume_cd_h.png')
    saveas(figures{4}, 'phase_volume_dopri8_h.png')
    
    disp('Euler phase volume calculation time: ' + string(funs_runtime(1)))
    disp('Midpoint phase volume calculation time: ' + string(funs_runtime(2)))
    disp('CD phase volume calculation time: ' + string(funs_runtime(3)))
    disp('Dopri8 phase volume calculation time: ' + string(funs_runtime(4)))
end
