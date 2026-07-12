clear
clc
close all

% Armlängen
L1 = 1.0;
L2 = 0.7;

% Startwinkel
theta1 = deg2rad(30);
theta2 = deg2rad(30);

% Startgeschwindigkeiten
omega1 = 0;
omega2 = 0;

% Regler-Parameter
Kp = 8;                 % zieht Richtung Ziel
Kd = 2;                 % dämpft Bewegung
dt = 0.03;              % Simulations-Zeitschritt
toleranz = deg2rad(1);  % Ziel gilt erreicht bei 1 Grad Fehler
max_schritte = 500;     % Sicherheitsgrenze

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
    title('PD-Regler mit Gelenkgeschwindigkeit')
    text(-1.9, 1.8, 'Linksklick = Ziel, Rechtsklick/Enter = Ende')

    % Zielpunkt anklicken
    try
        [x_ziel, y_ziel, button] = ginput(1);
    catch
        disp('Figure wurde geschlossen. Programm beendet.')
        break
    end

    if isempty(button) || button ~= 1
        break
    end

    % Zielwinkel berechnen
    [theta1_ziel, theta2_ziel, erreichbar] = inverseKinematik2D(L1, L2, x_ziel, y_ziel);

    if erreichbar == false
        disp('Ziel ist nicht erreichbar.')
        continue
    end

    % Für neues Ziel: Geschwindigkeiten zurücksetzen
    omega1 = 0;
    omega2 = 0;

    % Regler-Schleife
    for schritt = 1:max_schritte

        % Fehler berechnen
        fehler1 = theta1_ziel - theta1;
        fehler2 = theta2_ziel - theta2;

        % PD-Regler mit Geschwindigkeit
        alpha1 = Kp * fehler1 - Kd * omega1;
        alpha2 = Kp * fehler2 - Kd * omega2;

        % Geschwindigkeit aktualisieren
        omega1 = omega1 + alpha1 * dt;
        omega2 = omega2 + alpha2 * dt;

        % Winkel aktualisieren
        theta1 = theta1 + omega1 * dt;
        theta2 = theta2 + omega2 * dt;

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
        title('Roboterarm mit PD-Regler und omega')

        text(-1.9, 1.8, ['Fehler theta1: ', num2str(rad2deg(fehler1), '%.2f'), ' Grad'])
        text(-1.9, 1.6, ['Fehler theta2: ', num2str(rad2deg(fehler2), '%.2f'), ' Grad'])
        text(-1.9, 1.4, ['omega1: ', num2str(rad2deg(omega1), '%.2f'), ' Grad/s'])
        text(-1.9, 1.2, ['omega2: ', num2str(rad2deg(omega2), '%.2f'), ' Grad/s'])
        text(-1.9, 1.0, ['Schritt: ', num2str(schritt)])

        pause(dt)

        % Ziel erreicht, wenn Fehler klein und Geschwindigkeit klein ist
        if abs(fehler1) < toleranz && abs(fehler2) < toleranz && ...
           abs(omega1) < toleranz && abs(omega2) < toleranz
            disp('Ziel erreicht mit PD-Regler und omega.')
            break
        end
    end

    disp('theta1 in Grad:')
    disp(rad2deg(theta1))

    disp('theta2 in Grad:')
    disp(rad2deg(theta2))

end