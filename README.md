# cam-profile


Cam and Follower

```
The angular parameters – 

Total Displacement of ‘Follower’  = 10 mm
base_circle_diameter              = 80 mm
bottom_dwell_begin                = 0 degrees
bottom_dwell_end                  = 180 degree
rise_begin                        = 180 degree
rise_end                          = 267 degree
top_dwell_begin                   = 267 degree
top_dwell_end                     = 273 degree
fall_begin                        = 273 degree
fall_end                          = 360 degree
```

Meaning that the cam is designed in such a way that 
•	from 0° (handle at 15min location on a clock face) to 180° the ‘follower’ will remain in the resting position
•	starts moving beyond 180° and rises linearly with each degree
•	maximum displacement of follower is 10mm at 267°
•	from 267° to 273° the follower remains at the extreme position i.e. 10mm
•	after 273° it starts falling – returning to the base position
•	movement is again linear – equal displacement with each degree movement of cam and the movement is same in magnitude as while ascending.
•	It returns to the base position at completion of one rotation of Cam i.e at 360°.

Calculations – 
•	From 180° to 267° the follower rises 10mm
o	i.e. for each degree of rotation of cam the height of follower increase by 10/(267-180)mm from the base circle radius.
o	=> the radial distance of the surface of cam from the center increases by this much distance per degree till 267°
o	From 267° to 273° it remains the same
o	After 273° it starts decreasing the same amount per degree till it reaches the base circle radius at 360°.

![Picture 1](https://user-images.githubusercontent.com/44144990/224312239-f2b528eb-9a20-4928-99cf-5da63b286593.png)

So 	Tan(θ) = 10/87
	Θ	= ATAN(Tan(θ))

Now we can calculate the magnitude of displacement for each degree – i.e. zero at 180° to 10mm at 267° and so on

This displacement is addition to the base circle radius, thus we can calculate the radial distance between the center of rotation and the surface of the cam for each degree angle.

From this knowledge X and Y co-ordinates can be calculated and plotted to get the shape of the CAM.
