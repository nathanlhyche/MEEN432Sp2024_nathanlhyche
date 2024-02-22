ReadME Part 1

1) The first part of part 1 is the P1_part1_racetrack.  It is used to simulate the racetrack coordinates.  the four 
if statements follow the length traveled variable.  ie the first if statement is for distance traveled under 900m and
then after that it is 900 - 1528m and so on for all the other sections.  the way point arrays are used to plot the racetrack 
locations based on the amount of waypoints used. there is also a theta array that has the individual values of the angle
based on its change.

2) The second part of this project uses the code from part 1 and building off of it.  the new code with the old code is 
found in P1_part1_racetrack_with_moving_car_patch.m.  for the new code all you have to do is run it.  it will create the
racetrack based on the amount of waypoints needed.  and then create a box car which will move around the track and turn 
based on the curvature of the semi circles. it will also make a line that shows where the car has traveled.  

Also, the width of the race track is made by adjusting the linewidth in the plot command.  is this right? or should coordinate
points be made to adjust for the added width so that it can be used later on in the project?

## Week 1 Feedback (5/5)
I had to debug a little bit for the vehicle simulation to run. There were some issues with the call of variabales (radius, straight_length, and width). After debugging, the vehicle looked good! For Week 2, start developing a lateral dynamic model of a vehicle that contains subsystems that are listed in the Week 2 document.
