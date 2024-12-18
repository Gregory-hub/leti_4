function [] = run_long_term_modeling()
    a = 0.2;
    b = 0.2;
    c = 5.7;
    
    X = [0 0 0];
    h_for_funs = [1e-5, 1e-5, 1e-5, 1e-4];
    max_time = 100000;      % should run for approximately 2.5 hours
    num_of_points_to_plot = 10000;
    time_period = max_time / num_of_points_to_plot;
    funs = { @solve_euler, @solve_midpoint, @solve_cd, @solve_dopri8 };
    
    period_num = floor(max_time / time_period);
    
    figures = cell(length(funs), 1);
    funs_runtime = zeros(length(funs), 1);
    
    clock = tic;
    for m = 1 : length(funs)
        disp('Running method at index ' + string(m) + '...');
        fun = funs{m};
        h = h_for_funs(m);
        n = floor(time_period / h);
        
        tic
        
        X_array = zeros(period_num, 3);
        for i = 1 : period_num
            Y = fun(X, n, h, a, b, c);
            X = Y(end, :);
            X_array(i, :) = X;
        end
        
        funs_runtime(m) = toc;
        
        t = 0 : time_period : max_time - time_period;
        
        figure
        
        subplot(3, 1, 1)
        plot(t, X_array(:, 1), 'r');
        xlabel('time')
        ylabel('x1')
        grid on
        
        subplot(3, 1, 2)
        plot(t, X_array(:, 2), 'b');
        xlabel('time')
        ylabel('x2')
        grid on
        
        subplot(3, 1, 3)
        plot(t, X_array(:, 3), 'g');
        xlabel('time')
        ylabel('x3')
        grid on
        
        figures{m} = gcf;
    end
    time_taken = toc(clock);

    saveas(figures{1}, 'long_term_modeling_euler.png')
    saveas(figures{2}, 'long_term_modeling_midpoint.png')
    saveas(figures{3}, 'long_term_modeling_cd.png')
    saveas(figures{4}, 'long_term_modeling_dopri8.png')
    
    disp('Euler calculation time: ' + string(funs_runtime(1)))
    disp('Midpoint calculation time: ' + string(funs_runtime(2)))
    disp('CD calculation time: ' + string(funs_runtime(3)))
    disp('Dopri8 calculation time: ' + string(funs_runtime(4)))

    disp('Time taken to run modeling with all methods: ' + string(time_taken))
end
