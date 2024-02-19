radius = 200; % Radius
straight_length = 900; % Length
width = 15; % Width

waypoints = 200;

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
theta1_change = []; % radians
theta2_change = []; % radians

distance_traveled = 0; % Initial point of [0, 0]
theta = 0; % Initial angle

for i = 1:(waypoints * 2)
    % Update x and y coordinates
    if distance_traveled < straight_length
        % First straight 
        x_waypoints(i) = distance_traveled;
        y_waypoints(i) = 0;
        distance_traveled = distance_traveled + d_s_straight;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str1'])
    elseif distance_traveled < straight_length + circum - 1
        % First curved
        x_waypoints(i) = straight_length + radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        theta1_change = ([theta1_change, theta]);
        theta = theta + delta_theta; % Update angle
        distance_traveled = distance_traveled + d_s_curve;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve1*******'])
    elseif distance_traveled < 2 * straight_length + circum - 1
        % Second straight
        x_waypoints(i) = straight_length - (distance_traveled - (straight_length + circum));
        y_waypoints(i) = 2 * radius;
        distance_traveled = distance_traveled + d_s_straight;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str2------------------'])
    elseif distance_traveled < 2 * straight_length + 2 * circum
        % Second curved
        x_waypoints(i) = radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        theta2_change = ([theta1_change, theta]);
        theta = theta + delta_theta; % Update angle
        distance_traveled = distance_traveled + d_s_curve;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve2/////////////'])
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
degrees1_change = rad2deg(theta1_change); %made into degrees in case needed it
degrees2_change = rad2deg(theta2_change); %made into degrees in case needed it

% Plot race track
figure;
plot(x_waypoints, y_waypoints, 'k', 'LineWidth', width, 'Color', [0.7 0.7 0.7]); %gray racetrack with width
hold on; %allows car and line to be plotted after this
xlim([-300, 1200]); %axis limits
ylim([-100, 500]); %axis limits
xlabel('X-Coordinates [m]');
ylabel('Y-Coordinates [m]');
title('Race Track');

% new stuff for car box and car path lines -----------------------------

% new vehicle values
vehicle_length = 20; 
vehicle_width = 7; 
scale_factor = 5; 

% sets the starting location of the car at [0,0]
vehicle_x_coords = x_waypoints(1); 
vehicle_y_coords = y_waypoints(1);
vehicle_angle = 0; % Start with zero angle

% indexes
theta1_index = 1; % Index for theta1_change
theta2_index = 1; % Index for theta2_change

% Plot initial car box
vehicle_patch = patch(vehicle_vertices(:,1), vehicle_vertices(:,2), 'b'); % Plot for blue vehicle

for i = 1:length(x_waypoints)
    % used to change as vehicle coordinates based on waypoints.
    vehicle_x_coords = x_waypoints(i);
    vehicle_y_coords = y_waypoints(i);
    
    % these if statements will make sure that the car will turn with the
    % curvature of the semicircles.
    if i > 1 && i < length(x_waypoints) 
        % Calculate slope between the current and next waypoints
        dx = x_waypoints(i+1) - x_waypoints(i-1);
        dy = y_waypoints(i+1) - y_waypoints(i-1);
        tangent_angle = atan2(dy, dx);

        % updates car's angle with the new adjusted tangent angle based on
        % the slopes of the old waypoints.
        vehicle_angle = tangent_angle;
    else
        % For first and second waypoints
        dx = x_waypoints(2) - x_waypoints(1);
        dy = y_waypoints(2) - y_waypoints(1);
        tangent_angle = atan2(dy, dx);
        vehicle_angle = tangent_angle;
     end
    
    % Updates car position and rotation based on corner verticies created
    % the box that represents the car.
    rotation_matrix = [cos(vehicle_angle), -sin(vehicle_angle); sin(vehicle_angle), cos(vehicle_angle)];
    rotated_vertices = (rotation_matrix * vehicle_vertices')';
    rotated_vertices(:,1) = rotated_vertices(:,1) + vehicle_x_coords;
    rotated_vertices(:,2) = rotated_vertices(:,2) + vehicle_y_coords;
    
    % Updates car verticies positions for each iteration. ie for each
    % waypoint through the racetrack
    set(vehicle_patch, 'XData', rotated_vertices(:,1), 'YData', rotated_vertices(:,2));
    
    % Plots yellow vehicle path showing where car has traveled
    if i > 1
        plot([x_waypoints(i-1), vehicle_x_coords], [y_waypoints(i-1), vehicle_y_coords], 'y-'); % Plot path line in red
        %plot(x_waypoints, y_waypoints, 'y-');
    end
    
    % pause allows for the car to look like it is moving instead of
    % instanteous appearance
    pause(0.01);
end

