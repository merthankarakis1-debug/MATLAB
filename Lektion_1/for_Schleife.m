clear
clc
close all

t = 0:0.01:10;
Daempfung = [0.2 0.5 1.0];

for i = 1:length(Daempfung)
    d = Daempfung(i);

    y=sin(t) .* exp(-d*t);

    [maximum, index] = max(y);
    zeit_max = t(index);

    plot(t, y)
    hold on
    plot(zeit_max, maximum, 'o')

    disp('Dämpfung;')
    disp(d)

    disp('Maximum:')
    disp(maximum)

    disp('Zeitpunkt des Max:')
    disp(zeit_max)

    if maximum>0.7
        disp('Amplitude stark')
    else
        disp('Amplitude schwach')
    end
end


    grid on
    xlabel('Zeit s')
    ylabel('Signal')
    title('Vergleich der Dämpfung')
    legend('d=0.2', 'max d=0.2', 'd=0.5', 'max d=0.5', 'd=1.0', 'max d=1.0')
    hold off
    
