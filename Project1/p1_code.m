w_0 = 1.0; %initialized values
J1 = 1;
b = 1;
A = 1;

dT = [0.001, 0.1, 1]; %array of the time steps needed to be used
solver = ["ode1", "ode4"]; %euler and runge katta identifers array
solver_name = ["Euler", "Runge Katta"]; %array of solver names

for i = 1:length(solver) %loops through the solver array for its length ie twice in this case
    solver_iteration = solver(i);
    % disp(solver_iteration(i));

    for z = 1:length(dT) %loops through the dT array for its length ie three times in this case
        step_iteration = dT(z);
        % disp(step_iteration);

        simout = sim("p1_model", "Solver", solver_iteration, "FixedStep", string(step_iteration)); %this is where the solver happens based on z and i

        w = simout.w.Data;
        wdot = simout.wdot.Data;
        T = simout.tout;

        % plotting part
        %for each solver and time step (eg euler and 0.1) the angle and
        %angular velocity are subplots on same figure
        %creates 6 total figures with 2 plots each

        figure;
        subplot(2, 1, 1);
        plot(T, wdot);
        title([solver_name(i), sprintf('dT = %d', step_iteration)], 'FontSize', 11);
        xlabel('Time [s]');
        ylabel('Angular Velocity [rad/s]');

        subplot(2, 1, 2);
        plot(T, w);
        xlabel('Time [s]');
        ylabel('Angle [rad]');

    end
end
