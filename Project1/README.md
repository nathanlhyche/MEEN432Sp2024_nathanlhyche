This is used to operate the Project 1 part 1 code

  You need to open both the p1_code.m and p1_model.slx
  Then run the p1_code.m 
  This should result in 6 different figures appear
    Each figure will have two subplots showing Omega v time and Omega dot v time.
    Each figure will cover one type of solver and time step
      eg. Euler and dT = 0.1 or Runge Katta and dT = 1 etc
  Within the p1_code.m, you can change the b A w_0 and J1 values to simulate the system with different values.
    This works as these variables are entered into the simulink model as teh variables so they will change whenever the p1_code.m is change and ran.

For part 2
  Basically, you just load the different codes and run them.  project1.m is for 1.1 and 1.2. project1b.m is for 1.3 and 1.4. We had some difficulty for this part.  For some graphs, all the information doesn't show up. The plots/graphs are correct but the data is weird and can't be inputted.

## Week 1 Feedback (5/5):
Great job guys! Keep it up for week 2, ya'll are on track! Only suggestion would be to now look into logic on how you can determine if your applied torque is constant, or sinusoidal. Also make sure to add proper titles to plots (angular velocity vs time), but other than keep it up!

## Week 2 Feedback (5/5)
Firstly I would say that while user input is fine for the project, you need to think of what exactly the user is able to change. The goal is to be able to have 256 simulations since we want to try different combinations of each of the system parameters and by making the user change this everytime, it can get very long. A suggestion would be to have these parameters as arrays when setting the system parameters and then including for loops within your script that is able to go through each value of the arrays while still capturing the information needed for the plots (this can be done either within the same script or a separate one) Regarding the plots produced in project1.m, you do not need to plot the rotational velocity or torque for the project 1 final submission. This was only a week 1 request due to how simple the model was at that point. The plots for project1b.m also look good but you only need to use the fixed time step solver simulations for the Error vs Time step and the CPU vs Time step plots. Please try to work through these changes for Part 1! Moving onto Part 2 of the project, the team will need to create different simulink models for the 3 options on how to connect System 2 to System 1. A suggestion would be to copt the model used for Part 1 and modifying it for each of the options. Once the entire project is complete make sure the commit all Part 1 and Part 2 files with the commit message " Project 1 Final"