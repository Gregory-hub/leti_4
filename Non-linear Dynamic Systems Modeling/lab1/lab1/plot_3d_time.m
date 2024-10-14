function [] = plot_3d_time(h, X)
    t = 0 : h : (length(X) - 1) * h;

    figure
    plot(t, X(:, 1), 'r', t, X(:, 2), 'b', t, X(:, 3), 'g');
    legend('x1', 'x2', 'x3')
    grid on
    xlabel('time')
    ylabel('x')

    figure

    subplot(3, 1, 1)
    plot(t, X(:, 1), 'r');
    grid on
    xlabel('time')
    ylabel('x1')

    subplot(3, 1, 2)
    plot(t, X(:, 2), 'b');
    grid on
    xlabel('time')
    ylabel('x2')

    subplot(3, 1, 3)
    plot(t, X(:, 3), 'g');
    grid on
    xlabel('time')
    ylabel('x3')
end
