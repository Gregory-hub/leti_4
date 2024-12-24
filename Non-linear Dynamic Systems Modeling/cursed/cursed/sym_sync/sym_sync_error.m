clear; clc;

TT = 100;               % Transient time
CT = 100;                % Computation time
WT = 1;                 % Window time

h = 0.01;               % Integration step time
a = [0.2 0.2 5.7]';     % parameters

method = @solve_cd_w_sync;

Kforward = [0 2 0]';    % Synchronization coefficients for forward synchronization
Kbackward = [0 10 0]';  % Synchronization coefficients for backward synchronization

X = [0 0 0]';           % Initial conditions for master system
X1 = [3 -3 0]';         % Initial conditions for slave system
itrs = 400;             % Amount of synchronization iterations
y = 100;                % Final array decimation coefficient


% Transient time calculation
for i = 1:ceil(TT/h)
    X = method(X, [0 0 0], h, a, [0 0 0]);
    X1 = method(X1, [0 0 0], h, a, [0 0 0]);
end

E0 = norm(abs(X1 - X));

E0_log = log10(E0);

X1_start = X1;
X_start = X;
Xwrite = zeros(3, ceil(CT/h/y));

% Time domain calculation
m = 0;
for i = 1:ceil(CT/h)
    X = method(X, [0 0 0], h, a, [0 0 0]);
    if mod(i, y) == 0
        m = m + 1;
        Xwrite(:, m)= X;
    end
end

% Initialization of helpfull arrays for calculation

Err(1) = norm(abs(X1_start - X));
last_k = Inf;

WT_forward = zeros(3, ceil(WT/h));
buffer_norm = zeros(1, ceil(WT/h)-1);
buffer_rms = zeros(1, itrs);
buffer_last_rms = zeros(1, ceil(CT/h/y) + 1);
buffer_last_err = zeros(1, ceil(CT/h/y) + 1);
WT_iter = ceil(WT/h);

buffer_last_rms(1) = E0_log;
buffer_last_err(1) = E0;

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
        X = method(X, [0 0 0], h, a, [0 0 0]);    
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

    R_log = log10(buffer_rms(end)) - log10(buffer_rms(1)); 
    buffer_last_rms(k + 1) = log10(buffer_rms(end)) - log10(buffer_rms(1));
    buffer_last_err(k + 1) = buffer_rms(end);

    Err = [Err, buffer_norm];

    if(R_log <= -16)
        last_k = k;
        break
    end
end

close(hw);

t = (0 : (min(m, last_k) - 1) * ceil(WT/h)) * h;

figure
plot(t, Err)
yscale('log')
xlabel('time')
ylabel('||Error||')
grid on

%isnan checking
buffer_last_rms(isnan(buffer_last_rms)) = 1000000;
