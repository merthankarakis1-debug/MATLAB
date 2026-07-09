clear
clc
close all

A = [1 2;
    3 4];

B = [10 20;
    30 40];
v =[4;
    3];

C = A + B;
D = 2 * A;
E = A .* B;
F = A * B;
G = A * v;
x = A\v;

disp('A + B:')
disp(C)

disp('2 * A:')
disp(D)

disp('A .* B elementweise:')
disp(E)

disp('A * B Matrixmultiplikation:')
disp(F)

disp('Matrix Vektor')
disp(G)

disp('Lösen LGS')
disp(x)