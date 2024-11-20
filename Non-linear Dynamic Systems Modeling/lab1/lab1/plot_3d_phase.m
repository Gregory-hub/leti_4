function [] = plot_3d_phase(X)
    figure
    
    % subplot(2, 2, 1)
    % plot(X(:,1), X(:,2));
    % xlabel('x1')
    % ylabel('x2')
    % grid on
    % 
    % subplot(2, 2, 2)
    % plot(X(:,2), X(:,3));
    % xlabel('x2')
    % ylabel('x3')
    % grid on
    % 
    % subplot(2, 2, 3)
    % plot(X(:,3), X(:,1));
    % xlabel('x3')
    % ylabel('x1')
    % grid on
    % 
    % subplot(2, 2, 4)
    plot3(X(:,1), X(:,2), X(:,3));
    xlabel('x1')
    ylabel('x2')
    zlabel('x3')
    grid on
end
