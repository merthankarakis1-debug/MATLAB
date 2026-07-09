clear
clc
close all

t = 0:0.01:10;
d = 0.5;

y = gedampfterSinus(t, d);

[maximum, zeit_max] = analyseSignal(t, y);

figure
plot(t, y, 'LineWidth', 3.0)
grid on
xlabel('Zeit [s]')
ylabel('Amplitude')
title('Gedämpfter Sinus')

hold on
plot(zeit_max, maximum, 'o', 'MarkerSize', 8, 'LineWidth', 1.5)
hold off

legend('Signal', 'Maximum', 'Location', 'best')


disp('Maximum:')
disp(maximum)

disp('Zeitpunkt des Maximums:')
disp(zeit_max)

