clear;

mass = 1; %kg
l = .3; %meters
l_inches = l * 39.3701;
g = 9.81; %m/s

theta0 = deg2rad(-5); %the number is degrees in it
omega0 = 0;

phi = deg2rad(85); %the number is degrees in it

state0 = [theta0; omega0];

time = [0 0.55];

dt = 0.01;
tspan = 0:dt:0.55;

[t, x] = ode45(@(t,x) invPendulum(x, l, g), tspan, state0);

theta = x(:,1);
theta_dot = x(:,2);

s = zeros(length(theta), 1);
forearm_inches = zeros(length(theta), 1);
figure(1);
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
    axis([-.75 .75 -.75 .75]);

    title(sprintf('t = %.2f s', t(i)));

    grid on;

    drawnow;
end


cooked_angle = rad2deg(theta) + rad2deg(phi);

% Plot angle
figure(3);
plot(t, rad2deg(theta), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('\theta (deg)');
title('Inverted Pendulum Fall');
grid on;

%final variable which shows at any given time what the forearm length should
%be, at time 0 it should be that length right when we begin falling
time_and_forearm = [t forearm_inches];

figure(2);
plot(t, forearm_inches, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Forelimb Length (inches)');
title('Forelimb Length');
grid on;

function dx = invPendulum(x, l, g)

theta = x(1);
theta_dot = x(2);

theta_ddot = (g/l)*sin(theta);

dx = [theta_dot;
      theta_ddot];
end
