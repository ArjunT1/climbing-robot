clear;


mass = 1; %kg
l_inches = 5.1;
l = l_inches/39.3701; %inches converted to meters
g = 9.81; %m/s


theta0 = -asin(4/l_inches);
%theta0 = deg2rad(-5); %the number is degrees in it
omega0 = 0;

phi = pi/2 + theta0;
%phi = deg2rad(85); %the number is degrees in it
%Right now im assuming whatever the angle we are falling away from the
%tree, the forelimbs are at a position where they hit the tree
%perpendicular to the tree

state0 = [theta0; omega0];

time = [0 0.55];

dt = 0.01;
tspan = 0:dt:0.55;

[t, x] = ode45(@(t,x) invPendulum(x, l, g), tspan, state0);

theta = x(:,1);
theta_dot = x(:,2);

s = zeros(length(theta), 1);
forearm_inches = zeros(length(theta), 1);

alpha = zeros(length(theta), 1);
xc = zeros(length(theta), 1);
yc = zeros(length(theta), 1);
xp = zeros(length(theta), 1);
yp = zeros(length(theta), 1);

figure(1);
for i = 1:length(t)

    clf;
    hold on;

    th = theta(i);

    % Pendulum tip
    xp(i) = l*sin(th);
    yp(i) = l*cos(th);
    
    % Offset segment direction
    alpha(i) = -th + phi - pi/2;

    % Solve for intersection with x = 0
    s(i) = -xp(i) / cos(alpha(i));

    % Endpoint on vertical axis
    xc(i) = xp(i) + s(i)*cos(alpha(i));
    yc(i) = yp(i) + s(i)*sin(alpha(i));

    if yc(i) < 0.0
        time_disaster = t(i);
        break
    end

    forearm_inches(i) = s(i) * 39.3701;

    % Draw vertical reference line
    plot([0 0], [-1.5 1.5], 'k--');

    % Draw pendulum
    plot([0 xp(i)], [0 yp(i)], ...
        'b', 'LineWidth', 3);

    % Draw offset segment
    plot([xp(i) xc(i)], [yp(i) yc(i)], ...
        'r', 'LineWidth', 3);

    % Draw pendulum mass
    plot(xp(i), yp(i), ...
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

forearm_extension = forearm_inches - 4;

% Plot angle
figure(3);
plot(t, rad2deg(theta), 'LineWidth', 2);
xlabel('Time (s)');
ylabel('\theta (deg)');
title('Inverted Pendulum Fall');
grid on;

%final variable which shows at any given time what the forearm length should
%be, at time 0 it should be that length right when we begin falling
time_alphadeg_forearm_xy = [t rad2deg(alpha) forearm_extension xp*39.3701 (yc-yp(1))*39.3701];

figure(2);
plot(t, forearm_extension, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Forelimb Extension (inches)');
title('Forelimb Extension');
grid on;

alpha_deg = rad2deg(alpha);

function dx = invPendulum(x, l, g)

theta = x(1);
theta_dot = x(2);

theta_ddot = (g/l)*sin(theta);

dx = [theta_dot;
      theta_ddot];
end
