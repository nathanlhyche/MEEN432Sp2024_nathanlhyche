% -------------------------------------------------------------------------
% racetrack portion from part 1 of project 2
% this creates the racetrack that the car will be racing on

path.radius = 200; % Radius
path.l_st = 900; % Length
path.width = 15; % Width

radius = path.radius;
l_st = path.l_st;
width = path.width;

waypoints = 100;
%timer = ((0.1*waypoints)/waypoints)

% Circumference of semi circle
circum = pi * radius; % 628.3185

% Step distance for straights and curves based on waypoints
d_s_straight = l_st / (waypoints / 2); % Divide by 2 since two straight sections
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
    if distance_traveled < l_st
        % First straight 
        x_waypoints(i) = distance_traveled;
        y_waypoints(i) = 0;
        distance_traveled = distance_traveled + d_s_straight;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str1'])
    elseif distance_traveled < l_st + circum - 1
        % First curved
        x_waypoints(i) = l_st + radius * sin(theta);
        y_waypoints(i) = radius - radius * cos(theta);
        theta1_change = ([theta1_change, theta]);
        theta = theta + delta_theta; % Update angle
        distance_traveled = distance_traveled + d_s_curve;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_curve), ' curve1*******'])
    elseif distance_traveled < 2 * l_st + circum - 1
        % Second straight
        x_waypoints(i) = l_st - (distance_traveled - (l_st + circum));
        y_waypoints(i) = 2 * radius;
        distance_traveled = distance_traveled + d_s_straight;
        %disp(['dist=', num2str(distance_traveled), ' ds=', num2str(d_s_straight), ' str2------------------'])
    elseif distance_traveled < 2 * l_st + 2 * circum
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
set(gcf, 'Position', [800, 200, 1500, 900]); % [left, bottom, width, height]
plot(x_waypoints, y_waypoints, 'k', 'LineWidth', width, 'Color', [0.7 0.7 0.7]); %gray racetrack with width
hold on; %allows car and line to be plotted after this
xlim([-300, 1200]); %axis limits
ylim([-100, 500]); %axis limits
xlabel('X-Coordinates [m]');
ylabel('Y-Coordinates [m]');
title('Race Track');

% -------------------------------------------------------------------------
% New code
% Simulation part of car simulink model
% used to get the variables from the model

simout = sim("Project2_Part2_simulink_model.slx");
Car_X_coord = simout.X.Data;
Car_Y_coord = simout.Y.Data;
Car_t = simout.tout;
% Car_psi = simout.psi.Data;

race = raceStat(Car_X_coord, Car_Y_coord, Car_t, path);
displayRaceStats(race)

% -------------------------------------------------------------------------
% Animation of car
% based on X and Y coords of simulink car model

% new vehicle values
vehicle_length = 20; 
vehicle_width = 7; 
scale_factor = 2; 

% % sets the starting location of the car at [0,0]
% vehicle_x_coords = x_waypoints(1); 
% vehicle_y_coords = y_waypoints(1);
% vehicle_angle = 0; % Start with zero angle

% % indexes
% theta1_index = 1; % Index for theta1_change
% theta2_index = 1; % Index for theta2_change

vehicle_vertices = [
    -vehicle_length / 2, -vehicle_width / 2;
    vehicle_length / 2, -vehicle_width / 2;
    vehicle_length / 2, vehicle_width / 2;
    -vehicle_length / 2, vehicle_width / 2;
];

% Plot initial car box
vehicle_patch = patch(vehicle_vertices(:,1), vehicle_vertices(:,2), 'b'); % Plot for blue vehicle

