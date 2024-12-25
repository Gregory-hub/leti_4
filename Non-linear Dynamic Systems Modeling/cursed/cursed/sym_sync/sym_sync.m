clear; clc;

TT = 10;               % Transient time
CT = 3;                % Computation time
WT = 1;                 % Window time

h = 0.01;               % Integration step time
a = [0.2 0.2 5.7]';     % parameters

% method = @solve_cd_w_sync;
method = @solve_imp_w_sync;

Kforward = [0 2 0]';    % Synchronization coefficients for forward synchronization
Kbackward = [0 10 0]';  % Synchronization coefficients for backward synchronization

X = [0 0 0]';           % Initial conditions for master system
X1 = [3 -3 0]';         % Initial conditions for slave system
itrs = 100;             % Amount of synchronization iterations
y = 100;                  % Final array decimation coefficient

% Transient time calculation
for i = 1:ceil(TT/h)
    X = method(X, [0 0 0]', h, a, [0 0 0]);
    X1 = method(X1, [0 0 0]', h, a, [0 0 0]);
end

X1_start = X1;
Xwrite = zeros(3, ceil(CT/h/y));

% Time domain calculation
m = 0;
for i = 1:ceil(CT/h)
    X = method(X, [0 0 0]', h, a, [0 0 0]);
    if mod(i, y) == 0
        m = m + 1;
        Xwrite(:, m)= X;
    end
end

% Initialization of helpfull arrays for calculation
WT_forward = zeros(3, ceil(WT/h));
buffer_norm = zeros(1, ceil(WT/h)-1);
buffer_rms = zeros(1, itrs);
buffer_last_rms = zeros(1, ceil(CT/h/y));
WT_iter = ceil(WT/h);


hw = waitbar(0,'Please wait...');

% Calculation of Forward-Backward synchronization for every y point in time domain
for k = 1:m
    waitbar(k/m,hw,'Processing...');
    
    X = Xwrite(:,k);
    %X1 = X1_start;
    X1 = X + 5;
    % Window array calculation
    for i = 1:WT_iter
        WT_forward(:,i) = X;
        X = method(X, [0 0 0]', h, a, [0 0 0]);    
    end
    
    % Formatting window array for backward synchronization
    WT_backward = flip(WT_forward');
    WT_backward = WT_backward';

    %rms_error = log10(err1) - log10(err0);

    for i = 1:itrs
        %Forward synch
        for j = 1:(ceil(WT/h)-1)
            buffer_norm(j) = norm(abs(X1-WT_forward(:,j)));
            X1 = method(X1, WT_forward(:,j), h, a, Kforward);
        end
        %Backward synch
        for j = 1:(ceil(WT/h)-1)
            X1 = method(X1, WT_backward(:,j), -h, a, -Kbackward);            
        end

        buffer_rms(i) = rms(buffer_norm);

    end
    buffer_last_rms(k) = log10(buffer_rms(end)) - log10(buffer_rms(1));
end
close(hw);

%isnan checking
buffer_last_rms(isnan(buffer_last_rms)) = 1000000;

figure
surf([Xwrite(1,:)', Xwrite(1,:)'], [Xwrite(2,:)', Xwrite(2,:)'], [Xwrite(3,:)', Xwrite(3,:)'],...
    [buffer_last_rms(1,:)',buffer_last_rms(1,:)'],'EdgeColor','flat', 'FaceColor','none',LineWidth=1.5)
zlabel('z')
ylabel('y')
xlabel('x')
cb = colorbar();
ylabel(cb,'log10(RMS(||Error||))', 'FontSize', 12, 'Rotation', 90)
colormap([turbo(1000); 1-flip(copper(144));])
caxis([-14 2])
view(50, 30)






