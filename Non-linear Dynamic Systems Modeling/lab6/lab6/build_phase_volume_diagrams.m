function [] = build_phase_volume_diagrams()
    h = 1e-2;
    % max_time = 2000;
    % num_of_p_points = 1000;
    max_time = 2000;
    num_of_p_points = 1000;
    
    clock = tic;
    disp('------------------------------------------------')
    disp('Building phase volume diagrams for parameter a...')
    build_phase_volume_diagrams_for_a(h, max_time, num_of_p_points);

    disp('------------------------------------------------')
    disp('Building phase volume diagrams fo parameterr b...')
    build_phase_volume_diagrams_for_b(h, max_time, num_of_p_points);

    disp('------------------------------------------------')
    disp('Building phase volume diagrams for parameter c...')
    build_phase_volume_diagrams_for_c(h, max_time, num_of_p_points);
    
    disp('------------------------------------------------')
    disp('Building phase volume diagrams for parameter h...')
    build_phase_volume_diagrams_for_h(max_time, num_of_p_points);

    time_taken = toc(clock);
    disp('------------------------------------------------')
    disp('Time taken to build all phase volume diagrams: ' + string(time_taken))
end
