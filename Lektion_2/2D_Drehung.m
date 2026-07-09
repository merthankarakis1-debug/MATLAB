clear 
clc
close all

winkel_grad = 45;
theta = deg2rad(winkel_grad)

R = [cos(theta) -sin(theta); %Rotationsmatrix
    sin(theta) cos(theta)];

p = [1;
    0];
p_new = R * p;

plot([0 p(1)],[0 p(2)], 'LineWidth',2)

hold on
plot([0 p_new(1)],[0 p_new(2)],'LineWidth',2)
hold off

grid on
axis equal
xlabel('x')
ylabel('y')
title('Drehung in 2D')
legend('Vorher','Nachher')
