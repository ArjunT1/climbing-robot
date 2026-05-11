%Case A

%x = [0,  1, 2];
%y = [0,  1, 0];

mass = 5;
g = 9.8;

height = 50;

figure(1)
tree = plot([2.5 2.5], [-height height], "g");
hold on
h = plot([2.5 1.5 1.5 2.5], [7 7.75 9.25 10], '-o');
axis([ 0 3.5 -height height ])

% Slider
slider = uicontrol('Style','slider', ...
    'Min',0,'Max',1,'Value',0, ...
    'SliderStep',[1/100 , 10/100], ...
    'Position',[150 20 300 20], ...
    'Callback', @(src,~) updateFrame(src.Value, h, mass, g));

% --- Update function ---
function updateFrame(t, h, mass, g)
    %t = round(t);  % make it an integer frame

    x = [2.5, 1.5, 1.5, 2.5];
    y = [7-mass*g*t^2, 7.75-mass*g*t^2, 9.25-mass*g*t^2, 10 - mass*g*t^2];

    set(h, 'XData', x, 'YData', y);
    drawnow;
end