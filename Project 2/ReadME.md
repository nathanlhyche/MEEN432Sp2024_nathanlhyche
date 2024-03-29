ReadMe

## Week 2 Feedback (5/5)
Good Job Team 26! For the final submission, continue to work through the Simulink model 
and tweaking it so that you are able to stay on track and go around the track as fast as 
possible. The team will need to utilize the raceStat function somewhere in the MATLAB 
script to see how many loops the vehicle is able to do and to see information regarding 
the vehicle leaving the track.

Project 2 Week 3

To run:
Open 'init.m', 'Project2_Part2_simulink_model.slx', and 'Project2_Part2_combine_code.m'.  
First, run the 'init.m' file to initialize the variables needed for the simulation. 
This includes vxd (set to 8 m/s) for the velocity of the car. Next, make sure the 
simulink model is open and ready. Next, run the 'Project2_Part2_combine_code.m' code. 
This code is the modified code based on Part 1 and 2.  After the racetrack is generated, 
the simulink model is run using the sim() command in MATLAB. Various data points are 
collected from the model using this command. Next is the animation of the car based on 
the X and Y coordinates from the simulink model. The raceStat function has been 
implemented and the corresponding statistics data are outputted.

For Week 3, the raceStat function has been defined at the bottom of the MATLAB script. 
The function takes X and Y coordinates from the updated vehicle simulations and t, 
the set times corresponding to X and Y. 'Path' is a structure with fields based on 
the given track geometry. When called, the raceStats function outputs the number of 
loops the vehicles has taken around the track during the simulation, an array of times
indicating when the starting line was crossed, and the X, Y, and t values when the 
vehicle went out of the track. Additionally, below the raceStats function, a 
displayRaceStats function was created to print the output of raceStats to the command 
window in a readable format. These functions are called in the body of the code, 
displaying the information immediately upon running the script.

Upon examination of the XY graph output in the simulink model, it is clear that the 
vehicle stays within the bounds of the track. There is more variability among the 
vehicle positions along the straightaways than there are during the two curves. 
Within the lateral control function, which was used instead of simple driver, the 
velocities which are transformed to X and Y coordinates are fed back into the driver 
model to control delta f. The reason for the increased variability among the 
straightaways is likely due to the slightly skewed coordinates at the completion 
of the first turn. This resulted in a slight angle along the straights instead 
of the ideal straight line.

## Final Week Feedback (78/85)
The first thing I want to point out is that the init.m file was not submitted with the final submission meaning that none of the scripts or model was able to run correctly. I took points off for this but since the vehicle is able to run and stays within the track I did not take off too many points. As a reminder, please make sure to double/triple check that all the files that are needed to properly run the simulation need to be included for the final submission. In the future, there will be a larger penalty as if some files are not submitted, it will lead to points being taken off due to the model not simulating properly. I would also like to add that for the individual members to succeed in Project 4, I would advise each member to work on the driver model from Project 2 and to improve on the pure pursuit logic while working through Project 3. A more sophisticated model will allow for the vehicle to move faster depending on where it is on the track which will be important for Project 4, as each member will need to combine this model with the Project 3 model to create a vehicle that can move around the track as fast as possible while simulating the lateral and longitudinal dynamics of the vehicle. 
