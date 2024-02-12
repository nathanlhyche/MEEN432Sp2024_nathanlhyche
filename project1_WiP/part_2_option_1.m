% Simulation with different stiffness values (k)

J1 = 100; b1 = 1;
J2 = 1; b2 = 1;
A_constant_torque_S1 = 1;
A_constant_torque_S2 = 1;

% Define angular frequency
w_frequency = 0.1;

% Simulation with different stiffness values
k_values = [10, 100, 1000];

figure;

for k = k_values
    % Simulate combined system
    [time_combined, angular_velocity_combined] = combinedSystemOption1(@inertia, @rotationalDamper, @inertia, @rotationalDamper, k, 0, 0, A_constant_torque_S1, A_constant_torque_S2, J1, b1, b2, A_constant_torque_S1, A_constant_torque_S2, w_frequency, 0.1, [0, 10]);

    % Plot results
    plot(time_combined, angular_velocity_combined, 'DisplayName', ['k = ' num2str(k)]);
    hold on;
end

title('Option 1 - Flexible Shaft (k)');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
legend('show');
grid on;
hold off;

% Inertia Function
function angular_velocity = inertia(input_torque, inertia_constant, dt, angular_velocity_inertia)
    angular_acceleration = input_torque / inertia_constant;
    angular_velocity = angular_velocity_inertia + angular_acceleration * dt;
end

% Rotational Damper Function (assuming a simple linear damper)
function damping_torque = rotationalDamper(angular_velocity, damping_coefficient)
    damping_torque = -damping_coefficient * angular_velocity;
end

% Helper function to get applied torque
function torque = getAppliedTorque(t, A_constant_torque, w_frequency)
    torque = A_constant_torque * sin(w_frequency * t);
end

% Function for simulation using Euler method
function [time, angular_velocity_combined] = combinedSystemOption1(inertia_func_S1, damper_func_S1, inertia_func_S2, damper_func_S2, stiffness_k, initial_angular_velocity_S1, initial_angular_velocity_S2, initial_input_torque_S1, initial_input_torque_S2, J1, b_S1, b_S2, A_constant_torque_S1, A_constant_torque_S2, w_frequency, dt, t_span)
    time = t_span(1):dt:t_span(2);
    angular_velocity_combined = zeros(size(time));
    angular_velocity_combined(1) = initial_angular_velocity_S1;
    
    for i = 2:length(time)
        input_torque_S1 = getAppliedTorque(time(i), A_constant_torque_S1, w_frequency);
        input_torque_S2 = getAppliedTorque(time(i), A_constant_torque_S2, w_frequency);
        
        torque_combined = input_torque_S1 - stiffness_k * (angular_velocity_combined(i-1) - initial_angular_velocity_S1) + input_torque_S2;
        
        angular_velocity_combined(i) = inertia_func_S1(torque_combined, J1, dt, angular_velocity_combined(i-1)) + damper_func_S1(angular_velocity_combined(i-1), b_S1);
    end
end