for i = 1:length(Car_X_coord)
    % used to change as vehicle coordinates based on waypoints.
    vehicle_x_coords = Car_X_coord(i);
    vehicle_y_coords = Car_Y_coord(i);

    % these if statements will make sure that the car will turn with the
    % curvature of the semicircles.
    if i > 1 && i < length(Car_X_coord) 
        % Calculate slope between the current and next waypoints
        dx = Car_X_coord(i+1) - Car_X_coord(i-1);
        dy = Car_Y_coord(i+1) - Car_Y_coord(i-1);
        tangent_angle = atan2(dy, dx);

        % updates car's angle with the new adjusted tangent angle based on
        % the slopes of the old waypoints.
        vehicle_angle = tangent_angle;
    else
        % For first and second waypoints
        dx = Car_X_coord(2) - Car_X_coord(1);
        dy = Car_Y_coord(2) - Car_Y_coord(1);
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
        plot([Car_X_coord(i-1), vehicle_x_coords], [Car_Y_coord(i-1), vehicle_y_coords], 'y-'); % Plot path line in red
        %plot(x_waypoints, y_waypoints, 'y-');
    end

    % pause allows for the car to look like it is moving instead of
    % instanteous appearance
    pause(0.01);
end

% -------------------------------------------------------------------------
% racestat portion
% using the data from the simulink model

function raceStats = raceStat(X,Y,t,path)
%========================================================
% 
% Usage: rs = raceStat(X,Y,t,path)
%
% Inputs:   X, Y are coordinates from your vehicle simulations. 
%           t is the set times corresponding to X and Y
%           path is a structure of with fields "width" (width of the 
%                  track), "l_st" (length of the straight away), and 
%                  "radius" (radius of the curved section)
%
% Outputs: raceStats is a structure with the following fields:
%
%   loops - this is an integer that tells how many loops around
%              the track the vehicle has gone around
%   tloops - this is an array that tells you the time(s) that the
%              start line was crossed 
%   leftTrack - this has the X,Y and t values when the vehicle
%              went outside the track
%   
%========================================================

prev_section = 6;
loops = -1;
j = 0;
k = 0;
Xerr = [];
Yerr = [];
terr = [];
for i = 1:length(X)
    if X(i) < path.l_st
        if X(i) >= 0
            if Y(i) < path.radius
                section = 1;
            else
                section = 4;
            end
        else
            if Y(i) < path.radius
                section = 6;
            else
                section = 5;
            end
        end
    else
        if Y(i) < path.radius
            section = 2;
        else
            section = 3;
        end
    end
    if ((prev_section == 6) && (section == 1))
        loops = loops  + 1;
        j = j+1;
        tloops(j) = t(i);
    end
    prev_section = section;
    if ~insideTrack(X(i),Y(i),section,path)
        k = k+1;
        Xerr(k) = X(i);
        Yerr(k) = Y(i);
        terr(k) = t(i);
    end
end
raceStats.loops = loops;
raceStats.tloops = tloops;
raceStats.leftTrack.X = Xerr;
raceStats.leftTrack.Y = Yerr;
raceStats.leftTrack.t = terr;
end

function yesorno = insideTrack(x,y,section,path)
switch section
    case 1
        if ((y < (0.0 + path.width)) && (y > (0.0 - path.width))) 
            yesorno = 1;
        else
            yesorno = 0;
        end
    case {2, 3}
        rad = sqrt((x - path.l_st)^2 + (y - path.radius)^2);
        if ((rad < path.radius + path.width) && ...
                (rad > path.radius - path.width))
            yesorno = 1;
        else
            yesorno = 0;
        end
    case 4
        if ((y < (2 * path.radius + path.width)) && ...
                (y > (2 * path.radius - path.width))) 
            yesorno = 1;
        else
            yesorno = 0;
        end        
    case {5, 6}
        rad = sqrt((x - 0.0)^2 + (y - path.radius)^2);
        if ((rad < path.radius + path.width) && ...
                (rad > path.radius - path.width))
            yesorno = 1;
        else
            yesorno = 0;
        end
    otherwise
        print("error");
end
end

%===================================================

function displayRaceStats(raceStats)
    fprintf('Loops: %d\n', raceStats.loops);
    fprintf('Times Loops Completed: %s\n', mat2str(raceStats.tloops));
    
    fprintf('Left Track Details:\n');
    fprintf('X: %s\n', mat2str(raceStats.leftTrack.X));
    fprintf('Y: %s\n', mat2str(raceStats.leftTrack.Y));
    fprintf('T: %s\n', mat2str(raceStats.leftTrack.t));
end
