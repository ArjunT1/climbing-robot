clear;


mass = 1; %kg
l_inches = 1:1:20;
l = l_inches/39.3701; %inches converted to meters
g = 9.81; %m/s


theta0 = -asin(5/7);
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

time_disaster = zeros(length(l), 1);
savetime = zeros(length(l), length(tspan));
savetheta = zeros(length(l), length(tspan));

s = zeros(length(l), length(tspan));
forearm_inches = zeros(length(l), length(tspan));
alpha = zeros(length(l), length(tspan));

figure(1);
for ii = 1:length(l)
    [t, x] = ode45(@(t,x) invPendulum(x, l(ii), g), tspan, state0);

    theta = x(:,1);
    theta_dot = x(:,2);
    savetime(ii,:) = t';
    savetheta(ii, :) = theta';

    for i = 1:length(t)
        clf;
        hold on;
    
        th = theta(i);
    
        % Pendulum tip
        xp = l(ii)*sin(th);
        yp = l(ii)*cos(th);
    
        % Offset segment direction
        alpha(ii, i) = -th + phi - pi/2;

        % Solve for intersection with x = 0
        s(i) = -xp / cos(alpha(i));

        % Endpoint on vertical axis
        xc = xp + s(i)*cos(alpha(i));
        yc = yp + s(i)*sin(alpha(i));

        if yc < 0.1
            time_disaster(ii) = t(i);
        break
        end
    
        % % Draw vertical reference line
        % plot([0 0], [-1.5 1.5], 'k--');
        % 
        % % Draw pendulum
        % plot([0 xp], [0 yp], ...
        %     'b', 'LineWidth', 3);
        % 
        % % Draw offset segment
        % plot([xp xc], [yp yc], ...
        %     'r', 'LineWidth', 3);
        % 
        % % Draw pendulum mass
        % plot(xp, yp, ...
        %     'ko', ...
        %     'MarkerFaceColor', 'k', ...
        %     'MarkerSize', 10);
        % 
        % axis equal;
        % axis([-.75 .75 -.75 .75]);
        % 
        % title(sprintf('t = %.2f s', t(i)));
        % 
        % grid on;
        % 
        % drawnow;
    end
end
cooked_angle = rad2deg(theta) + rad2deg(phi);

for i = length(l)
    % Plot angle
    figure(2);
    plot(savetime(i, :), rad2deg(savetheta(i, :)), 'LineWidth', 0.5);
    xlabel('Time (s)');
    ylabel('\theta (deg)');
    title('Inverted Pendulum Fall');
    grid on;
    hold on;
end
hold off;


%final variable which shows at any given time what the forearm length should
%be, at time 0 it should be that length right when we begin falling
%time_and_forearm = [t forearm_inches];

%forearm_inches(forearm_inches < 0) = 0;

for i = length(l)
    figure(3);
    plot(savetime(i, :), forearm_inches(i, :), 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Forelimb Length (inches)');
    title('Required Forelimb Length');
    grid on;
    hold on;
end
hold off;

function dx = invPendulum(x, l, g)

theta = x(1);
theta_dot = x(2);

theta_ddot = (g/l)*sin(theta);

dx = [theta_dot;
      theta_ddot];
end
