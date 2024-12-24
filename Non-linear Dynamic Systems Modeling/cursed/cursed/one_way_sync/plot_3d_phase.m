function [] = plot_3d_phase(X, special_points)
    figure
    
    subplot(2, 2, 1)
    plot(X(:,1), X(:,2))
    hold on
    for i = 1 : size(special_points, 1)
        stem(special_points(i, 1), special_points(i, 2), "filled", 'LineStyle', 'none', 'MarkerSize', 3)
    end
    xlabel('x1')
    ylabel('x2')
    grid on
    
    subplot(2, 2, 2)
    plot(X(:,2), X(:,3))
    hold on
    for i = 1 : size(special_points, 1)
        stem(special_points(i, 2), special_points(i, 3), "filled", 'LineStyle', 'none', 'MarkerSize', 3)
    end
    xlabel('x2')
    ylabel('x3')
    grid on
    
    subplot(2, 2, 3)
    plot(X(:,3), X(:,1))
    hold on
    for i = 1 : size(special_points, 1)
        stem(special_points(i, 3), special_points(i, 1), "filled", 'LineStyle', 'none', 'MarkerSize', 3)
    end
    xlabel('x3')
    ylabel('x1')
    grid on
    
    subplot(2, 2, 4)
    plot3(X(:,1), X(:,2), X(:,3))
    hold on
    for i = 1 : size(special_points, 1)
        stem3(special_points(i, 1), special_points(i, 2), special_points(i, 3), "filled", 'LineStyle', 'none', 'MarkerSize', 3)
    end
    xlabel('x1')
    ylabel('x2')
    zlabel('x3')
    grid on
end
