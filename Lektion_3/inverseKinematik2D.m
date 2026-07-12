function [theta1, theta2, erreichbar] = inverseKinematik2D(L1, L2, x, y)

r = sqrt(x^2 + y^2);

if r > L1 + L2 || r < abs(L1 - L2)
    theta1 = NaN;
    theta2 = NaN;
    erreichbar = false;
    return
end

erreichbar = true;

cos_theta2 = (x^2 + y^2 - L1^2 - L2^2) / (2*L1*L2);
cos_theta2 = max(min(cos_theta2, 1), -1);

theta2 = acos(cos_theta2);

k1 = L1 + L2*cos(theta2);
k2 = L2*sin(theta2);

theta1 = atan2(y, x) - atan2(k2, k1);

end