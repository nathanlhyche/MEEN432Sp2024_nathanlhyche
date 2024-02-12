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

FOR PART 3 ### READ ME
  last week we didn't really complete the 256 simulations part of the project.  so we tried to fix that.  we managed to create Part2_256_Mostly_Complete.m.  this code file runs through all the 32 initial conditions for for 8 different times depending on the solver and/or the time step.  this also plots the cpu time v time for all the simulations.  it doesnt do the error graphs as we focused on the part 3 stuff. and we also had the error part pretty complete with our other part 2 code.  

  for the part 3 stuff, the code portions were pretty straight forward. ( this can be found in the part 3 folder ).  the code is to run the different simulink models while inputting different initial conditions.  This part of pretty much good.  There was some issues about the shaft speed graphs. the code can be found in the combined_options_code.m or the option1_code.m 2, 3 etc. basically the code as individual for loop sections that interate through the relevant variables for each option and solver type.  you basically just need to the run the code and have option1.slm 2, 3 etc in the folders for the sim() command to work.  also the cput time graph is created for all simualtions. the cpu time is found using tic tac feature in matlab.
  Honestly, the hardest part of this was the creation of the simulink models.  the professor really didnt go over this stuff and its has been a while since meen 364.  lecture 3b was helpful but we still had trouble.  also, we did get confused for some parts.  for instance, the old part 1 simulinke model has an initial condition of w_0 we didnt know what to do with this. like are we supposed to have a new condition idk. so we had a rough time on that.  Also we created extra code and found in project1_WIP which does simulate the system we just didnt know if it is what you were looking for as it didnt use simulink models. instead it used inertia functions etc. So these code files could be correct as well. they do provide what looks to be more accurate shaft speed v time graphs than the combined code so idk. 

## Week 1 Feedback (5/5):
Great job guys! Keep it up for week 2, ya'll are on track! Only suggestion would be to now look into logic on how you can determine if your applied torque is constant, or sinusoidal. Also make sure to add proper titles to plots (angular velocity vs time), but other than keep it up!

## Week 2 Feedback (5/5)
Firstly I would say that while user input is fine for the project, you need to think of what exactly the user is able to change. The goal is to be able to have 256 simulations since we want to try different combinations of each of the system parameters and by making the user change this everytime, it can get very long. A suggestion would be to have these parameters as arrays when setting the system parameters and then including for loops within your script that is able to go through each value of the arrays while still capturing the information needed for the plots (this can be done either within the same script or a separate one) Regarding the plots produced in project1.m, you do not need to plot the rotational velocity or torque for the project 1 final submission. This was only a week 1 request due to how simple the model was at that point. The plots for project1b.m also look good but you only need to use the fixed time step solver simulations for the Error vs Time step and the CPU vs Time step plots. Please try to work through these changes for Part 1! Moving onto Part 2 of the project, the team will need to create different simulink models for the 3 options on how to connect System 2 to System 1. A suggestion would be to copt the model used for Part 1 and modifying it for each of the options. Once the entire project is complete make sure the commit all Part 1 and Part 2 files with the commit message " Project 1 Final"
