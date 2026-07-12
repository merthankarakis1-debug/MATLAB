clear
clc
close all

% Armlängen
L1 = 1.0;
L2 = 0.7;

% Startwinkel
theta1 = deg2rad(30);
theta2 = deg2rad(30);

% Regler-Parameter
Kp = 0.2;              % P-Verstärkung
toleranz = deg2rad(1);  % Ziel gilt erreicht bei 1 Grad Fehler
max_schritte = 300;     % Sicherheitsgrenze, falls overflow


% Startposition berechnen
[x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

figure

while true

    clf

    % Aktuellen Roboterarm zeichnen
    plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
    hold on
    viscircles([0 0], L1 + L2, 'LineStyle', '--');
    hold off

    grid on
    axis equal
    axis([-2 2 -2 2])
    xlabel('x')
    ylabel('y')
    title('P-Regler: Klicke ein Ziel für die Roboterarm-Spitze')
    text(-1.9, 1.8, 'Linksklick = Ziel, Rechtsklick/Enter = Ende')

    % Zielpunkt anklicken (try catch wegen Freeze)
    try
        [x_ziel, y_ziel, button] = ginput(1); %auf Mausklick warten und Werte zurückgeben
    catch
        disp('Figure wurde geschlossen. Programm beendet.')
        break
    end

    if isempty(button) || button ~= 1
        break
    end

    % Zielwinkel mit inverser Kinematik berechnen
    [theta1_ziel, theta2_ziel, erreichbar] = inverseKinematik2D(L1, L2, x_ziel, y_ziel);

    if erreichbar == false
        disp('Ziel ist nicht erreichbar.')
        continue
    end

    % P-Regler-Schleife
    for schritt = 1:max_schritte

        % Fehler berechnen
        fehler1 = theta1_ziel - theta1;
        fehler2 = theta2_ziel - theta2;

        % Regler: aktueller Winkel wird Richtung Zielwinkel geschoben
        theta1 = theta1 + Kp * fehler1;
        theta2 = theta2 + Kp * fehler2;

        % Neue Armposition berechnen
        [x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

        % Plot aktualisieren
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
        title('Roboterarm mit P-Regler')

        text(-1.9, 1.8, ['Fehler theta1: ', num2str(rad2deg(fehler1), '%.2f'), ' Grad'])
        text(-1.9, 1.6, ['Fehler theta2: ', num2str(rad2deg(fehler2), '%.2f'), ' Grad'])
        text(-1.9, 1.4, ['Schritt: ', num2str(schritt)])

        pause(0.03)

        % Abbruch, wenn beide Fehler klein genug sind
        if abs(fehler1) < toleranz && abs(fehler2) < toleranz
            disp('Ziel erreicht mit P-Regler.')
            break
        end
    end

    disp('theta1 in Grad:')
    disp(rad2deg(theta1))

    disp('theta2 in Grad:')
    disp(rad2deg(theta2))

end