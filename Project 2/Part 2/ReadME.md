ReadME

Project 2 Week 2

To run:
  Open 'init.m', 'Project2_Part2_simulink_model.slx', and 'Project2_part2_combine_code.m'.  First, run the 'init.m' file to
initialize the variables needed for the simulation.  This includes vxd for the velocity of the car. Next, make sure the simulink
model is open and ready. Next, run the 'Project2_part2_combine_code.m' code.  This code basically is week 1 code that has been
modified.  It still has the same racetrack generator.  And after the racetrack is generated, the simulink model is run.  it is
run using the sim() command in matlab. Various data points are collected from the model using this sim() command. Next is the
animation of the car. Before it was just based on the same coordinates that made the racetrack now it is based on the X and Y 
coordinates from the simulink model.  Next, the racestat function is set up but it needs more work until it is finished.  

1. Your team will select a target speed and determine how fast your
 vehicle model can go around the track.

-This is done in the "init.m" file that we added to GitHub.  the velocity of vxd is set to 8 m/s

 2. Create a "Driver Model" subsystem within the Simulink model where
 there will be a lateral control to estimate the steering angle (delta_f) 

-instead of the simplest driver model.  we tried to use the lateral_control_function system to control delta_f.
The main issue with this function was that right after the first curved portion of the track, the straight away part started
at coordinates that were skewed a bit.  so it wasnt going completely straight but it was at an angle.

3. Develop a "Lateral Dynamics" subsystem that considers tire slip and tire
 forces to estimate the lateral velocity (v_y) and vehicle heading (psi)

-this is done with three individual subsystems.

 4. Develop a "Transformation/Rotation" function to transform and output
 the X and Y coordinates. Then using a "XY Graph" block, plot the vehicle
 path

-This part of the model uses similar code from the rotate.m code we have.  it transforms the velocities into X and Y coordinate
points that we can use to animate the car on the racetrack figure.

 5. Complete the loop by feeding the X, Y, and heading back to the Driver
 model subsystem 

-X and Y are fed back into the driver model and used to determine delta_f

## Week 2 Feedback (5/5)
Good Job Team 26! For the final submission, continue to work through the Simulink model and tweaking it so that you are able to stay on track and go around the track as fast as possible. The team will need to utilize the raceStat function somewhere in the MATLAB script to see how many loops the vehicle is able to do and to see information regarding the vehicle leaving the track.
