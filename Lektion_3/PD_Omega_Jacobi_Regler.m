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
Kp_pos = 2.0;       % Stärke der Positionsregelung
dt = 0.03;          % Zeitschritt
toleranz = 0.04;    % Ziel gilt erreicht bei 4 cm Abstand
max_schritte = 500; % Sicherheitsgrenze

% Startposition berechnen
[x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

figure

while true

    clf

    % Roboterarm zeichnen
    plot([0 x1 x2], [0 y1 y2], '-o', 'LineWidth', 2, 'MarkerSize', 8)
    hold on
    viscircles([0 0], L1 + L2, 'LineStyle', '--');
    hold off

    grid on
    axis equal
    axis([-2 2 -2 2])
    xlabel('x')
    ylabel('y')
    title('Jacobi-Regler: Klicke Zielpunkt für die Spitze')
    text(-1.9, 1.8, 'Linksklick = Ziel, Rechtsklick/Enter = Ende')

    % Ziel anklicken
    try
        [x_ziel, y_ziel, button] = ginput(1);
    catch
        disp('Figure wurde geschlossen. Programm beendet.')
        break
    end

    if isempty(button) || button ~= 1
        break
    end

    % Prüfen, ob Ziel grob im Arbeitsbereich liegt
    r_ziel = sqrt(x_ziel^2 + y_ziel^2);

    if r_ziel > L1 + L2 || r_ziel < abs(L1 - L2)
        disp('Ziel ist nicht erreichbar.')
        continue
    end

    % Regler-Schleife
    for schritt = 1:max_schritte

        % Aktuelle Position berechnen
        [x1, y1, x2, y2] = berechneRoboterarm(L1, L2, theta1, theta2);

        % Positionsfehler der Spitze
        fehler_pos = [x_ziel - x2;
                      y_ziel - y2];

        % Abstand zum Ziel
        abstand = norm(fehler_pos);

        % Wenn nah genug: stoppen
        if abstand < toleranz
            disp('Ziel erreicht mit Jacobi-Regler.')
            break
        end

        % Gewünschte Geschwindigkeit der Spitze
        v_ziel = Kp_pos * fehler_pos;

        % Jacobi-Matrix berechnen
        J = jacobiRoboterarm(L1, L2, theta1, theta2);

        % Gelenkgeschwindigkeiten berechnen
        omega = pinv(J) * v_ziel;

        % Optional: Geschwindigkeit begrenzen
        omega_max = deg2rad(120);

        if norm(omega) > omega_max
            omega = omega / norm(omega) * omega_max;
        end

        % Winkel aktualisieren
        theta1 = theta1 + omega(1) * dt;
        theta2 = theta2 + omega(2) * dt;

        % Neue Position berechnen
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
        title('Roboterarm mit Jacobi-Positionsregler')

        text(-1.9, 1.8, ['Abstand: ', num2str(abstand, '%.3f')])
        text(-1.9, 1.6, ['omega1: ', num2str(rad2deg(omega(1)), '%.2f'), ' Grad/s'])
        text(-1.9, 1.4, ['omega2: ', num2str(rad2deg(omega(2)), '%.2f'), ' Grad/s'])
        text(-1.9, 1.2, ['Schritt: ', num2str(schritt)])

        pause(dt)
    end

    disp('Aktuelle Spitze:')
    disp([x2; y2])

    disp('theta1 in Grad:')
    disp(rad2deg(theta1))

    disp('theta2 in Grad:')
    disp(rad2deg(theta2))

end