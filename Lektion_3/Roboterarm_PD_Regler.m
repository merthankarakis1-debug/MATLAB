clear
clc
close all

L1 = 1.0;
L2 = 0.7;

theta1 = deg2rad(30);
theta2 = deg2rad(30);

Kp = 0.12;
Kd = 0.05;

toleranz = deg2rad(1);
max_schritte = 300;

[x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

figure

while true

    clf

    plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
    hold on
    viscircles([0 0], L1 + L2, 'LineStyle', '--');
    hold off

    grid on
    axis equal
    axis([-2 2 -2 2])
    xlabel('x')
    ylabel('y')
    title('PD-Regler: Klicke ein Ziel für die Roboterarm-Spitze')
    text(-1.9, 1.8, 'Linksklick = Ziel, Rechtsklick/Enter = Ende')

    try
        [x_ziel, y_ziel, button] = ginput(1);
    catch
        disp('Figure wurde geschlossen. Programm beendet.')
        break
    end

    if isempty(button) || button ~= 1
        break
    end

    [theta1_ziel, theta2_ziel, erreichbar] = inverseKinematik2D(L1, L2, x_ziel, y_ziel);

    if erreichbar == false
        disp('Ziel ist nicht erreichbar.')
        continue
    end

    fehler1_alt = theta1_ziel - theta1;
    fehler2_alt = theta2_ziel - theta2;

    for schritt = 1:max_schritte

        fehler1 = theta1_ziel - theta1;
        fehler2 = theta2_ziel - theta2;

        d_fehler1 = fehler1 - fehler1_alt;
        d_fehler2 = fehler2 - fehler2_alt;

        theta1 = theta1 + Kp * fehler1 + Kd * d_fehler1;
        theta2 = theta2 + Kp * fehler2 + Kd * d_fehler2;

        fehler1_alt = fehler1;
        fehler2_alt = fehler2;

        [x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

        clf

        plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
        hold on
        plot(x_ziel, y_ziel, 'x', 'MarkerSize', 10, 'LineWidth', 2)
        viscircles([0 0], L1 + L2, 'LineStyle', '--');
        hold off

        grid on
        axis equal
        axis([-2 2 -2 2])
        xlabel('x')
        ylabel('y')
        title('Roboterarm mit PD-Regler')

        text(-1.9, 1.8, ['Fehler theta1: ', num2str(rad2deg(fehler1), '%.2f'), ' Grad'])
        text(-1.9, 1.6, ['Fehler theta2: ', num2str(rad2deg(fehler2), '%.2f'), ' Grad'])
        text(-1.9, 1.4, ['Schritt: ', num2str(schritt)])

        pause(0.03)

        if abs(fehler1) < toleranz && abs(fehler2) < toleranz
            disp('Ziel erreicht mit PD-Regler.')
            break
        end
    end

    disp('theta1 in Grad:')
    disp(rad2deg(theta1))

    disp('theta2 in Grad:')
    disp(rad2deg(theta2))

end
