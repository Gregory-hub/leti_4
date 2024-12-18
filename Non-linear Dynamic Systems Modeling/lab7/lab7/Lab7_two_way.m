clear; clc;
close all;


% Лучший вариант

t = 200;

h = 0.01;

XM_0 = [0.98, 1.9, 0.98, -0.98]; % Начальные значения ПС для Master системы

a = [5.8, 3.7, 2, 0.9, 1, 1.5]; % Параметры системы

XS_0 = [10, 1.9 0.98 -0.98]; % Начальные значения ПС Slave системы

XM = XM_0;
XS = XS_0;

N1 = zeros(1, 4);
K1 = [0, 5, 5, 0];

N2 = zeros(1, 4);
K2 = [0, 5, 0, 5];

str1 = join(num2str(K1), ',');
str2 = join(num2str(K2), ',');

str_M = join(num2str(XM_0), ',');
str_S = join(num2str(XS_0), ',');

Col = t/h;

fig = uifigure;
d = uiprogressdlg(fig, 'Title', 'One-way synchronization', 'Message', 'Calculating', 'Cancelable','on');

t_pred = 0;
E_pred = 0;

q = 1;

for i = 1:Col
    N1(1) = K1(1) * (XM(1) - XS(1));
    N1(2) = K1(2) * (XM(2) - XS(2));
    N1(3) = K1(3) * (XM(3) - XS(3));
    N1(4) = K1(4) * (XM(4) - XS(4));

    N2(1) = K2(1) * (XS(1) - XM(1));
    N2(2) = K2(2) * (XS(2) - XM(2));
    N2(3) = K2(3) * (XS(3) - XM(3));
    N2(4) = K2(4) * (XS(4) - XM(4));

    XM = MyCD(XM, h, a);
    XS = MyCD(XS, h, a);

    for j = 1:4
        XS(j) = XS(j) + h * N1(j);
        XM(j) = XM(j) + h * N2(j);
    end

    E(q) = Mynorma(XM - XS);

    PS_M_X(q) = XM(1);
    PS_M_Y(q) = XM(2);

    PS_S_X(q) = XS(1);
    PS_S_Y(q) = XS(2);

    progress = i/Col;
    pr = progress * 100;
    
    d.Value = progress;
    d.Message = ['Calculating for parametr value: ' num2str(pr) '%'];
    pause(0.001);
    q = q + 1;

end

t_c = h:h:t;

close(fig);

figure;
plot (t_c, E, 'b-');
set(gca, 'YScale', 'Log');
title(['Error of two-way synchronization, CD, K1 = [' str1 '], K2 = [' str2 ']']);
xlabel('t');
ylabel('error')

name1 = ['Графики\Lab7\Двусторонняя\Ошибка двусторонней синхронизации систем, моделируемых методом CD, Master NU = (' str_M '), Slave NU = (' str_S '), K1 = (' str1 '), K2 = (' str2 ').png'];
name2 = ['Figures\Lab7\Двусторонняя\Error of one-way synchronization, CD, Master NU = (' str_M '), Slave NU = (' str_S '), K1 = (' str1 '), K2 = (' str2 ').fig'];
saveas(gcf, name1);
saveas(gcf, name2);

figure;
plot(PS_M_X, PS_M_Y, 'b-', 'LineWidth', 2);
hold on
plot(PS_S_X, PS_S_Y, 'r-', 'LineWidth', 1);
title('Phase portrets XY');
xlabel('x');
ylabel('y');
legend('Master', 'Slave');

name1 = 'Графики\Lab7\Двусторонняя\Фазовые портреты синхронизируемых систем.png';
name2 = 'Figures\Lab7\Двусторонняя\Phase portraits of synchronized systems.fig';
saveas(gcf, name1);
saveas(gcf, name2);