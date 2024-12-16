% clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
h = 1e-2;
max_time = 3000;
solve = @solve_cd;

n = max_time / h;

num_of_p_points = 100;

a_min = 0;
a_max = 0.37;
a_step = (a_max - a_min) / (num_of_p_points - 1);

b_min = 0;
b_max = 2;
b_step = (b_max - b_min) / (num_of_p_points - 1);

c_min = 1;
c_max = 10;
c_step = (c_max - c_min) / (num_of_p_points - 1);

a_array = a_min : a_step : a_max;
b_array = b_min : b_step : b_max;
c_array = c_min : c_step : c_max;

SE = zeros(length(a_array), length(b_array));
for i = 1 : length(a_array)
    for j = 1 : length(b_array)
        X = solve(x, n, h, a_array(i), b_array(j), c);
        se = find_spectral_entropy(X(floor(9 * length(X) / 10) : end, 1));
        SE(i,j) = se;
    end
end

s = pcolor(a_array, b_array, SE');
s.EdgeColor = 'none';
colormap('bone')
