disp(['Option 1 Model']);

% Simulation

J1 = 100; b1 = 1;
J2 = 1; b2 = 1;
A_constant_torque_S1 = [1, 100];
A_constant_torque_S2 = [1, 100];

% Define angular frequency
w_frequency = 0.1;

% Simulation with different stiffness values
k_values = [10, 100, 1000];

dT = [0.1, 1.0]; %array of the time steps needed to be used
solver = ["ode1", "ode4"]; %euler and runge katta identifers array
solver_name = ["Euler", "Runge Katta"]; %array of solver names

simulation_times_option1 = [];

for x = 1:length(A_constant_torque_S1)
    torque_iteration = A_constant_torque_S1(x);
    torque_iteration2 = A_constant_torque_S2(x);
    for k = 1:length(k_values) % Loop through different stiffness values
        stiffness = k_values(k);
        for i = 1:length(solver) %loops through the solver array for its length ie twice in this case
            solver_iteration = solver(i);

            for z = 1:length(dT) %loops through the dT array for its length ie three times in this case
                step_iteration = dT(z);
                disp(['Solver = ', num2str(solver_iteration), ', dT = ', num2str(step_iteration, '%-4.1f'),', A_S1 = ', num2str(torque_iteration), ', k = ', num2str(stiffness)]);
                

                simulation_start_time1 = tic;
                simout = sim("option1", "Solver", solver_iteration, "FixedStep", string(step_iteration)); %this is where the solver happens based on z and i

                w = simout.w.Data;
                wdot = simout.wdot.Data;
                T = simout.tout;

                simulation_end_time1 = toc(simulation_start_time1);
                %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

                simulation_times_option1 = [simulation_times_option1, simulation_end_time1];
                
            end
        end   
    end
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
figure;
hold on
subplot(2, 1, 1)
plot(T, wdot_slice);
title('Option 1: Last Inputted Conditions ode4');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');

for x = 1:length(A_constant_torque_S2)
    torque_iteration2 = A_constant_torque_S2(x);
    solver = "ode45";
    solver_interation2 = solver(1);
    
    for k = 1:length(k_values)
        stiffness = k_values(k);
        disp(['Solver = ', num2str(solver),', A_S2 = ', num2str(torque_iteration2),', k = ', num2str(stiffness)]);
        
        simulation_start_time1 = tic;
        simout = sim("option1", "Solver", solver_interation2);
        w = simout.w.Data;
        wdot = simout.wdot.Data;
        T = simout.tout;
        simulation_end_time1 = toc(simulation_start_time1);
        %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

        simulation_times_option1 = [simulation_times_option1, simulation_end_time1];
    end
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
subplot(2, 1, 2)
plot(T, wdot_slice);
title('Option 1: Last Inputted Conditions ode45');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');
hold off

disp(['Option 2 Model']);

% Simulation

J1 = 100; b1 = 1;
J2 = 1; b2 = 1;
A_constant_torque_S1 = [1, 100];
A_constant_torque_S2 = [1, 100];

% Define angular frequency
w_frequency = 0.1;

dT = [0.1, 1.0]; %array of the time steps needed to be used
solver = ["ode1", "ode4"]; %euler and runge katta identifers array
solver_name = ["Euler", "Runge Katta"]; %array of solver names

simulation_times_option2 = [];

for x = 1:length(A_constant_torque_S1)
    torque_iteration = A_constant_torque_S1(x);
    torque_iteration2 = A_constant_torque_S2(x);

    for i = 1:length(solver) %loops through the solver array for its length ie twice in this case
        solver_iteration = solver(i);

        for z = 1:length(dT) %loops through the dT array for its length ie three times in this case
            step_iteration = dT(z);
            disp(['Solver = ', num2str(solver_iteration), ', dT = ', num2str(step_iteration, '%-4.1f'),', A_S1 = ', num2str(torque_iteration)]);
            simulation_start_time2 = tic;
            simout = sim("option2", "Solver", solver_iteration, "FixedStep", string(step_iteration)); %this is where the solver happens based on z and i

            w = simout.w.Data;
            wdot = simout.wdot.Data;
            T = simout.tout;
            simulation_end_time2 = toc(simulation_start_time2);
            %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

            simulation_times_option2 = [simulation_times_option2, simulation_end_time2];
            
        end   
    end
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
figure;
hold on
subplot(2, 1, 1)
plot(T, wdot_slice);
title('Option 2: Last Inputted Conditions ode4');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');

