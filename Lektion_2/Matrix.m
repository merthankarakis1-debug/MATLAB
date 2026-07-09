clear
clc
close all

A = [1 2 3;
     4 5 6;
     7 8 9];

disp('Matrix A:')
disp(A)

wert = A(2,3);
disp('Element Zeile 2, Spalte 3:')
disp(wert)

zeile2 = A(2, :);
disp('Zeile 2:')
disp(zeile2)

spalte3 = A(:, 3);
disp('Spalte 3:')
disp(spalte3)

teil = A(1:2, 2:3);
disp('Teilmatrix:')
disp(teil)