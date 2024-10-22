function [] = compare_to_dopri(Y, X0, n, h)
    Y_dopri = solve_dopri8(X0, n, h);
    Y_diff = Y - Y_dopri;
    plot_3d_phase(Y_diff);
end