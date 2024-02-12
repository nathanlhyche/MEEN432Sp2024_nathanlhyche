J1 = 100; b1 = 1;
J2 = 1; b2 = 1;
A_constant_torque_S1 = 1;
A_constant_torque_S2 = 1;
w_frequency = 0.1;
dt = 0.1;  % Time step
t_span = [0, 10];  % Simulation time span

% Simulate combined system for Option 3 with constant step inputs
[time_combined, angular_velocity_combined] = combinedSystemOption3(@inertia, @rotationalDamper, @inertia, @rotationalDamper, J2, A_constant_torque_S1, A_constant_torque_S2, w_frequency, dt, t_span);

% Plot results
figure;
plot(time_combined, angular_velocity_combined);
title('Option 3 - Pass Inertia and Integration to S2');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
grid on;

% Inertia Function
function angular_velocity = inertia(input_torque, inertia_constant, dt, angular_velocity_inertia)
    angular_acceleration = input_torque / inertia_constant;
    angular_velocity = angular_velocity_inertia + angular_acceleration * dt;
end

% Rotational Damper Function (assuming a simple linear damper)
function damping_torque = rotationalDamper(angular_velocity)
    damping_coefficient = 1;  % Replace with your damping coefficient if available
    damping_torque = -damping_coefficient * angular_velocity;
end


% Helper function to get applied torque
function torque = getAppliedTorque(t, A_constant_torque, w_frequency)
    torque = A_constant_torque * sin(w_frequency * t);
end

% Function for simulation using Euler method
function [time, angular_velocity_combined] = combinedSystemOption3(inertia_func_S1, damper_func_S1, inertia_func_S2, damper_func_S2, J2, A_constant_torque_S1, A_constant_torque_S2, w_frequency, dt, t_span)
    time = t_span(1):dt:t_span(2);
    angular_velocity_combined = zeros(size(time));
    angular_velocity_combined(1) = 0;  % Initial angular velocity for the combined system
    
    for i = 2:length(time)
        input_torque_S1 = getAppliedTorque(time(i), A_constant_torque_S1, w_frequency);
        
        % Pass inertia and integration responsibility to S2
        angular_velocity_S2 = inertia_func_S2(input_torque_S1, J2, dt, angular_velocity_combined(i-1)) + damper_func_S2(angular_velocity_combined(i-1));
        
        % Combine results
        angular_velocity_combined(i) = angular_velocity_S2;
    end
end
