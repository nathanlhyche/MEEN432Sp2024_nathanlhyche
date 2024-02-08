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

% Simulation with fixed time step methods (Euler, Runge-Kutta 4th order)
for dt = time_steps
    % Euler integration
    [time_euler, angular_velocity_euler, angular_velocity_inertia] = simulateSystem(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia);
    
    % Runge-Kutta 4th order integration
    [time_rk4, angular_velocity_rk4, angular_velocity_inertia] = simulateSystemRK4(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, dt, t_span, angular_velocity_inertia);
    
    % Plot results for fixed time step methods
    figure;
    subplot(2, 1, 1);
    plot(time_euler, angular_velocity_euler, 'b', 'LineWidth', 2);
    hold on;
    plot(time_rk4, angular_velocity_rk4, 'r', 'LineWidth', 2);
    title(['Fixed Time Step Integration (dt = ' num2str(dt) 's)']);
    xlabel('Time (s)');
    ylabel('Angular Velocity (rad/s)');
    legend('Euler', 'Runge-Kutta 4th order');
    grid on;
    
    subplot(2, 1, 2);
    plot(time_euler, getAppliedTorque(time_euler, A_constant_torque, w_frequency), 'b--', 'LineWidth', 2);
    title('Applied Torque');
    xlabel('Time (s)');
    ylabel('Torque (N-m)');
    legend('Applied Torque');
    grid on;
    
    sgtitle('Inertia-Rotational Damper System Simulation');
end

% Simulation with variable time step methods (ode45, ode23tb)
% ode45
[t_ode45, angular_velocity_ode45] = simulateSystemODE45(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, t_span, time_steps);

% ode23tb
[t_ode23tb, angular_velocity_ode23tb] = simulateSystemODE23tb(@inertia, @rotationalDamper, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, t_span, time_steps);

% Plot results for variable time step methods
figure;
subplot(2, 1, 1);
plot(t_ode45, angular_velocity_ode45, 'g', 'LineWidth', 2);
hold on;
plot(t_ode23tb, angular_velocity_ode23tb, 'm', 'LineWidth', 2);
title('Variable Time Step Integration (ode45, ode23tb)');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
legend('ode45', 'ode23tb');
grid on;

subplot(2, 1, 2);
plot(t_ode45, getAppliedTorque(t_ode45, A_constant_torque, w_frequency), 'g--', 'LineWidth', 2);
title('Applied Torque');
xlabel('Time (s)');
ylabel('Torque (N-m)');
legend('Applied Torque');
grid on;

sgtitle('Inertia-Rotational Damper System Simulation');

% Save workspace variables
save('InertiaRotationalDamperSimulation.mat');

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

% Function for simulation using ode23tb method
function [time, angular_velocity] = simulateSystemODE23tb(inertia_func, damper_func, initial_angular_velocity, initial_input_torque, J1, b, A_constant_torque, w_frequency, t_span, time_steps)
    options = odeset('RelTol',1e-6,'AbsTol',1e-6);
    [time, states] = ode23tb(@(t, y) systemODE(t, y, inertia_func, damper_func, J1, b, A_constant_torque, w_frequency, time_steps), t_span, [initial_angular_velocity], options);
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