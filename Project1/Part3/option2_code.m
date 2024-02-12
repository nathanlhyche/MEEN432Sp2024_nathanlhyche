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


for x = 1:length(A_constant_torque_S1)
    torque_iteration = A_constant_torque_S1(x);
    torque_iteration2 = A_constant_torque_S2(x);

    for i = 1:length(solver) %loops through the solver array for its length ie twice in this case
        solver_iteration = solver(i);

        for z = 1:length(dT) %loops through the dT array for its length ie three times in this case
            step_iteration = dT(z);
            disp(['Solver = ', num2str(solver_iteration), ', dT = ', num2str(step_iteration, '%-4.1f'),', A_S1 = ', num2str(torque_iteration)]);

            simout = sim("option2", "Solver", solver_iteration, "FixedStep", string(step_iteration)); %this is where the solver happens based on z and i

            w = simout.w.Data;
            wdot = simout.wdot.Data;
            T = simout.tout;
            
        end   
    end
end

for x = 1:length(A_constant_torque_S2)
    torque_iteration2 = A_constant_torque_S2(x);
    solver = "ode45";
    solver_interation2 = solver(1);
    

    disp(['Solver = ', num2str(solver),', A_S2 = ', num2str(torque_iteration2)]);
    
    simout = sim("option2", "Solver", solver_interation2);
    w = simout.w.Data;
    wdot = simout.wdot.Data;
    T = simout.tout;
end