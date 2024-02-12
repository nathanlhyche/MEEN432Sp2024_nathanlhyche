% Define arrays
w_0_array = [10.0, 0.0];
J1_array = [100, 0.01];
b_array = [10, 0.1];
w_array = [0.1, 100];
A_array = [0.0, 100, sin(w_array(1)), sin(w_array(2))];

dT_array = [0.001, 0.1, 1]; % array of the time steps needed to be used
solver_array = ["ode1", "ode4"]; % Euler and Runge-Kutta identifiers array
solver_name_array = ["Euler", "Runge-Kutta"]; % array of solver names
solver2_array = ["ode45", "ode23tb"];

total_combinations = length(w_0_array) * length(J1_array) * length(b_array) * length(A_array) * length(solver_array) * length(dT_array);
simulation_times = [];
iteration_count = 0;

% Loop through all combinations
for i = 1:length(w_0_array)
    for j = 1:length(J1_array)
        for k = 1:length(b_array)
            for l = 1:length(A_array)
                for m = 1:length(solver_array)
                    for n = 1:length(dT_array)

                        w_0 = w_0_array(i);
                        J1 = J1_array(j);
                        b = b_array(k);
                        A = A_array(l);
                        solver_iteration = solver_array(m);
                        dT = dT_array(n);
                        
                        iteration_count = iteration_count + 1;
                        
                        disp(['Iteration ', num2str(iteration_count), ': w_0 = ', num2str(w_0), ', J1 = ', num2str(J1), ', b = ', num2str(b), ', A = ', num2str(A), ', Solver = ', char(solver_iteration), ', dT = ', num2str(dT)]);
                        

                        simulation_start_time = tic;
                        
                        %simulation for fixed step
                        simout = sim("p1_model", "Solver", solver_iteration, "FixedStep", string(dT));
                        w = simout.w.Data;
                        wdot = simout.wdot.Data;
                        T = simout.tout;
                        
                        % End timing n
                        simulation_end_time = toc(simulation_start_time);
                        disp(['Simulation time: ', num2str(simulation_end_time), ' seconds']);
                        
                        simulation_times = [simulation_times, simulation_end_time];
                        
                        if iteration_count == total_combinations
                            break;
                        end
                    end
                    if iteration_count == total_combinations
                        break;
                    end
                end
                if iteration_count == total_combinations
                    break;
                end
               
                if iteration_count == total_combinations
                    break;
                end
            end
            if iteration_count == total_combinations
                break;
            end
        end
        if iteration_count == total_combinations
            break;
        end
    end
    if iteration_count == total_combinations
        break;
    end
end

%variable time solvers
for s = 1:length(solver2_array)
    for i = 1:length(w_0_array)
        for j = 1:length(J1_array)
            for k = 1:length(b_array)
                for l = 1:length(A_array)
                    w_0 = w_0_array(i);
                    J1 = J1_array(j);
                    b = b_array(k);
                    A = A_array(l);
                    solver_iteration = solver2_array(s);

                    % iteration count starting at old iteration count
                    iteration_count = iteration_count + 1;

                    disp(['Iteration ', num2str(iteration_count), ': w_0 = ', num2str(w_0), ', J1 = ', num2str(J1), ', b = ', num2str(b), ', A = ', num2str(A), ', Solver = ', char(solver_iteration)]);

                    % Start timing 
                    simulation_start_time = tic;

                    % simulation for variable
                    simout = sim("p1_model", "Solver", solver_iteration);
                    w = simout.w.Data;
                    wdot = simout.wdot.Data;
                    T = simout.tout;

                    % End timing 
                    simulation_end_time = toc(simulation_start_time);
                    disp(['Simulation time: ', num2str(simulation_end_time), ' seconds']);

                    simulation_times = [simulation_times, simulation_end_time];

                    if iteration_count == total_combinations
                        break;
                    end
                end
                if iteration_count == total_combinations
                    break;
                end
            end
            if iteration_count == total_combinations
                break;
            end
        end
        if iteration_count == total_combinations
            break;
        end
    end
    if iteration_count == total_combinations
        break;
    end
end

% Plot cpu v time
figure;
plot(simulation_times, 'o-');

xlabel('Iteration');
ylabel('Time [seconds]');
title('CPUTimes');