for x = 1:length(A_constant_torque_S2)
    torque_iteration2 = A_constant_torque_S2(x);
    solver = "ode45";
    solver_interation2 = solver(1);

    disp(['Solver = ', num2str(solver),', A_S2 = ', num2str(torque_iteration2)]);
    simulation_start_time2 = tic;
    simout = sim("option2", "Solver", solver_interation2);
    w = simout.w.Data;
    wdot = simout.wdot.Data;
    T = simout.tout;
    simulation_end_time2 = toc(simulation_start_time2);
    %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

    simulation_times_option2 = [simulation_times_option2, simulation_end_time2];
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
subplot(2, 1, 2)
plot(T, wdot_slice);
title('Option 2: Last Inputted Conditions ode45');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');
hold off

disp(['Option 3 Model']);

% Simulation

J1 = 100; b1 = 1;
J2 = 1; b2 = 1;
A_constant_torque_S1 = [1, 100];
A_constant_torque_S2 = [1, 100];

% Define angular frequency
w_frequency = 0.1;

dT = [0.1, 1.0]; %array of the time steps needed to be used
solver = ["ode1", "ode4"]; %euler and runge katta identifers array
solver_name = ["Euler", "Runge Katta"]; %array of solver names

simulation_times_option3 = [];

for x = 1:length(A_constant_torque_S1)
    torque_iteration = A_constant_torque_S1(x);
    torque_iteration2 = A_constant_torque_S2(x);

    for i = 1:length(solver) %loops through the solver array for its length ie twice in this case
        solver_iteration = solver(i);

        for z = 1:length(dT) %loops through the dT array for its length ie three times in this case
            step_iteration = dT(z);
            disp(['Solver = ', num2str(solver_iteration), ', dT = ', num2str(step_iteration, '%-4.1f'),', A_S1 = ', num2str(torque_iteration)]);
            simulation_start_time3 = tic;
            simout = sim("option3", "Solver", solver_iteration, "FixedStep", string(step_iteration)); %this is where the solver happens based on z and i

            w = simout.w.Data;
            wdot = simout.wdot.Data;
            T = simout.tout;
            simulation_end_time3 = toc(simulation_start_time3);
            %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

            simulation_times_option3 = [simulation_times_option3, simulation_end_time3];
        end   
    end
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
figure;
hold on
subplot(2, 1, 1)
plot(T, wdot_slice);
title('Option 3: Last Inputted Conditions ode4');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');

for x = 1:length(A_constant_torque_S2)
    torque_iteration2 = A_constant_torque_S2(x);
    solver = "ode45";
    solver_interation2 = solver(1);
    
    disp(['Solver = ', num2str(solver),', A_S2 = ', num2str(torque_iteration2)]);
    simulation_start_time3 = tic;
    simout = sim("option3", "Solver", solver_interation2);
    w = simout.w.Data;
    wdot = simout.wdot.Data;
    T = simout.tout;
    simulation_end_time3 = toc(simulation_start_time3);
    %disp(['Simulation time: ', num2str(simulation_end_time1), ' seconds']);

    simulation_times_option3 = [simulation_times_option3, simulation_end_time3];
end

% Squeeze wdot to remove singleton dimensions
wdot_squeezed = squeeze(wdot);

% 
wdot_slice = wdot_squeezed(2,:,1);  % Choose the first slice

% Plot
subplot(2, 1, 2)
plot(T, wdot_slice);
title('Option 3: Last Inputted Conditions ode45');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]');
hold off

% Plot cpu v time
figure;
subplot(3, 1, 1)
plot(simulation_times_option1, 'o-');

xlabel('Iteration');
ylabel('Time [s]');
title('CPU Times vs. Time for Option 1');

subplot(3, 1, 2)
plot(simulation_times_option2, 'o-');

xlabel('Iteration');
ylabel('Time [s]');
title('CPU Times vs. Time for Option 2');

subplot(3, 1, 3)
plot(simulation_times_option3, 'o-');

xlabel('Iteration');
ylabel('Time [s]');
title('CPU Times vs. Time for Option 3');