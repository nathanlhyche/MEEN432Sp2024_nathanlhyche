radius = 200; % Radius
straight_length = 900; % Length
width = 15; % Width

waypoints = 100;

% Circumference of semi circle
circum = pi * radius; % 628.3185

% Step distance for straights and curves based on waypoints
d_s_straight = straight_length / (waypoints / 2); % Divide by 2 since two straight sections
d_s_curve = circum / (waypoints / 2); % Divide by 2 since two curved sections

% Calculate angle increment for curved sections
delta_theta = pi / (waypoints / 2); % Divide by 2 since two curved sections

% Initialize arrays
x_waypoints = zeros(1, waypoints * 2);
y_waypoints = zeros(1, waypoints * 2);
theta1_change = [] % radians
theta2_change = [] % radians

distance_traveled = 0; % Initial point of [0, 0]
theta = 0; % Initial angle

for i = 1:(waypoints * 2)
    % Update x and y coordinates
    if distance_traveled < straight_length
        % First straight 
        x_waypoints(i) = distance_traveled;
        y_waypoints(i) = 0;
        distance_traveled = distance_traveled + d_s_straight;
        disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str1'])
    elseif distance_traveled < straight_length + circum - 1
        % First curved
        x_waypoints(i) = straight_length + radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        theta1_change = ([theta1_change, theta]);
        theta = theta + delta_theta; % Update angle
        distance_traveled = distance_traveled + d_s_curve;
        disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve1*******'])
    elseif distance_traveled < 2 * straight_length + circum - 1
        % Second straight
        x_waypoints(i) = straight_length - (distance_traveled - (straight_length + circum));
        y_waypoints(i) = 2 * radius;
        distance_traveled = distance_traveled + d_s_straight;
        disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str2------------------'])
    elseif distance_traveled < 2 * straight_length + 2 * circum
        % Second curved
        x_waypoints(i) = radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        theta2_change = ([theta1_change, theta]);
        theta = theta + delta_theta; % Update angle
        distance_traveled = distance_traveled + d_s_curve;
        disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve2/////////////'])
    end
end

% adds last part of the x and y coordinates to connect to the 
x_waypoints = [x_waypoints, 0]; 
y_waypoints = [y_waypoints, 0];

% adds the last part of the changes in thetas to the angles for each semi
% circle
% in radians
index1 = length(theta1_change);
theta1_change = [theta1_change, theta1_change(index1) + delta_theta];
index2 = length(theta2_change);
theta2_change = theta2_change(1:end-1);
theta2_change = [theta2_change, theta2_change(index2 - 1) + delta_theta];
degrees1_change = rad2deg(theta1_change);
degrees2_change = rad2deg(theta2_change);

% Plot
figure;
plot(x_waypoints, y_waypoints, 'k', 'LineWidth', width);
xlim([-300, 1200]);
ylim([-100, 500]);
xlabel('X [m]');
ylabel('Y [m]');
title('Race Track');
