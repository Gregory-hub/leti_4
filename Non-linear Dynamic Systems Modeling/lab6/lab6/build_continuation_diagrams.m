function [] = build_continuation_diagrams()
    h = 1e-2;
    % time_interval = 2000;
    % num_of_p_points = 1000;
    time_interval = 2000;
    num_of_p_points = 1000;
    
    clock = tic;
    disp('------------------------------------------------')
    disp('Building continuation diagrams for parameter a...')
    build_continuation_diagrams_for_a(h, time_interval, num_of_p_points);
    
    disp('------------------------------------------------')
    disp('Building continuation diagrams fo parameterr b...')
    build_continuation_diagrams_for_b(h, time_interval, num_of_p_points);

    disp('------------------------------------------------')
    disp('Building continuation diagrams for parameter c...')
    build_continuation_diagrams_for_c(h, time_interval, num_of_p_points);
    
    time_taken = toc(clock);
    disp('------------------------------------------------')
    disp('Time taken to build all continuation diagrams: ' + string(time_taken))
end
