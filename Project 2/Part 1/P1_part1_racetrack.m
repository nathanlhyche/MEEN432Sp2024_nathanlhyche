radius = 200; % Radius
straight_length = 900; % Length
width = 15; % Width

waypoints = 100;

% circumference of semi circle
circum = pi * radius; %628.3185

% step distance for straights and curves based on waypoints
d_s_straight = straight_length / (waypoints / 2); % Divide by 2 since two straight sections
d_s_curve = circum / (waypoints / 2); % Divide by 2 since two curved sections

% Initialize arrays
x_waypoints = zeros(1, waypoints * 2);
y_waypoints = zeros(1, waypoints * 2);

distance_traveled = 0; % initial point of [0, 0]

for i = 1:(waypoints * 2)
    % Update x and y coordinates
    if distance_traveled < straight_length
        % first straight 
        x_waypoints(i) = distance_traveled;
        y_waypoints(i) = 0;
        distance_traveled = distance_traveled + d_s_straight;
        disp(['s=', num2str(distance_traveled), 'ds =', num2str(d_s_straight), ' str1'])
    elseif distance_traveled < straight_length + circum - 1
        % first curved
        theta = (distance_traveled - straight_length) / radius;
        x_waypoints(i) = straight_length + radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        distance_traveled = distance_traveled + d_s_curve;
        disp(['s=', num2str(distance_traveled), 'ds =', num2str(d_s_curve), ' curve1*******'])
    elseif distance_traveled < 2 * straight_length + circum - 1
        % second straight
        x_waypoints(i) = straight_length - (distance_traveled - (straight_length + circum));
        y_waypoints(i) = 2 * radius;
        distance_traveled = distance_traveled + d_s_straight;
        disp(['s=', num2str(distance_traveled), 'ds =', num2str(d_s_straight), ' str2------------------'])
    elseif distance_traveled < 2 * straight_length + 2 * circum
        % second curved
        theta = pi - (distance_traveled - (2 * straight_length + circum)) / radius;
        x_waypoints(i) = -radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        distance_traveled = distance_traveled + d_s_curve;
        disp(['s=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve2/////////////'])
    end
end

% adds the last iteration part that connects the last semi circle point to
% the start point of [0, 0]
x_waypoints = [x_waypoints, 0] 
y_waypoints = [y_waypoints, 0]

% disp(['s=', num2str(s), 'ds =', num2str(delta_s_straight)])
% disp(['s=', num2str(s), 'ds =', num2str(delta_s_curve)])
% d = 2 * straight_length + arc_length
% h = straight_length + arc_length

% Plot
figure;
plot(x_waypoints, y_waypoints, 'k', 'LineWidth', width);
xlim([-300, 1200]);
ylim([-100, 500]);
xlabel('X [m]');
ylabel('Y [m]');
title('Track Path');