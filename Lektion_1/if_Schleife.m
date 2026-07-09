clear
clc
close all

t = 0:0.01:10;
y = sin(t) .* exp(-1*t);


[maximum, index] = max(y);
zeit_max = t(index);

plot(t, y)
grid on 
xlabel('Time (s)');
ylabel('Signal')
title('Test')

hold on
plot(zeit_max, maximum, 'o')
hold off

disp('Maximum:')
disp(maximum)

disp('Zeitpunkt des max')
disp(zeit_max)

if maximum > 0.7
    disp('Amplitude stark')
else
    disp('Amplitude schwach')
end
