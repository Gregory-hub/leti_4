clear

a = 0.2;
b = 0.2;
c = 5.7;

x = [0 0 0];
eps = 1e-8;
h = 1e-2;
max_time = 2000;
interval_time = 0.5;
funs = { @solve_euler, @solve_midpoint, @solve_cd };

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

min_h_pow = -4;
max_h_pow = -1;
h_pow_step = (max_h_pow - min_h_pow) / (num_of_p_points - 1);

h_pow = min_h_pow : h_pow_step : max_h_pow;
h_array = 10.^h_pow;

a_array = a_min : a_step : a_max;
b_array = b_min : b_step : b_max;
c_array = c_min : c_step : c_max;


% figures = cell(length(funs), 1);
% 
% for m = 1 : length(funs)
%     fun = funs{m};
% 
%     LLE = zeros(length(a_array), length(b_array));
%     for i = 1 : length(a_array)
%         for j = 1 : length(b_array)
%             lle = find_lle(h, x, max_time, interval_time, eps, fun, a_array(i), b_array(j), c);
%             LLE(i,j) = lle;
%         end
%     end
% 
%     figure
%     s = pcolor(a_array, b_array, LLE');
%     xlabel('a')
%     ylabel('b')
%     title('LLE')
%     s.EdgeColor = 'none';
%     colormap('bone')
% 
%     figures{m} = gcf;
% end

% saveas(figures{1}, 'lle_euler_ab.png')
% saveas(figures{2}, 'lle_midpoint_ab.png')
% saveas(figures{3}, 'lle_cd_ab.png')


figures = cell(length(funs), 1);

for m = 1 : length(funs)
    fun = funs{m};
    
    LLE = zeros(length(a_array), length(c_array));
    for i = 1 : length(a_array)
        for j = 1 : length(c_array)
            lle = find_lle(h, x, max_time, interval_time, eps, fun, a_array(i), b, c_array(j));
            LLE(i,j) = lle;
        end
    end
    
    figure
    s = pcolor(a_array, c_array, LLE');
    xlabel('a')
    ylabel('c')
    title('LLE')
    s.EdgeColor = 'none';
    colormap('bone')

    figures{m} = gcf;
end

saveas(figures{1}, 'lle_euler_ac.png')
saveas(figures{2}, 'lle_midpoint_ac.png')
saveas(figures{3}, 'lle_cd_ac.png')


figures = cell(length(funs), 1);

for m = 1 : length(funs)
    fun = funs{m};
    
    LLE = zeros(length(a_array), length(h_array));
    for i = 1 : length(a_array)
        for j = 1 : length(h_array)
            lle = find_lle(h_array(j), x, max_time, interval_time, eps, fun, a_array(i), b, c);
            LLE(i,j) = lle;
        end
    end
    
    figure
    s = pcolor(a_array, h_array, LLE');
    xlabel('a')
    ylabel('h')
    title('LLE')
    s.EdgeColor = 'none';
    colormap('bone')
    
    figures{m} = gcf;
end

saveas(figures{1}, 'lle_euler_ah.png')
saveas(figures{2}, 'lle_midpoint_ah.png')
saveas(figures{3}, 'lle_cd_ah.png')
