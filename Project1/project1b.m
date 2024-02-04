% Complete script to simulate Inertia-Rotational Damper system

% Set initial conditions
initial_angular_velocity = 10.0;  % Initial angular velocity
initial_input_torque = 0.0;       % Initial input torque

% Set system parameters
J1 = 100;          % Rotational inertia
b = 10;            % Damping coefficient
A_constant_torque = 100;   % Constant applied torque
w_frequency = 0.1;         % Frequency for sinusoidal torque
t_span = [0 25];           % Total simulation time

% Integration time steps for fixed time step methods
time_steps = [0.001, 0.1, 1];

% Initialize persistent variable for inertia function
angular_velocity_inertia = 0;

% Initialize variables to capture data
data_euler = cell(length(time_steps), 1);
data_rk4 = cell(length(time_steps), 1);
data_ode45 = [];

% Simulation with fixed time step methods (Euler, Runge-Kutta 4th order)
for dt_index = 1:length(time_steps)
    dt = time_steps(dt_index);
    
    % Euler integration
    tic;
    [time_euler, angular_velocity_euler, angular_velocity_inertia] = simulateSystem(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia);
    cpu_time_euler = toc;
    
    % Runge-Kutta 4th order integration
    tic;
    [time_rk4, angular_velocity_rk4, angular_velocity_inertia] = simulateSystemRK4(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia);
    cpu_time_rk4 = toc;
    
    % Capture simulation variables
    data_euler{dt_index} = struct('Time', time_euler, 'AngularVelocity', angular_velocity_euler);
    data_rk4{dt_index} = struct('Time', time_rk4, 'AngularVelocity', angular_velocity_rk4);
    
    % Calculate maximum error for step inputs (Euler and Runge-Kutta 4th order)
    if dt_index == 1
        theoretical_velocity = initial_angular_velocity + A_constant_torque / J1 * time_euler;
        max_error_euler = max(abs(angular_velocity_euler - theoretical_velocity));
        max_error_rk4 = max(abs(angular_velocity_rk4 - theoretical_velocity));
    end
    
    % Display and save results
    fprintf('Fixed Time Step Simulation (dt = %f s)\n', dt);
    fprintf('CPU Time (Euler): %.6f s\n', cpu_time_euler);
    fprintf('Maximum Error (Euler): %.6f rad/s\n', max_error_euler);
    fprintf('CPU Time (Runge-Kutta 4th order): %.6f s\n', cpu_time_rk4);
    fprintf('Maximum Error (Runge-Kutta 4th order): %.6f rad/s\n', max_error_rk4);
    fprintf('\n');
end

% Simulation with variable time step methods (ode45)
% ode45
tic;
[t_ode45, angular_velocity_ode45] = simulateSystemODE45(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, t_span, time_steps);
cpu_time_ode45 = toc;

% Capture simulation variables
data_ode45 = struct('Time', t_ode45, 'AngularVelocity', angular_velocity_ode45);

% Calculate maximum error for step inputs (ode45)
theoretical_velocity_ode45 = initial_angular_velocity + A_constant_torque / J1 * t_ode45;
max_error_ode45 = max(abs(angular_velocity_ode45 - theoretical_velocity_ode45));

% Display and save results
fprintf('Variable Time Step Simulation (ode45)\n');
fprintf('CPU Time (ode45): %.6f s\n', cpu_time_ode45);
fprintf('Maximum Error (ode45): %.6f rad/s\n', max_error_ode45);

% Save workspace variables
save('InertiaRotationalDamperSimulationData.mat', 'data_euler', 'data_rk4', 'data_ode45');

% Inertia Function
function angular_velocity = inertia(input_torque, inertia_constant, dt, angular_velocity_inertia)
    angular_acceleration = input_torque / inertia_constant;
    angular_velocity = angular_velocity_inertia + angular_acceleration * dt;
end

% Rotational Damper Function
function damping_torque = rotationalDamper(angular_velocity, damper_constant)
    damping_torque = damper_constant * angular_velocity;
end

% Function for simulation using Euler method
function [time, angular_velocity, angular_velocity_inertia] = simulateSystem(inertia_func, damper_func, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia)
    time = t_span(1):dt:t_span(2);
    angular_velocity = zeros(size(time));
    angular_velocity(1) = initial_angular_velocity;
    
    for i = 2:length(time)
        input_torque = getAppliedTorque(time(i), A_constant_torque, w_frequency);
        angular_velocity(i) = inertia_func(input_torque, J1, dt, angular_velocity_inertia) + damper_func(angular_velocity(i-1), b);
    end
    
    angular_velocity_inertia = angular_velocity(end);
end

% Function for simulation using Runge-Kutta 4th order method
function [time, angular_velocity, angular_velocity_inertia] = simulateSystemRK4(inertia_func, damper_func, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia)
    time = t_span(1):dt:t_span(2);
    angular_velocity = zeros(size(time));
    angular_velocity(1) = initial_angular_velocity;
    
    for i = 2:length(time)
        input_torque = getAppliedTorque(time(i), A_constant_torque, w_frequency);
        
        k1 = dt * (inertia_func(input_torque, J1, dt, angular_velocity_inertia) + damper_func(angular_velocity(i-1), b));
        k2 = dt * (inertia_func(input_torque, J1, dt, angular_velocity_inertia) + damper_func(angular_velocity(i-1) + k1/2, b));
        k3 = dt * (inertia_func(input_torque, J1, dt, angular_velocity_inertia) + damper_func(angular_velocity(i-1) + k2/2, b));
        k4 = dt * (inertia_func(input_torque, J1, dt, angular_velocity_inertia) + damper_func(angular_velocity(i-1) + k3, b));
        
        angular_velocity(i) = angular_velocity(i-1) + (k1 + 2*k2 + 2*k3 + k4)/6;
    end
    
    angular_velocity_inertia = angular_velocity(end);
end

% Function for simulation using ode45 method
function [time, angular_velocity] = simulateSystemODE45(inertia_func, damper_func, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, t_span, time_steps)
    options = odeset('RelTol',1e-6,'AbsTol',1e-6);
    [time, states] = ode45(@(t, y) systemODE(t, y, inertia_func, damper_func, J1, b, A_constant_torque, w_frequency, time_steps), t_span, [initial_angular_velocity], options);
    angular_velocity = states(:, 1);
end

% Helper function for ode45 and ode23tb
function dydt = systemODE(t, y, inertia_func, damper_func, J1, b, A_constant_torque, w_frequency, time_steps)
    dt = time_steps(1);  % Assuming the same time step for ode45
    input_torque = getAppliedTorque(t, A_constant_torque, w_frequency);
    dydt = [inertia_func(input_torque, J1, dt, y(1)) + damper_func(y(1), b)];
end

% Helper function to get applied torque
function torque = getAppliedTorque(t, A_constant_torque, w_frequency)
    torque = A_constant_torque * sin(w_frequency * t);
end