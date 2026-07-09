clear 
clc
close all

t=0:0.01:10;
y = sin(t) .* exp(-0.2 * t);

[max, index]=max(y);
zeit_max=t(index)

plot(t, y)

grid on
xlabel('Zeit[s]')
ylabel('SIgnal')
title('Test Signale')

 hold on
 plot(zeit_max, max, 'o')
 hold off

 disp('maximum:')
 disp(max)

 disp('Zeitpunkt')
 disp(zeit_max)

