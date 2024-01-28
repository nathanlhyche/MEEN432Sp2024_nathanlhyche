w_0 = 1.0;
J1 = 1;
b = 1;
A = 1;

dT = [0.001, 0.1, 1];
solver = ["ode1", "ode4"];
simout = sim("p1_model","Solver",solver,"FixedStep",string(dT));

w = simout.w.Data;
wdot = simout.wdot.Data;
T = simout.tout;

figure(1)
plot(wdot,T);
figure(2)
plot(w, T);                                                 
