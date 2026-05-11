clear;

mass = 1;
l = .7;
g = 9.81;

theta0 = deg2rad(-10);
omega0 = 0;

phi = deg2rad(80);

state0 = [theta0; omega0];

time = [0 0.7];

dt = 0.01;
tspan = 0:dt:0.7;

[t, x] = ode45(@(t,x) invPendulum(x, l, g), tspan, state0);

theta = x(:,1);
theta_dot = x(:,2);

% Plot angle
figure;
plot(t, rad2deg(theta), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('\theta (deg)');
title('Inverted Pendulum Fall');
grid on;


s = zeros(length(theta), 1);
forearm_inches = zeros(length(theta), 1);
figure;
for i = 1:length(t)

    clf;
    hold on;

    th = theta(i);

    % Pendulum tip
    xp = l*sin(th);
    yp = l*cos(th);

    % Offset segment direction
    alpha = th - phi;

    % Solve for intersection with x = 0
    s(i) = -xp / sin(alpha);

    % Endpoint on vertical axis
    xc = xp + s(i)*sin(alpha);
    yc = yp + s(i)*cos(alpha);

    forearm_inches(i) = -s(i) * 39.3701;

    if yc < 0.1
        break
    end

    % Draw vertical reference line
    plot([0 0], [-1.5 1.5], 'k--');

    % Draw pendulum
    plot([0 xp], [0 yp], ...
        'b', 'LineWidth', 3);

    % Draw offset segment
    plot([xp xc], [yp yc], ...
        'r', 'LineWidth', 3);

    % Draw pendulum mass
    plot(xp, yp, ...
        'ko', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 10);

    axis equal;
    axis([-1.5 1.5 -1.5 1.5]);

    title(sprintf('t = %.2f s', t(i)));

    grid on;

    drawnow;
end


cooked_angle = rad2deg(theta) + rad2deg(phi);

function dx = invPendulum(x, l, g)

theta = x(1);
theta_dot = x(2);

theta_ddot = (g/l)*sin(theta);

dx = [theta_dot;
      theta_ddot];
end

time_and_forearm = [t forearm_inches];