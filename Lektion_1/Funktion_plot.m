clear 
clc
close all

t=0:0.01:10;
y1=sin(t);
y2=cos(t);
y3 = sin(t) .* exp(-1 * t);


plot(t, y1, t, y2, t, y3)

grid on
xlabel('Zeit[s]')
ylabel('SIgnal')
title('Test Signale')
legend('sin','cos','gedämpft sin')