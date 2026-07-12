function J = jacobiRoboterarm(L1, L2, theta1, theta2)

J = [-L1*sin(theta1) - L2*sin(theta1 + theta2),   -L2*sin(theta1 + theta2);
    L1*cos(theta1) + L2*cos(theta1 + theta2),    L2*cos(theta1 + theta2)];

end