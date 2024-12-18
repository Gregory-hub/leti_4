% clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
h = 1e-2;
max_time = 2000;
funs = {@solve_euler, @solve_midpoint, @solve_cd};

num_of_p_points = 10;

a_min = 0;
a_max = 0.37;
a_step = (a_max - a_min) / (num_of_p_points - 1);

b_min = 0;
b_max = 2;
b_step = (b_max - b_min) / (num_of_p_points - 1);

c_min = 1;
c_max = 10;
c_step = (c_max - c_min) / (num_of_p_points - 1);

min_h_pow = -4;
max_h_pow = -1;
h_pow_step = (max_h_pow - min_h_pow) / (num_of_p_points - 1);

h_pow = min_h_pow : h_pow_step : max_h_pow;
h_array = 10.^h_pow;

a_array = a_min : a_step : a_max;
b_array = b_min : b_step : b_max;
c_array = c_min : c_step : c_max;

for m = 1 : length(funs)
    fun = funs{m};
    SE = zeros(length(a_array), length(c_array));
    for i = 1 : length(a_array)
        for j = 1 : length(c_array)
            n = max_time / h;
            X = fun(x, n, h, a_array(i), b, c_array(j));
            se = find_spectral_entropy(X(floor(9 * length(X) / 10) : end, 1));
            SE(i,j) = se;
        end
    end
    
    figure
    s = pcolor(a_array, c_array, SE');
    xlabel('a')
    ylabel('c')
    title('Spectral Entropy')
    s.EdgeColor = 'none';
    colormap('bone')
end
